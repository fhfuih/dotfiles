---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.defaults.file_ignore_patterns, { "%.lock", "lazy-lock.json" })
      return opts
    end,
  },
}
