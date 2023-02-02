local path = vim.fn.system("which ltex-ls")
path = vim.trim(path):gsub("/bin/ltex-ls", "")

return {
  filetypes = { "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" }, -- no bib
  settings = {
    ltex = {
      additionalRules = {
        motherTongue = "zh-CN",
      },
      latex = {
        commands = {
          ["\\todo{}"] = "ignore",
          ["\\todo[]{}"] = "ignore",
          ["\\Todo{}"] = "ignore",
          ["\\Todo[]{}"] = "ignore",
          ["\\mxj{}"] = "ignore",
          ["\\xm{}"] = "ignore",
        },
      },
      checkFrequency = "save",
      -- dictionary = {
      --   ["en-US"] = {
      --     ":~/.config/ltex/ltex.dictionary.en-US.txt",
      --   },
      -- },
      -- languageToolHttpServerUri = "https://api.languagetool.org/",
      -- configurationTarget = 'userExternalFile',
      -- java = {
      --   path = vim.trim(vim.fn.system("/usr/libexec/java_home"))
      -- },
      -- ["ltex-ls"] = {
      --   path = path
      -- }
    },
  },
  on_attach = function(client, bufnr)
    astronvim.lsp.on_attach(client, bufnr)
    require("ltex_extra").setup({
      load_langs = { "zh-CN", "en-US" },
      init_check = true,
      path = vim.fs.normalize("~/.config/ltex"),
    })
  end,
}
