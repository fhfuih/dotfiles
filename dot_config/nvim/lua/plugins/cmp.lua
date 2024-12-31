---@type LazySpec
return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(plugin, opts)
      -- Formatting: Show cmp source
      local orig_format = opts.formatting.format
      local function format(entry, item)
        item.menu = entry.source.name
        return orig_format(entry, item)
      end
      opts.formatting.format = format
      return opts
    end,
    config = function(_, opts)
      require "astronvim.plugins.configs.cmp"(_, opts)
      require("cmp").setup.filetype("tex", {
        sources = vim.list_extend({
          { name = "vimtex", group_index = 1 },
        }, opts.sources),
      })
    end,
    dependencies = {
      { "micangl/cmp-vimtex", lazy = true },
    },
  },
}
