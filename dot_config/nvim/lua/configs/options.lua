local opt = vim.opt
local g = vim.g

--- Settings {{
-- System
opt.termguicolors = true
opt.mouse = "nvi"
opt.clipboard:append("unnamedplus")

-- UI
opt.number = true
opt.hlsearch = true
opt.cursorline = true
opt.list = true
opt.listchars = {
  tab = "|->",
  trail = "·",
  nbsp = "~",
}

-- Editor
opt.modeline = true
opt.ignorecase = true
opt.smartcase = true
opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "winpos",
  "terminal",
  -- 'localoptions',
}

-- Tab and spacing
-- https://segmentfault.com/a/1190000021133524
opt.expandtab = true -- convert tab to spaces
opt.shiftwidth = 2 -- Affects cindent, >>, <<, etc
opt.softtabstop = -1 -- negative value uses shiftwidth. Affects entering TAB and BS

-- Folding & concealing
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldenable = false
vim.wo.conceallevel = 2

-- Pagniation & scrolling
opt.scrolloff = 5

-- Language-specific
g.tex_flavor = "latex"

-- Providers
g.python3_host_prog = "/usr/bin/python3"
-- g.node_host_prog = '/Users/zeyu/Library/pnpm/node'
-- }}
