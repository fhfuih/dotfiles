local keymaps = require("configs.keymaps")
local Utils = require("configs.utils")

return {
  {
    "rebelot/heirline.nvim",
    opts = require("plugins.ui.statusline"),
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/lsp-status.nvim",
    },
  },
  -- vim.ui.select and vim.ui.text
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  -- messages, cmdline, and popupmenu
  {
    "folke/noice.nvim",
    -- enabled = false,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    -- stylua: ignore
    keys = keymaps.noice.lazy,
  },
  -- vim.notify
  {
    "rcarriga/nvim-notify",
    keys = keymaps.notify.lazy,
    opts = {
      -- level = vim.log.levels.WARN,
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    -- config = function(_, opts)
    --   require("notify").setup(opts)
    --   require("telescope").load_extension("notify")
    -- end,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = require("plugins.ui.header")
      dashboard.section.footer.val = "Current dir: " .. vim.loop.cwd()

      dashboard.section.buttons.val = vim.tbl_map(function(km)
        return dashboard.button(km[1], km.desc, km[2])
      end, keymaps.alpha.config)

      -- Prevent find_file at ~ or above
      if not Utils.allow_find_files() then
        table.remove(dashboard.section.buttons.val, 1)
      end

      -- for _, button in ipairs(dashboard.section.buttons.val) do
      --   button.opts.hl = "AlphaButtons"
      --   button.opts.hl_shortcut = "AlphaShortcut"
      -- end
      -- dashboard.section.footer.opts.hl = "Type"
      -- dashboard.section.header.opts.hl = "AlphaHeader"
      -- dashboard.section.buttons.opts.hl = "AlphaButtons"

      dashboard.config.layout = {
        { type = "padding", val = 6 },
        dashboard.section.header,
        { type = "padding", val = 4 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        dashboard.section.footer,
      }
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = dashboard.section.footer.val
            .. "\n⚡ Neovim loaded "
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
