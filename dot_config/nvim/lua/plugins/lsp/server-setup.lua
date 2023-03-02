local Utils = require("configs.utils")

local function setup_package(package_name, require_name)
  return function(_, opts)
    local package_opts = Utils.opts(package_name)
    require(require_name).setup(vim.tbl_deep_extend("force", package_opts, { server = opts }))
    return true
  end
end
-- you can do any additional lsp server setup here
-- return true if you don't want this server to be setup with lspconfig
---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
return {
  -- Specify * to use this function as a fallback for any server
  -- ["*"] = function(server, opts) end,
  tsserver = setup_package("typescript.nvim", "typescript"),
  ltex = setup_package("ltex_extra.nvim", "ltex_extra"),
}
