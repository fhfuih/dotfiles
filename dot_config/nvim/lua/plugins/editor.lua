local keymaps = require("configs.keymaps")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    -- cmd = "Neotree",
    -- keys = {
    --   {
    --     "<leader>e",
    --     "<cmd>Neotree toggle<CR>",
    --     desc = "Explorer NeoTree (cwd)",
    --   },
    -- },
    -- deactivate = function()
    --   vim.cmd([[Neotree close]])
    -- end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
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
        mappings = {
          ["<space>"] = "none",
        },
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
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            ["<a-i>"] = function()
              Util.telescope("find_files", { no_ignore = true })()
            end,
            ["<a-h>"] = function()
              Util.telescope("find_files", { hidden = true })()
            end,
            ["<C-Down>"] = function(...)
              return require("telescope.actions").cycle_history_next(...)
            end,
            ["<C-Up>"] = function(...)
              return require("telescope.actions").cycle_history_prev(...)
            end,
          },
        },
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
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>sn"] = { name = "+noice" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
      wk.register({
        e = { "<cmd>Neotree toggle<CR>", "Toggle Neotree" },
      }, { prefix = "<leader>" })
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
    "Darazaki/indent-o-matic",
    cmd = {
      "IndentOMatic",
    },
    event = {
      "BufReadPost",
    },
  },
}
