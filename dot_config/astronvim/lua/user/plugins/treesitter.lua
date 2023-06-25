return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ignore_install = { "latex" }
    opts.incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = "<Tab>",
        node_decremental = "<bs>",
      },
    }
    return opts
  end,
}
