return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      if type(opts.picker.sources) ~= "table" then
        opts.picker.sources = {}
      end
      opts.picker.sources = vim.tbl_deep_extend("force", opts.picker.sources, {
        explorer = {
          ignored = true,
          hidden = true,
          auto_close = true,
        },
        projects = {
          dev = { "~/workspace" },
          -- projects = {
          --   "~/.config/nvim/",
          -- },
          patterns = {
            ".git",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            "package.json",
            "Makefile",
            ".neoconf.json",
            "pyproject.toml",
          },
        },
      })
      return opts
    end,
  },
}
