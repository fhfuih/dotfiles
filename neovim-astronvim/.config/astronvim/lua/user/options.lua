local listchars = {
  tab = "|->",
  nbsp = "~",
  trail = "",
  extends = "@",
  precedes = "@",
}

if os.date("%m%d") == "0401" then
  listchars.space = ""
end

return {
  opt = {
    wrap = true,
    list = true,
    listchars = listchars,
    -- below are examples
    -- relativenumber = true, -- sets vim.opt.relativenumber
    -- number = true, -- sets vim.opt.number
    -- spell = false, -- sets vim.opt.spell
    -- signcolumn = "auto", -- sets vim.opt.signcolumn to auto
  },
  -- opt_local = {
  --   foldmethod = 'expr',
  --   foldexpr = 'nvim_treesitter#foldexpr()',
  --   foldenable = false,
  -- },
  g = {
    mapleader = " ",
    tex_flavor = "latex",

    -- below are examples
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_enabled = true, -- enable diagnostics at start
    status_diagnostics_enabled = true, -- enable diagnostics in statusline
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    heirline_bufferline = true, -- enable new heirline based bufferline (requires :PackerSync after changing)
  },
}
