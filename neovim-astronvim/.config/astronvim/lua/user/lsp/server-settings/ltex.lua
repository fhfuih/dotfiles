local ltexSettings = {
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
}

local languages = {
  "en-US",
  "zh-CN",
}

local extensibleSettings = {
  "dictionary",
  -- "hiddenFalsePositives",
  -- "disabledRules",
  -- "enabledRules",
}

local extension = {}
for _, key in ipairs(extensibleSettings) do
  extension[key] = {}
  for _, lang in ipairs(languages) do
    local filepath = vim.fn.expand("~/.config/ltex/ltex." .. key .. "." .. lang .. ".txt")
    if not vim.fn.filereadable(filepath) then
      vim.notify("LTeX external file does not exist: " .. filepath, "info")
    end
    extension[key][lang] = {
      ":" .. filepath,
    }
  end
end

-- ltexSettings = vim.tbl_deep_extend("force", extension, ltexSettings)

local path = vim.fn.system("which ltex-ls")
path = vim.trim(path):gsub("/bin/ltex-ls", "")

-- return {
--   filetypes = { "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" }, -- no bib
--   ltex = vim.tbl_deep_extend("force", extension, {
--     additionalRules = {
--       motherTongue = "zh-CN",
--     },
--     -- latex = {
--     --   commands = {
--     --     ["\\todo{}"] = "ignore",
--     --     ["\\todo[]{}"] = "ignore",
--     --     ["\\mxj{}"] = "ignore",
--     --     ["\\xm{}"] = "ignore",
--     --   },
--     -- },
--     -- checkFrequency = "save",
--     -- languageToolHttpServerUri = "https://api.languagetool.org/",
--     -- configurationTarget = 'userExternalFile',
--     -- java = {
--     --   path = vim.trim(vim.fn.system("/usr/libexec/java_home"))
--     -- },
--     -- ["ltex-ls"] = {
--     --   path = path
--     -- }
--   }),
-- }

return {
  filetypes = { "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" }, -- no bib
  settings = {
    ltex = ltexSettings,
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
