return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overriden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      require("plugins.lsp.format").autoformat = opts.autoformat
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("plugins.lsp.format").on_attach(client, buffer)
          require("plugins.lsp.keymaps").on_attach(client, buffer)
        end,
      })

      -- diagnostics
      -- for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
      --   name = "DiagnosticSign" .. name
      --   vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      -- end
      vim.diagnostic.config(opts.diagnostics)

      -- Let mason set up all mason-installed servers
      local setup_handlers = require("plugins.lsp.server-setup")
      require("mason-lspconfig").setup_handlers(setup_handlers)

      -- Manually set up all the other servers
      local servers = require("plugins.lsp.servers")
      for server_name, server_opts in pairs(servers) do
        if server_opts.mason == false then
          (setup_handlers[server_name] or setup_handlers[1])(server_name)
        end
      end
    end,
  },
  {
    "barreiroleo/ltex_extra.nvim",
    dev = true,
    opts = {
      load_langs = { "zh-CN", "en-US" },
      init_check = true,
      path = "~/.config/ltex",
    },
  },
  "jose-elias-alvarez/typescript.nvim",
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.stylua.with({
            condition = function(utils)
              return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
            end,
          }),
          nls.builtins.code_actions.refactoring,
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-treesitter/nvim-treesitter",
        },
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      automatic_installation = true,
      automatic_setup = false,
    },
    config = function(_, opts)
      require("mason-null-ls").setup(opts)
    end,
    cmd = {
      "NullInstall",
      "NullUninstall",
    },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cmd = {
      "LspInstall",
      "LspUninstall",
    },
    config = true,
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = true,
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
}
