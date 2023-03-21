local M = {}

M.root_patterns = { ".git", "lua" }

-- window {{{

function M.is_top(nr)
  nr = nr or 0
  local pos = vim.fn.win_screenpos(nr)
  local tab = vim.o.showtabline
  local top = (tab == 2 or (tab == 1 and vim.fn.tabpagenr("$"))) and 2 or 1
  return pos[1] == top
end

function M.is_bottom(nr)
  nr = nr or 0
  local row = vim.fn.win_screenpos(nr)[1]
  local height = vim.fn.winheight(nr)
  local bottom = vim.o.lines
  if vim.opt.laststatus >= 2 then
    bottom = bottom - 1
  end
  return row + height - 1 >= bottom
end

function M.is_left(nr)
  nr = nr or 0
  local col = vim.fn.win_screenpos(nr)[2]
  return col == 1
end

function M.is_right(nr)
  nr = nr or 0
  local col = vim.fn.win_screenpos(nr)[2]
  local width = vim.fn.winwidth(nr)
  return col + width - 1 >= vim.o.columns
end

function M.move_left()
  if M.is_left() then
    vim.cmd.tabprevious()
  else
    vim.cmd.wincmd("h")
  end
end

function M.move_right()
  if M.is_right() then
    vim.cmd.tabnext()
  else
    vim.cmd.wincmd("l")
  end
end

function M.move_up()
  if M.is_top() then
    vim.cmd.tabprevious()
  else
    vim.cmd.wincmd("k")
  end
end

function M.move_down()
  if M.is_top() then
    vim.cmd.tabnext()
  else
    vim.cmd.wincmd("j")
  end
end

-- }}}

-- lazy {{{

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

-- }}}

-- telescope {{{

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- If the cwd (whether provided or auto) has a .git folder
-- Then use git file instead of find file
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

function M.allow_find_files()
  local restriction = vim.fn.expand("~") .. "/" -- itself is not matched
  local pwd = vim.loop.cwd()
  return pwd and pwd:sub(1, #restriction) == restriction
end

-- }}}

-- lsp and code actions {{{

function M.rename()
  if pcall(require, "inc_rename") then
    return ":IncRename " .. vim.fn.expand("<cword>")
  else
    vim.lsp.buf.rename()
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

-- }}}

-- cmp {{{

function M.has_words_before()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- }}}

-- neovim-session-manager {{{
function M.has_session(dir)
  local ok, ssmgmt = pcall(require, "session_manager.utils")
  if not ok then
    return false
  end
  if not dir then
    dir = vim.loop.cwd()
  end
  local session_name = ssmgmt.dir_to_session_filename(dir)
  return session_name:exists()
end

-- }}}

return M

-- vim: set foldmethod=marker
