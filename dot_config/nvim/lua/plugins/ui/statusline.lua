return function(_, _)
  local conditions = require("heirline.conditions")
  local utils = require("heirline.utils")

  local Align = { provider = "%=" }
  local Space = { provider = " " }

  local function get_highlight(name)
    local hl = utils.get_highlight(name)
    return {
      bg = hl.bg,
      fg = hl.fg or hl.sp,
    }
  end
  local colors = {
    bright_bg = get_highlight("Folded").bg,
    bright_fg = get_highlight("Folded").fg,
    red = get_highlight("DiagnosticError").fg,
    dark_red = get_highlight("DiffDelete").bg,
    green = get_highlight("String").fg,
    blue = get_highlight("Function").fg,
    gray = get_highlight("NonText").fg,
    orange = get_highlight("Constant").fg,
    purple = get_highlight("Statement").fg,
    cyan = get_highlight("Special").fg,
    diag_warn = get_highlight("DiagnosticWarn").fg,
    diag_error = get_highlight("DiagnosticError").fg,
    diag_hint = get_highlight("DiagnosticHint").fg,
    diag_info = get_highlight("DiagnosticInfo").fg,
    git_del = get_highlight("diffRemoved").fg,
    git_add = get_highlight("diffAdded").fg,
    git_change = get_highlight("diffChanged").fg,
  }

  require("heirline").load_colors(colors)

  local ViMode = {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
      self.mode = vim.fn.mode(1) -- :h mode()

      -- execute this only once, this is required if you want the ViMode
      -- component to be updated on operator pending mode
      if not self.once then
        vim.api.nvim_create_autocmd("ModeChanged", {
          pattern = { "*:*o", "c:*" },
          command = "redrawstatus",
        })
        self.once = true
      end
    end,
    -- Now we define some dictionaries to map the output of mode() to the
    -- corresponding string and color. We can put these into `static` to compute
    -- them at initialisation time.
    static = {
      mode_names = { -- change the strings if you like it vvvvverbose!
        n = "N",
        no = "N?",
        nov = "N?",
        noV = "N?",
        ["no\22"] = "N?",
        niI = "Ni",
        niR = "Nr",
        niV = "Nv",
        nt = "Nt",
        v = "V",
        vs = "Vs",
        V = "V_",
        Vs = "Vs",
        ["\22"] = "^V",
        ["\22s"] = "^V",
        s = "S",
        S = "S_",
        ["\19"] = "^S",
        i = "I",
        ic = "Ic",
        ix = "Ix",
        R = "R",
        Rc = "Rc",
        Rx = "Rx",
        Rv = "Rv",
        Rvc = "Rv",
        Rvx = "Rv",
        c = "C",
        cv = "Ex",
        r = "...",
        rm = "M",
        ["r?"] = "?",
        ["!"] = "!",
        t = "T",
      },
      mode_colors = {
        n = "red",
        i = "green",
        v = "cyan",
        V = "cyan",
        ["\22"] = "cyan",
        c = "orange",
        s = "purple",
        S = "purple",
        ["\19"] = "purple",
        R = "orange",
        r = "orange",
        ["!"] = "red",
        t = "red",
      },
    },
    -- We can now access the value of mode() that, by now, would have been
    -- computed by `init()` and use it to index our strings dictionary.
    -- note how `static` fields become just regular attributes once the
    -- component is instantiated.
    -- To be extra meticulous, we can also add some vim statusline syntax to
    -- control the padding and make sure our string is always at least 2
    -- characters long. Plus a nice Icon.
    provider = function(self)
      return " %2(" .. self.mode_names[self.mode] .. "%)"
    end,
    -- Same goes for the highlight. Now the foreground will change according to the current mode.
    hl = function(self)
      local mode = self.mode:sub(1, 1) -- get only the first mode character
      return { fg = self.mode_colors[mode], bold = true }
    end,
    -- Re-evaluate the component only on ModeChanged event!
    -- This is not required in any way, but it's there, and it's a small
    -- performance improvement.
    update = {
      "ModeChanged",
    },
  }

  local Snippets = {
    -- check that we are in insert or select mode
    condition = function()
      return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
    end,
    provider = function()
      local ok, luasnip = pcall(require, "luasnip")
      if not ok then
        return ""
      end
      local forward = luasnip.jumpable(1)
      local backward = luasnip.jumpable(-1)
      if forward and backward then
        return "󰹳 "
      elseif forward then
        return "󰁔 "
      elseif backward then
        return "󰁍 "
      end
      return ""
    end,
    hl = { fg = "red", bold = true },
  }

  ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode, Snippets })

  local FileName = {
    provider = function(self)
      -- first, trim the pattern relative to the current directory. For other
      -- options, see :h filename-modifers
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then
        return "[No Name]"
      end
      -- now, if the filename would occupy more than 1/4th of the available
      -- space, we trim the file path to its initials
      -- See Flexible Components section below for dynamic truncation
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
      end
      return filename
    end,
    hl = { fg = utils.get_highlight("Directory").fg },
  }

  local Indent = {
    provider = function()
      local expandtab = vim.bo.expandtab
      local tabstop = vim.bo.tabstop
      local shiftwidth = vim.bo.shiftwidth or tabstop -- when zero 'ts' will be used
      if expandtab then
        -- All tabs are expected to be spaces instead
        return "󱁐" .. shiftwidth
      end
      local softtabstop = vim.bo.softtabstop
      softtabstop = softtabstop < 0 and shiftwidth or (softtabstop or tabstop)
      local msg = "" .. softtabstop
      if softtabstop ~= tabstop then
        msg = msg .. "󰞔" .. tabstop
      end
      if softtabstop ~= shiftwidth then
        msg = msg .. "󰄾" .. shiftwidth
      end
    end,
  }

  local FileType = {
    provider = function()
      return string.upper(vim.bo.filetype)
    end,
    hl = { fg = utils.get_highlight("Type").fg, bold = true },
  }

  local FileEncoding = {
    provider = function()
      local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
      return enc ~= "utf-8" and enc:upper()
    end,
  }

  local FileFormat = {
    provider = function()
      local fmt = vim.bo.fileformat
      return fmt ~= "unix" and fmt:upper()
    end,
  }

  -- We're getting minimalists here!
  local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%l/%L%:%c",
  }

  -- local TSActive ={
  --   -- condition = conditions.
  -- }

  local LSPActive = {
    condition = conditions.lsp_attached,
    update = { "LspAttach", "LspDetach" },

    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    provider = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return " [" .. table.concat(names, " ") .. "]"
    end,
    hl = { fg = "green", bold = true },
  }

  -- I personally use it only to display progress messages!
  -- See lsp-status/README.md for configuration options.
  -- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
  -- local LSPMessages = {
  --   provider = require("lsp-status").status,
  --   hl = { fg = "gray" },
  -- }

  local Diagnostics = {

    condition = conditions.has_diagnostics,

    -- static = {
    --   error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    --   warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    --   info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    --   hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    -- },

    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.since_hints = self.hints > 0
      self.since_info = self.since_hints or self.info > 0
      self.since_warnings = self.since_info or self.warnings > 0
    end,

    update = { "DiagnosticChanged", "BufEnter" },

    {
      provider = "󱍼 ",
      hl = function(self)
        return {
          fg = self.errors > 0 and "diag_error"
            or self.warnings > 0 and "diag_warn"
            or self.info > 0 and "diag_info"
            or "diag_hint",
        }
      end,
    },
    {
      provider = function(self)
        return self.errors .. (self.since_warnings and " " or "")
      end,
      condition = function(self)
        return self.errors > 0
      end,
      hl = { fg = "diag_error" },
    },
    {
      provider = function(self)
        return self.warnings .. (self.since_info and " " or "")
      end,
      condition = function(self)
        return self.warnings > 0
      end,
      hl = { fg = "diag_warn" },
    },
    {
      provider = function(self)
        return self.info .. (self.since_hints and " " or "")
      end,
      condition = function(self)
        return self.info > 0
      end,
      hl = { fg = "diag_info" },
    },
    {
      provider = function(self)
        return self.hints > 0 and self.hints
      end,
      hl = { fg = "diag_hint" },
    },
  }

  local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
      ---@diagnostic disable-next-line: undefined-field
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    hl = { fg = "orange" },

    -- git branch name
    {
      provider = function(self)
        return " " .. self.status_dict.head
      end,
      hl = { bold = true },
    },
    -- git status
    {
      condition = function(self)
        return self.has_changes
      end,
      fallthrough = false,
      {
        condition = function(self)
          return self.status_dict.changed ~= 0
        end,
        provider = "~",
        hl = { fg = "git_change" },
      },
      {
        condition = function(self)
          return self.status_dict.added ~= 0
        end,
        provider = "+",
        hl = { fg = "git_add" },
      },
      {
        condition = function(self)
          return self.status_dict.removed ~= 0
        end,
        provider = "-",
        hl = { fg = "git_del" },
      },
    },
  }

  local TerminalName = {
    -- we could add a condition to check that buftype == 'terminal'
    -- or we could do that later (see #conditional-statuslines below)
    provider = function()
      local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
      return " " .. tname
    end,
    hl = { fg = "blue", bold = true },
  }

  local HelpFileName = {
    condition = function()
      return vim.bo.filetype == "help"
    end,
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = { fg = colors.blue },
  }

  local DefaultStatusline = {
    ViMode,
    Space,
    FileName,
    Space,
    Git,
    Space,
    Diagnostics,
    Align,
    -- Navic,
    -- DAPMessages,
    Align,
    LSPActive,
    Space,
    -- LSPMessages,
    -- Space,
    -- UltTest,
    -- Space,
    FileType,
    Space,
    Indent,
    FileEncoding,
    FileFormat,
    Space,
    Ruler,
    -- Space,
    -- ScrollBar,
  }

  local InactiveStatusline = {
    condition = conditions.is_not_active,
    FileType,
    Space,
    FileName,
    Align,
  }

  local SpecialStatusline = {
    condition = function()
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive" },
      })
    end,

    FileType,
    Space,
    HelpFileName,
    Align,
  }

  local TerminalStatusline = {

    condition = function()
      return conditions.buffer_matches({ buftype = { "terminal" } })
    end,

    hl = { bg = "dark_red" },

    -- Quickly add a condition to the ViMode to only show it when buffer is active!
    { condition = conditions.is_active, ViMode, Space },
    FileType,
    Space,
    TerminalName,
    Align,
  }

  local StatusLines = {

    hl = function()
      if conditions.is_active() then
        return "StatusLine"
      else
        return "StatusLineNC"
      end
    end,

    -- the first statusline with no condition, or which condition returns true is used.
    -- think of it as a switch case with breaks to stop fallthrough.
    fallthrough = false,

    SpecialStatusline,
    TerminalStatusline,
    InactiveStatusline,
    DefaultStatusline,
  }

  return {
    statusline = StatusLines,
  }
end
