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
      -- chktex = {
      --   onOpenAndSave = true
      -- }
    },
  },
}
