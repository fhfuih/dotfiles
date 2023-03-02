return {
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    "rafcamlet/nvim-luapad",
    cmd = {
      "Luapad",
      "LuaRun",
    },
    opts = {
      count_limit = 150000,
      eval_on_change = false,
      eval_on_move = true,
      on_init = function()
        print("Press F5 to run the luapad")
      end,
    },
  },
}
