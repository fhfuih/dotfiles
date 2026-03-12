return {
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      opts.mappings = {
        around_next = "aN",
        inside_next = "iN",
        around_last = "aL",
        inside_last = "iL",
      }
    end,
  },
}
