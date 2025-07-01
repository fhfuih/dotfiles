---@type LazySpec
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          local vimtex = vim.api.nvim_buf_get_var(0, "vimtex")
          local status = vimtex.compiler.status
          local latex_icon = require("mini.icons").get("filetype", "tex") .. " "
          if not status then
            return latex_icon .. " "
          elseif status == 1 then
            return latex_icon .. " "
          elseif status == 2 then
            return latex_icon .. " "
          elseif status == 3 then
            return latex_icon .. " "
          end
        end,
        cond = function()
          return vim.fn.exists("b:vimtex") == 1
        end,
      })
    end,
  },
}
