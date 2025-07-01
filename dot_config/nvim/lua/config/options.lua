-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim
vim.o.wrap = true

-- LazyVim language config
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.tex_flavor = "latex"

-- neovide UI
vim.g.neovide_scale_factor = 1.0
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_cursor_animation_length = 0
