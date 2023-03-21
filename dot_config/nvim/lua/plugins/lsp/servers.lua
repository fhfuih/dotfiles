-- mason = boolean: whether executable should be managed by mason or by me
local util = require("lspconfig.util")
return {
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
  pylsp = {},
  tsserver = {
    root_dir = function(fname)
      return util.root_pattern("tsconfig.json")(fname)
        or util.root_pattern("package.json", "jsconfig.json", ".git")(fname)
        or util.root_pattern("app.json")(fname)
    end,
  }, -- tsserver is configured by tsconfig.json or jsconfig.json
  texlab = {
    settings = {
      texlab = {
        -- Disable build because I use VimTeX to auto-compile
        build = {
          onSave = false,
          forwardSearchAfter = true,
        },
        forwardSearch = {
          executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
          args = { "%l", "%p", "%f" },
        },
        -- Configure chktex in null-ls instead
        -- Because I can configure the format
        -- chktex = {
        --   onOpenAndSave = true
        -- }
      },
    },
  },
  ltex = {
    mason = false,
    extensions = { "tex" }, -- no use for now
    -- no bib
    filetypes = { "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
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
            ["\\etal"] = "pluralDummy",
            ["\\eg"] = "dummy",
            ["\\ie"] = "dummy",
            ["\\aka"] = "dummy",
            ["\\etc"] = "dummy",
          },
        },
        checkFrequency = "save",
        -- These settings are only available in VSCode
        -- I should use ltex-extra instead
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
  },
}
