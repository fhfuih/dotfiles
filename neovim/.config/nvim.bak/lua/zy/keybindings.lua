local lsp_status = require('lsp-status')

local U = {}
local n = { noremap=true }
local sn = { noremap=true, silent=true }
local function map(lhs, rhs, mode, options)
  mode = mode or 'n'
  options = options or sn
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--- General
-- Leader
map('<Space>', '<Nop>', '', sn)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Functional
map('S', '"_diwP', 'n', n) -- Stamp last yanked word here
map('S', '"_dP', 'v', n) -- Stamp last yanked word here
map('<C-j>', 'CTRL-D', 'n', n)
map('<C-k>', 'CTRL-U', 'n', n)
map('<C-l>', 'CTRL-F', 'n', n)
map('<C-h>', 'CTRL-B', 'n', n)

-- Chinese Characters
map('：', ':', '', {})
map('；', ';', '', {})

--- Windows
local fn = vim.fn
local is_win = fn.has('win32') or fn.has('win64')
if (is_win) then
  map('<C-z>', '<Nop>', '', sn)
end

--- NvimTree
map('<leader>r', '<cmd>NvimTreeRefresh<CR>', 'n', n)
map('<leader>n', '<cmd>NvimTreeFindFileToggle<CR>', 'n', n)

--- treesitter
-- https://www.reddit.com/r/neovim/comments/r10llx/the_most_amazing_builtin_feature_nobody_ever/
U.ts = {
  incremental_selection = {
    init_selection = "<CR>",
    node_incremental = "<TAB>",
    scope_incremental = "<CR>",
    node_decremental = "<S-TAB>",
  }
}

--- Lsp
map('<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', 'n', sn)
map('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'n', sn)
map(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 'n', sn)
map('<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', 'n', sn)
function U.on_lsp_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', sn)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fm', '<cmd>lua vim.lsp.buf.formatting()<CR>', sn)
  -- lsp_status
  lsp_status.on_attach(client, bufnr)
end

--- Telescope
map('<leader>ff', '<cmd>Telescope find_files<cr>', 'n', n)
map('<leader>of', '<cmd>Telescope oldfiles<cr>', 'n', n)
map('<leader>fp', '<cmd>Telescope projects<cr>', 'n', n)
map('<leader>fw', '<cmd>Telescope live_grep<cr>', 'n', n)
map('<leader>fb', '<cmd>Telescope buffers<cr>', 'n', n)
map('<leader>fh', '<cmd>Telescope help_tags<cr>', 'n', n)

--- LSP Saga
-- map('gh', ':Lspsaga lsp_finder<CR>', 'n', sn)
-- map('<leader>ca', ':Lspsaga code_action<CR>', 'n', sn)
-- map('<leader>ca', ':<C-U>Lspsaga range_code_action<CR>', 'v', sn)
-- map('K', ':Lspsaga hover_doc<CR>', 'n', sn)
-- map('<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', 'n', sn)
-- map('<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', 'n', sn)
-- map('gs', ':Lspsaga signature_help<CR>', 'n', sn)
-- map('gr', ':Lspsaga rename<CR>', 'n', sn)
-- map('gd', ':Lspsaga preview_definition<CR>', 'n', sn)
-- map('<leader>cd', ':Lspsaga show_line_diagnostics<CR>', 'n', sn)
-- map('[e', ':Lspsaga diagnostic_jump_next<CR>', 'n', sn)
-- map(']e', ':Lspsaga diagnostic_jump_prev<CR>', 'n', sn)
-- map('<A-d>', ':Lspsaga open_floaterm<CR>', 'n', sn)
-- map('<A-d>', '<C-\\><C-n>:Lspsaga close_floaterm<CR>', 't', sn)

return U
