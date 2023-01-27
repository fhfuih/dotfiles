local null_ls = require("null-ls")

return {
  sources = {
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.diagnostics.chktex,
    null_ls.builtins.formatting.stylua,
  },
}
