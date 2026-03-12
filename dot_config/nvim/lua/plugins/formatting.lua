---@param bufnr integer
---@param ... string
---@return string
local function first_available_formatter(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, {
        tex = { "tex-fmt" },
        json = { "oxfmt" },
        astro = { "prettierd", "prettier", stop_after_first = true },
        javascript = function(bufnr)
          local detected = first_available_formatter(bufnr, "prettierd", "prettier", "oxfmt")
          return { detected }
        end,
      })

      -- opts.formatters = opts.formatters or {}
      -- opts.formatters.oxlint = {
      --   command = "oxlint",
      --   args = { "--fix", "$FILENAME" },
      -- }
    end,
  },
}
