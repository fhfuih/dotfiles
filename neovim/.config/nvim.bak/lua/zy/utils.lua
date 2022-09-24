local g, o, bo = vim.g, vim.o, vim.bo
local cmd = vim.cmd
local config_path = vim.fn.stdpath('config')
local U = {}

function U.vrequire(path)
	cmd('source ' .. config_path .. '/vimscript/' ..path.. '.vim')
end

return U
