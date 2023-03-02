-- default: global, noremap, mode = n, silent, unique
-- lhs = {rhs, desc, mode, remap, silent, unique}
-- or lhs = function -> the table above
local Utils = require("configs.utils")
local format = require("plugins.lsp.format").format

local function load_keymap(km)
  local lhs = km[1]
  local rhs = km[2]
  local mode = km.mode or "n"
  local opts = { silent = true }
  for k, v in pairs(km) do
    if k ~= 1 and k ~= 2 and k ~= "mode" then
      opts[k] = v
    end
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function find_file_or_session()
  if Utils.allow_find_files() then
    return require("telescope.builtin").find_files()
  else
    vim.notify("Don't search files at " .. vim.loop.cwd())
    return vim.cmd("SessionManager load_session")
  end
end

local M = {
  general = {
    { "j", "v:count == 0 ? 'gj' : 'j'", expr = true },
    { "k", "v:count == 0 ? 'gk' : 'k'", expr = true },
    { "<S-h>", "<C-w>h", desc = "Go to left window" },
    { "<S-j>", "<C-w>j", desc = "Go to lower window" },
    { "<S-k>", "<C-w>k", desc = "Go to upper window" },
    { "<S-l>", "<C-w>l", desc = "Go to right window" },
    { "<C-Up>", "<cmd>resize +2<cr>", desc = "Increase window height" },
    { "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease window height" },
    { "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Decrease window width" },
    { "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase window width" },
  },
  -- additional: [has] for lsp capability
  lsp = {
    config = function()
      local tele_builtin = require("telescope.builtin")
      return {
        { "gd", tele_builtin.lsp_definitions, desc = "Goto Definition" },
        { "gr", tele_builtin.lsp_references, desc = "References" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gI", tele_builtin.lsp_implementations, desc = "Goto Implementation" },
        { "gt", tele_builtin.lsp_type_definitions, desc = "Goto Type Definition" },
        { "K", vim.lsp.buf.hover, desc = "Hover" },
        { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        {
          "<c-k>",
          vim.lsp.buf.signature_help,
          mode = "i",
          desc = "Signature Help",
          has = "signatureHelp",
        },
        { "<leader>ld", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "]d", Utils.diagnostic_goto(true), desc = "Next Diagnostic" },
        { "[d", Utils.diagnostic_goto(false), desc = "Prev Diagnostic" },
        { "]e", Utils.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
        { "[e", Utils.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
        { "]w", Utils.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
        { "[w", Utils.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
        {
          "<leader>ca",
          vim.lsp.buf.code_action,
          desc = "Code Action",
          mode = { "n", "v" },
          has = "codeAction",
        },
        { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
        {
          "<leader>cf",
          format,
          desc = "Format Range",
          mode = "v",
          has = "documentRangeFormatting",
        },
        {
          "<leader>cr",
          Utils.rename,
          expr = true,
          desc = "Rename",
          has = "rename",
        },
      }
    end,
  },
  cmp = {
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      return {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif Utils.has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }
    end,
  },
  telescope = {
    lazy = function()
      local tele_builtin = require("telescope.builtin")
      return {
        { "<leader>,", tele_builtin.buffers, desc = "Switch Buffer" },
        { "<leader>/", Utils.telescope("live_grep"), desc = "Find in Files (Grep)" },
        { "<leader>:", tele_builtin.command_history, desc = "Command History" },
        { "<leader><space>", Utils.telescope("files"), desc = "Find Files (root dir)" },
        -- find
        { "<leader>fb", tele_builtin.buffers, desc = "Buffers" },
        {
          "<leader>ff",
          find_file_or_session,
          desc = "Find Files (root dir)",
        },
        -- { "<leader>fF", Utils.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
        { "<leader>fr", tele_builtin.oldfiles, desc = "Recent" },
        -- git
        { "<leader>gf", tele_builtin.git_files, desc = "commits" },
        { "<leader>gc", tele_builtin.git_commits, desc = "commits" },
        { "<leader>gs", tele_builtin.git_status, desc = "status" },
        -- search
        { "<leader>sa", tele_builtin.autocommands, desc = "Auto Commands" },
        { "<leader>sb", tele_builtin.current_buffer_fuzzy_find, desc = "Buffer" },
        { "<leader>sc", tele_builtin.command_history, desc = "Command History" },
        { "<leader>sC", tele_builtin.commands, desc = "Commands" },
        { "<leader>sd", tele_builtin.diagnostics, desc = "Diagnostics" },
        { "<leader>sg", Utils.telescope("live_grep"), desc = "Grep (root dir)" },
        { "<leader>sG", Utils.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
        { "<leader>sh", tele_builtin.help_tags, desc = "Help Pages" },
        { "<leader>sH", tele_builtin.highlights, desc = "Search Highlight Groups" },
        { "<leader>sk", tele_builtin.keymaps, desc = "Key Maps" },
        { "<leader>sM", tele_builtin.man_pages, desc = "Man Pages" },
        { "<leader>sm", tele_builtin.marks, desc = "Jump to Mark" },
        { "<leader>so", tele_builtin.vim_options, desc = "Options" },
        { "<leader>sw", Utils.telescope("grep_string"), desc = "Word (root dir)" },
        { "<leader>sW", Utils.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
        { "<leader>uC", Utils.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
        {
          "<leader>ss",
          Utils.telescope("lsp_document_symbols", {
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            },
          }),
          desc = "Goto Symbol",
        },
      }
    end,
  },
  session = {
    config = function()
      local keymaps = {
        { "<leader>fs", "<cmd>SessionManager load_session<cr>", desc = "Select and load a session" },
      }
      for _, v in ipairs(keymaps) do
        load_keymap(v)
      end
    end,
  },
    -- stylua: ignore
    ["todo-comments"] = {
        lazy = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
        },
    },
  treesitter = {
    config = {
      incremental_selection = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = "<Tab>",
        node_decremental = "<bs>",
      },
    },
  },
  notify = {
    lazy = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
  },
  noice = {
    lazy = {
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
      },
    },
  },
  alpha = {
    config = {
      { "<CR>", "<cmd>SessionManager load_current_dir_session<CR>", desc = "Load Current Session" },
      { "f", "<leader>ff", desc = "  Find file" },
      { "n", "<cmd>ene <BAR> startinsert <CR>", desc = "  New file" },
      { "s", "<cmd>SessionManager load_session<cr>", desc = "勒 Find Session" },
      { "r", "<cmd>Telescope oldfiles <CR>", desc = "  Recent files" },
      { "g", "<cmd>Telescope live_grep <CR>", desc = "  Find text" },
      -- { "c", "<cmd>e $MYVIMRC <CR>", desc = "  Config" },
      { "l", "<cmd>Lazy<CR>", desc = "鈴 Lazy" },
      { "q", "<cmd>qa<CR>", desc = "  Quit" },
    },
  },
}

for _, km in ipairs(M.general) do
  load_keymap(km)
end

return M
