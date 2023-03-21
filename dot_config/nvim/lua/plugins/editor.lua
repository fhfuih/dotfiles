local keymaps = require("configs.keymaps")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    cmd = "Neotree",
    keys = keymaps["neo-tree"].lazy,
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        ---@diagnostic disable-next-line: param-type-mismatch
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      close_if_last_window = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
      },
      window = {
        mappings = keymaps["neo-tree"].config.default,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    branch = "0.1.x",
    keys = keymaps.telescope.lazy,
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = keymaps.telescope.config,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("notify")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(keymaps["which-key"].config())
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        -- keymaps.gitsigns.config(buffer)
      end,
    },
  },
  -- {
  --   "rmagatti/auto-session",
  --   lazy = false, -- Doc says lazy may cause error. LazyVim uses BufReadPre for persistence.
  --   opts = {
  --     auto_session_root_dir = vim.fn.stdpath('data').."/auto-session/",
  --     auto_session_suppress_dirs = { "~/", "~/Downloads", "/"},
  --   },
  -- },
  {
    "Shatur/neovim-session-manager",
    lazy = false,
    opts = function()
      return {
        sessions_dir = vim.fn.stdpath("data") .. "/session-manager/",
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
        autosave_ignore_dirs = {
          "~",
        },
      }
    end,
    config = function(_, opts)
      require("session_manager").setup(opts)
      keymaps.session.config()
    end,
    dependencies = {
      "plenary.nvim",
    },
  },
  {
    "olimorris/persisted.nvim",
    enabled = false,
    lazy = false,
    opts = {
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/persisted/"),
    },
  },
  -- {
  --   "max397574/better-escape.nvim",
  --   config = true,
  --   event = "InsertEnter",
  -- },
  {
    "folke/todo-comments.nvim",
    cmd = {
      "TodoQuickFix",
      "TodoLocList",
      "TodoTrouble",
      "TodoTelescope",
    },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = keymaps["todo-comments"].lazy,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    -- keys = {
    --   [[<c-\>]],
    -- },
    -- cmd = {
    --   "ToggleTerm",
    --   "ToggleTermToggleAll",
    --   "TermExec",
    --   "ToggleTermSendCurrentLine",
    --   "ToggleTermSendVisualLines",
    --   "ToggleTermSendVisualSelection",
    --   "ToggleTermSetName",
    -- },
    event = "VeryLazy",
  },
  {
    "Darazaki/indent-o-matic",
    cmd = {
      "IndentOMatic",
    },
    event = {
      "BufReadPost",
    },
  },
}
