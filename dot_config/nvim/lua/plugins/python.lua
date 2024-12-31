return {
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
    },
    opts = {
      settings = {
        cache = {
          file = "~/.local/share/nvim/venv-selector/venvs2.json",
        },
        options = {
          notify_user_on_venv_activation = true,
        },
        search = {
          pipx = false,
        },
      },
    },
    config = true,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "venv select" },
    },
    cmd = {
      "VenvSelect",
    },
    -- init = function(_)
    --   local augroup = vim.api.nvim_create_augroup("python_venv", { clear = true })
    --   local auto_load_venv = function()
    --     local poetry_command = io.popen('poetry env info --executable')
    --     local poetry_path = nil
    --     if poetry_command ~= nil then
    --       poetry_path = poetry_command:read("*a")
    --       poetry_command:close()
    --     end
    --   end
    --   vim.api.nvim_create_autocmd("LspAttach", {
    --     group = augroup,
    --     desc = "Auto activate venv",
    --     callback = function(args)
    --       if assert(vim.lsp.get_client_by_id(args.data.client_id)) ~= "basedpyright" then return end
    --       require "clangd_extensions"
    --       vim.api.nvim_del_augroup_by_id(augroup) -- delete auto command since it only needs to happen once
    --     end,
    --   })
    -- end,
  },
}
