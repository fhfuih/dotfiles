return {
  -- General text-editing
  ["kylechui/nvim-surround"] = {
    tag = "*",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  ["ggandor/leap.nvim"] = {
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  ["folke/zen-mode.nvim"] = {
    cmd = { "ZenMode" },
    config = function()
      require("zen-mode").setup()
    end,
  },
  -- completion
  ["hrsh7th/cmp-omni"] = {
    config = function()
      astronvim.add_cmp_source("omni")
    end,
  },
  -- Lsp
  ["ThePrimeagen/refactoring.nvim"] = {
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  ["barreiroleo/ltex_extra.nvim"] = {},
  ["f3fora/nvim-texlabconfig"] = {
    disable = true,
    config = function()
      require("texlabconfig").setup()
    end,
    ft = { "tex", "bib" },
    run = "go build -o ~/.local/bin/",
  },
  -- Non-lsp language support
  ["lervag/vimtex"] = {
    disable = true,
  },
  -- Debug
  ["rafcamlet/nvim-luapad"] = {
    cmd = { "Luapad", "LuaRun" },
  },
}
