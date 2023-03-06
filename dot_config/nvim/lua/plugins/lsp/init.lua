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

      -- Get all the server configs from servers.lua
      -- If the tool is not managed by mason, set the server up directly
      -- Otherwise, ask mason to set up the tools, then set the server up
      -- The server setup is to assign capabilities, call fallbacks, and call lspconfig if necessary.
      local servers = require("plugins.lsp.servers")
      local server_setup = require("plugins.lsp.server-setup")
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = servers[server] or {}
        server_opts.capabilities = capabilities
        if server_setup[server] then
          if server_setup[server](server, server_opts) then
            return
          end
        elseif server_setup["*"] then
          if server_setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      local function noop() end

      local mlsp = require("mason-lspconfig")
      local available = mlsp.get_available_servers()

      local ensure_installed = {} ---@type string[]
      local setup_handlers = { setup }
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        else
          setup_handlers[server] = noop
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers(setup_handlers)
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
          nls.builtins.formatting.stylua, --.with({
          --   condition = function(utils)
          --     return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          --   end,
          -- }),
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
