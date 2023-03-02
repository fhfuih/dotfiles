return {
  {
    "EdenEast/nightfox.nvim",
    event = "VeryLazy",
    -- lazy = false,
    -- priority = 9999,
    config = function()
      -- vim.cmd([[colorscheme carbonfox]])
    end,
  },
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 9999,
    config = function()
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_dim_inactive_windows = 1
      vim.g.sonokai_diagnostic_text_highlight = 1
      vim.g.sonokai_better_performance = 1
      vim.cmd([[colorscheme sonokai]])
    end,
  },
  {
    "mcchrish/zenbones.nvim",
    event = "VeryLazy",
    dependencies = {
      "rktjmp/lush.nvim",
    },
    -- config = function()
    --   vim.g.zenbones_compat = 1
    -- end
  },
  {
    "ramojus/mellifluous.nvim",
    dependencies = {
      "rktjmp/lush.nvim",
    },
  },
  {
    "yazeed1s/minimal.nvim",
  },
  {
    "Yazeed1s/oh-lucy.nvim",
  },
  {
    "Mofiqul/adwaita.nvim",
  },
  {
    "sainnhe/gruvbox-material",
  },
}
