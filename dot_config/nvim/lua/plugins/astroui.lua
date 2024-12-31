---@type LazySpec
return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- change colorscheme
      colorscheme = "everforest",
      -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
      highlights = {
        init = { -- this table overrides highlights in all themes
          -- Normal = { bg = "#000000" },
        },
        astrodark = { -- a table of overrides/changes when applying the astrotheme theme
          -- Normal = { bg = "#000000" },
        },
      },
      -- Icons can be configured throughout the interface
      icons = {
        -- configure the loading of the lsp in the status line
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
        VimIcon = "",
        -- -- revert nvchad git icons
      },
      status = {
        -- grab from the nvchad-style config
        -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/recipes/heirline-nvchad-statusline/init.lua
        separators = {
          left = { "", "" }, -- separator for the left side of the statusline
          right = { "", "" }, -- separator for the right side of the statusline
          tab = { "", "" },
        },
        colors = function(hl)
          local get_hlgroup = require("astroui").get_hlgroup
          -- use helper function to get highlight group properties
          local comment_fg = get_hlgroup("Comment").fg
          hl.git_branch_fg = comment_fg
          hl.git_added = comment_fg
          hl.git_changed = comment_fg
          hl.git_removed = comment_fg
          hl.blank_bg = get_hlgroup("Folded").fg
          hl.file_info_bg = get_hlgroup("Visual").bg
          hl.nav_icon_bg = get_hlgroup("String").fg
          hl.nav_fg = hl.nav_icon_bg
          hl.folder_icon_bg = get_hlgroup("Error").fg
          return hl
        end,
        attributes = {
          mode = { bold = true },
        },
      },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      -- statusline is modified by community's nvchad config
      --https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/recipes/heirline-nvchad-statusline/init.lua
      local status = require "astroui.status"
      local status_utils = require "astroui.status.utils"
      local hl = require "astroui.status.hl"
      local extend_tbl = require("astrocore").extend_tbl
      local is_available = require("astrocore").is_available

      status.provider.scrollbar = function(o)
        -- local sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
        local sbar = { "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " }
        local rep = 1
        return function()
          local curr_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_line_count(0)
          local i = math.floor((curr_line - 1) / lines * #sbar) + 1
          if sbar[i] then return status_utils.stylize(sbar[i]:rep(rep), o) end
        end
      end

      status.provider.lsp_client_names = function(o)
        o = extend_tbl({
          integrations = {
            null_ls = is_available "none-ls.nvim",
            conform = is_available "conform.nvim",
            ["nvim-lint"] = is_available "nvim-lint",
          },
        }, o)
        return function(self)
          local bufnr = self and self.bufnr or 0
          local buf_client_count = 0

          --- normal LSP and null-ls
          ---@diagnostic disable-next-line: deprecated
          for _, client in pairs((vim.lsp.get_clients or vim.lsp.get_active_clients) { bufnr = bufnr }) do
            if client.name == "null-ls" and o.integrations.null_ls then
              local ft = vim.bo[bufnr].filetype
              local params = {
                client_id = client.id,
                bufname = vim.api.nvim_buf_get_name(bufnr),
                bufnr = bufnr,
                filetype = ft,
                ft = ft,
              }
              for _, type in ipairs { "FORMATTING", "DIAGNOSTICS" } do
                params.method = type
                local sources = status_utils.null_ls_sources(params)
                buf_client_count = buf_client_count + #sources
              end
            else
              buf_client_count = buf_client_count + 1
            end
          end

          -- conform integration
          if o.integrations.conform and package.loaded["conform"] then
            local sources = require("conform").list_formatters_to_run(bufnr)
            buf_client_count = buf_client_count + #sources
          end

          -- nvim-lint integration
          if o.integrations["nvim-lint"] and package.loaded["lint"] then
            local sources = require("lint")._resolve_linter_by_ft(vim.bo[bufnr].filetype)
            buf_client_count = buf_client_count + #sources
          end

          local str = "(" .. buf_client_count .. ")"
          return status_utils.stylize(str, o)
        end
      end

      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        -- mode
        status.component.mode {
          mode_text = {
            icon = { kind = "VimIcon", padding = { right = 1, left = 1 } },
          },
          surround = {
            separator = "left",
            color = function() return { main = status.hl.mode_bg(), right = "blank_bg" } end,
          },
        },
        status.component.builder {
          { provider = "" },
          -- define the surrounding separator and colors to be used inside of the component
          -- and the color to the right of the separated out section
          surround = {
            separator = "left",
            color = { main = "blank_bg", right = "file_info_bg" },
          },
        },
        --
        status.component.file_info {
          -- enable the file_icon and disable the highlighting based on filetype
          filename = { fallback = "Empty" },
          -- disable some of the info
          filetype = false,
          file_read_only = false,
          -- add padding
          padding = { right = 1 },
          -- define the section separator
          surround = { separator = "left", condition = false },
        },
        status.component.git_branch {
          git_branch = { padding = { left = 1 } },
          surround = { separator = "none" },
        },
        status.component.diagnostics { surround = { separator = "right" }, padding = { right = 1 } },
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.treesitter {
          str = { str = "", icon = { kind = "NONE", padding = { left = 0, right = 0 } } },
          padding = { right = 1 },
          hl = hl.get_attributes "lsp", -- use same color as lsp
        },
        status.component.lsp {
          padding = { right = 1 },
          surround = { separator = "right" },
        },
        status.component.virtual_env(),
        status.component.nav {
          percentage = false,
          ruler = { padding = { left = 1, right = 1 } },
          scrollbar = {
            padding = { left = 0, right = 0 },
            hl = { fg = "bg", bg = "scrollbar" },
          },
          surround = { separator = "none" },
        },
      }

      -- opts.statusline[#opts.statusline] = {
      --   -- icon
      --   status.component.builder {
      --     { provider = require("astroui").get_icon "ScrollText" },
      --     -- add padding after icon
      --     padding = { right = 1 },
      --     -- set the icon foreground
      --     hl = { fg = "bg" },
      --     -- use the right separator and define the background color
      --     -- as well as the color to the left of the separator
      --     surround = {
      --       separator = "right",
      --       color = { main = "nav_icon_bg", left = "file_info_bg" },
      --     },
      --   },
      --   -- nav
      --   status.component.nav {
      --     percentage = false,
      --     ruler = { padding = { right = 1 } },
      --     scrollbar = {
      --       -- padding = { right = 1 },
      --       hl = { fg = "bg", bg = "scrollbar" },
      --     },
      --     surround = { separator = "none", color = "file_info_bg" },
      --   },
      -- }
      return opts
    end,
  },
}
