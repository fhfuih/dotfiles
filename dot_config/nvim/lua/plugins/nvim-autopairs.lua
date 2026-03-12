---@type LazySpec
return {
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      npairs.add_rules({
        -- Rule("$$", "$$", { "tex", "latex" }),
        Rule("$", "$", { "tex", "latex" }):with_pair(cond.not_after_text("\\")),
        Rule("`", "'", { "tex", "latex" }):with_pair(cond.not_after_text("\\")),
      })
    end,
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
    config = function(_, opts)
      LazyVim.mini.pairs(opts)

      -- TeX file brakets
      local MiniPairs = require("mini.pairs")
      local map_tex = function()
        MiniPairs.unmap_buf(0, "i", "`", "``")
        MiniPairs.unmap_buf(0, "i", "'", "''")
        MiniPairs.map_buf(0, "i", "$", { action = "closeopen", pair = "$$", neigh_pattern = "[^\\]." })
        MiniPairs.map_buf(0, "i", "`", { action = "open", pair = "`'", neigh_pattern = "[^\\]." })
        MiniPairs.map_buf(0, "i", "'", { action = "close", pair = "`'", neigh_pattern = "[^\\]." })
      end
      vim.api.nvim_create_autocmd("FileType", { pattern = "tex", callback = map_tex })
    end,
  },
}
