local Utils = require("configs.utils")
local servers = require("plugins.lsp.servers")

local capabilities = nil

local function get_capabilities()
  if capabilities == nil then
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
  end
  return capabilities
end

local function get_server_opts(server_name)
  local o = servers[server_name] or {}
  o.capabilities = get_capabilities()
  return o
end

local function delegated_setup(package_name, require_name, server_name)
  return function(_)
    local package_opts = Utils.opts(package_name)
    local server_opts = get_server_opts(server_name)
    require(require_name).setup(vim.tbl_deep_extend("force", package_opts, { server = server_opts }))
  end
end

return {
  function(server_name)
    local server_opts = get_server_opts(server_name)
    require("lspconfig")[server_name].setup(server_opts)
  end,
  tsserver = delegated_setup("typescript.nvim", "typescript", "tsserver"),
  ltex = delegated_setup("ltex_extra.nvim", "ltex_extra", "ltex"),
}
