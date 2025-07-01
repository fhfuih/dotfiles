return {
  {
    "todo-comments.nvim",
    opts = function(_, opts)
      if not opts.keywords then
        opts.keywords = { TODO = {} }
      elseif not opts.keywords.TODO then
        opts.keywords.TODO = {}
      end
      opts.keywords.TODO.alt = { "\\todo" }
    end,
  },
}
