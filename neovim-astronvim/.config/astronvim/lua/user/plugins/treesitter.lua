-- overrides `require("treesitter").setup(...)`
return {
  -- ensure_installed = { "lua" },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>", -- set to `false` to disable one of the mappings
      node_incremental = "<CR>",
      scope_incremental = "<S-CR>",
      node_decremental = "<BS>",
    },
  },
  -- Indentation based on treesitter for the = operator. NOTE: This is an experimental feature.
  indent = {
    enable = true
  },
  rainbow = {
    disable = {
      "latex"
    }
  }
}
