return {
  ["kylechui/nvim-surround"] = {
    tag = "*",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  ["rafcamlet/nvim-luapad"] = {
    cmd = { "Luapad", "LuaRun" },
  },
  ["barreiroleo/ltex_extra.nvim"] = {},
  ["f3fora/nvim-texlabconfig"] = {
    config = function()
      require("texlabconfig").setup()
    end,
    -- ft = { 'tex', 'bib' },
    run = "go build -o ~/.local/bin/",
  },
  ["ThePrimeagen/refactoring.nvim"] = {
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  ["folke/zen-mode.nvim"] = {
    cmd = { "ZenMode" },
    config = function()
      require("zen-mode").setup()
    end,
  },
  ["ggandor/leap.nvim"] = {
    config = function()
      require("leap").add_default_mappings()
    end,
  },
}
