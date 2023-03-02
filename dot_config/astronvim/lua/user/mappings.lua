return function(default)
  function find_file_or_sessrion(default_func)
    return function()
      local restriction = vim.fn.expand('~') .. '/' -- itself is not matched
      local pwd = vim.fn.getcwd()
      if pwd:find(restriction) then
        return default_func()
      else
        vim.notify("Don't search files at " .. pwd .. ". Only inside " .. restriction, "warn")
        return vim.cmd("SessionManager load_session")
      end
    end
  end

  return vim.tbl_deep_extend('force', default, {
    n = {
      j = 'gj',
      k = 'gk',
      ["<leader>fs"] = { "<cmd>SessionManager load_session<cr>", desc = "Search sessions" },
      ["<leader>ff"] = { find_file_or_sessrion(default.n["<leader>ff"][1]), desc = "Seach files or sessions" },
      ["<leader>fF"] = { find_file_or_sessrion(default.n["<leader>fF"][1]), desc = "Seach all files or sessions" },
    },
  })
end
