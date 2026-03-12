return {
  {
    "keaising/im-select.nvim",
    opts = function(_, _)
      local results = {
        keep_quiet_on_no_binary = true,
      }
      if vim.fn.has("mac") then
        results.default_im_select = "com.apple.keylayout.US"
      end
      return results
    end,
  },
}
