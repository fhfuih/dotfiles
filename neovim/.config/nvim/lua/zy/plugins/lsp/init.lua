local on_lsp_attach = require'zy.keybindings'.on_lsp_attach

local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')

-- Update capabilities hook by cmp, luasnip, and lsp-status
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
if not capabilities.textDocument.completion.completionItem.snippetSupport then
  capabilities.textDocument.completion.completionItem.snippetSupport = true
end
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

-- require("lua-dev").setup{
--   lspconfig = {
--     settings = {
--       Lua = {
--         runtime = {
--           version = 'LuaJIT',
--           path = lua_runtime_path,
--         },
--         diagnostics = {
--           globals = {'vim'},
--         },
--         workspace = {
--           library = vim.api.nvim_get_runtime_file("", true),
--         },
--         telemetry = {
--           enable = false,
--         },
--       },
--     },
--   }
-- }

local function setup_lsp(lang_list)
  for _, lang in ipairs(lang_list) do
    local lang_name, config
    if type(lang) == "table" then
      lang_name = lang[1]
      config = lang
      table.remove(config, 1)
    elseif type(lang) == "string" then
      lang_name = lang
      config = {}
    end
    config.on_attach = on_lsp_attach
    config.capabilities = capabilities
    config.flags = {
      debounce_text_changes = 150,
    }
    nvim_lsp[lang_name].setup(config)
  end
end

setup_lsp{
  'html',
  'cssls',
  'jsonls',
  'eslint',
  'tsserver',
  'pyright',
  'gopls',
  'texlab',
  'ltex',
  {
    'yamlls',
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
        },
      },
    },
  },
}

-- setup lua seperately
local lua_runtime_path = vim.split(package.path, ';')
local config_path = vim.fn.stdpath('config')
local packer_path = require'packer'.config.package_root.."/packer/start/?"
table.insert(lua_runtime_path, config_path.."/lua/?.lua")
table.insert(lua_runtime_path, config_path.."/lua/?/init.lua")
table.insert(lua_runtime_path, packer_path.."/lua/?.lua")
table.insert(lua_runtime_path, packer_path.."/lua/?/init.lua")
nvim_lsp.sumneko_lua.setup(require("lua-dev").setup{
  lspconfig = {
    on_attach = on_lsp_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      Lua = {
        -- -- This is set by lua-dev and not overridable (according to current src code)
        -- runtime = {
        --   version = 'LuaJIT',
        --   path = lua_runtime_path,
        -- },
        diagnostics = {
          globals = {'vim'},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
})

-- setup null-ls
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
    },
})
