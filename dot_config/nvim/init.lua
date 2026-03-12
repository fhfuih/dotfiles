-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- vim.treesitter.query.add_directive("inject-jinja!", function(_, _, bufnr, _, metadata)
--   local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
--   local ext = string.match(fname, "%.([^.]+)%.[^.]+$")
--   metadata["injection.language"] = ext
--   -- vim.notify("real ext " .. ext, vim.log.levels.INFO, {})
-- end, {})
