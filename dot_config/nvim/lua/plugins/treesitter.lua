---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  -- opts = function(_, opts) {
  --   ensure_installed = {
  --     "lua",
  --     "vim",
  --     -- add more arguments for adding more treesitter parsers
  --   },
  -- } end,
  opts = function(_, opts)
    -- ensure vim and lua TS are installed: two config languages
    if not opts.ensure_installed then opts.ensure_installed = {} end
    vim.list_extend(opts.ensure_installed, {
      "lua",
      "vim",
    })

    -- disable TS latex highlight in favor of VimTex. See :help vimtex-faq-treesitter
    if not opts.highlight then opts.highlight = { enable = true, disable = {} } end
    if not opts.highlight.disable then opts.highlight.disable = {} end
    vim.list_extend(opts.highlight.disable, { "latex" })

    -- disable TS latex textobject in favor of VimTex.
    if opts.textobjects then
      for _, obj in pairs(opts.textobjects) do
        obj.disable = { "latex" }
      end
    end
  end,
}
