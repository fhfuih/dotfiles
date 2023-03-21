return function()
  local conditions = require("heirline.conditions")
  local utils = require("heirline.utils")

  local LSPBlock = {
    static = {
      lsp_expanded = vim.o.mouse == "",
    },
    on_click = {
      name = "sl_on_click_lsp",
      callback = function(self)
        self.lsp_expanded = not self.lsp_expanded
      end,
    },
    hl = { fg = "green", bold = true },
  }

  local LSPActive = {
    condition = conditions.lsp_attached,
    update = { "LspAttach", "LspDetach" },
    provider = " ",
  }

  local LSPDetail = {
    condition = function(self)
      return self.lsp_expanded
    end,
    update = { "LspAttach", "LspDetach" },
    -- init = expansions.lsp.init,
    -- on_click = expansions.lsp.on_click,
    provider = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        if server.name == "null-ls" then
          local nls_sources = require("null-ls.sources").get_available()
          for _, source in ipairs(nls_sources) do
            table.insert(names, source.name)
          end
        else
          table.insert(names, server.name)
        end
      end
      return "[" .. table.concat(names, " ") .. "]"
    end,
  }

  vim.api.nvim_create_user_command("SLLsp", function()
    LSPBlock.static.lsp_expanded = not LSPBlock.static.lsp_expanded
  end, {})

  return utils.insert(LSPBlock, LSPActive, LSPDetail)
end
