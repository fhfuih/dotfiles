return {
  settings = {
    texlab = {
      build = {
        onSave = true,
        forwardSearchAfter = true,
      },
      forwardSearch = {
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "%l", "%p", "%f" },
      },
      -- Configure chktex in null-ls instead
      -- chktex = {
      --   onOpenAndSave = true
      -- }
    },
  },
}
