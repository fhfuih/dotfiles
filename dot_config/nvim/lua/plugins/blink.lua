return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- Configure nvim-cmp-like behavior
      -- See: https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua
      opts.keymap = {
        preset = "none",
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_next()
            elseif cmp.snippet_active() then
              return cmp.snippet_forward()
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_prev()
            elseif cmp.snippet_active() then
              return cmp.snippet_backward()
            end
          end,
          "fallback",
        },
        ["<CR>"] = { "accept", "fallback" },
      }

      -- List cycling and selection behaviors
      opts.completion.list = {
        -- Don't auto select the first item in the list
        selection = { preselect = false },
        -- When `select_prev` at the first completion suggestion, do not cycle to the bottom
        cycle = { from_top = false },
      }

      -- Completion sources
      opts.sources.per_filetype = {
        tex = { inherit_defaults = true, "omni" }, -- VimTeX completion are there, and I don't use LSP
      }

      -- Menu UI
      -- Defaults at: https://main.cmp.saghen.dev/configuration/reference#completion-menu-draw
      opts.completion.menu.draw.columns = {
        -- stylua: ignore
        { 'kind_icon' },
        -- stylua: ignore
        { 'label', 'label_description', gap = 1 },
        -- stylua: ignore
        { 'source_id' },
      }
      if opts.completion.menu.draw.components == nil then
        opts.completion.menu.draw.components = {}
      end
      -- Menu UI: use mini.icon icons and highlight groups
      opts.completion.menu.draw.components.kind_icon = {
        text = function(ctx)
          local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
          return kind_icon
        end,
        highlight = function(ctx)
          local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
          return hl
        end,
      }
      opts.completion.menu.draw.components.kind = {
        -- (optional) use highlights from mini.icons
        highlight = function(ctx)
          local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
          return hl
        end,
      }
    end,
  },
}
