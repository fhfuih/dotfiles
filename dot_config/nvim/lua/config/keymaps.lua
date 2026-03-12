-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.del("n", "<leader>l") -- lazy

-- Incremental & Decremental selection in 0.12
if vim.fn.has("nvim-0.12") == 1 then
  vim.keymap.set("n", "+", ":normal van<CR>", { desc = "Increment selection" })
  vim.keymap.set("v", "+", function()
    vim.api.nvim_feedkeys("an", "v", false)
  end, { desc = "Increment selection" })
  vim.keymap.set("n", "-", ":normal vin<CR>", { desc = "Decrement selection" })
  vim.keymap.set("v", "-", function()
    vim.api.nvim_feedkeys("in", "v", false)
  end, { desc = "Decrement selection" })
end
