return {
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      -- https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins/configs/luasnip.lua
      if opts then require("luasnip").config.setup(opts) end
      vim.tbl_map(
        function(type) require("luasnip.loaders.from_" .. type).lazy_load { "latex" } end,
        { "vscode", "snipmate", "lua" }
      )
    end,
  },
}
