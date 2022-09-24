-- vim: set fdm=marker:

--- Bootstrap freshly-installed neovim
if require"zy.first_load"() then
    return
end

--- Impatient boost
require('impatient')

--- Settings {{
-- Terminal integrations
vim.o.termguicolors = true
vim.o.mouse = 'nvi'

-- UI
vim.o.number = true
vim.o.hlsearch = true
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = 'eol:$,tab:>-,space:⋅'

-- Features & Behaviors
vim.o.modeline = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Tab and spacing
-- https://segmentfault.com/a/1190000021133524
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = -1

-- Folding & concealing
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevelstart = 99
vim.wo.conceallevel = 2

-- Pagniation & scrolling
vim.o.scrolloff = 5

-- Language-specific
vim.g.tex_flavor = 'latex'

-- Providers
vim.g.python3_host_prog = '/usr/bin/python3'
-- vim.g.node_host_prog = '/Users/zeyu/Library/pnpm/node'
-- }}

-- local vrequire = require'utils'.vrequire
require('zy.plugins')
require('zy.keybindings')

-- Plugin-related variables
vim.g.cursorhold_updatetime = 100
