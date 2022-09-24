---- Borrowed from tjdevries's dotfile configs. Thanks tjdevries!
--- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/first_load.lua

local fn = vim.fn
local download_packer = function()
    if fn.input "Download Packer? (y for yes)" ~= "y" then
      return
    end

    local directory = fn.stdpath("data").."/site/pack/packer/start/"

    fn.mkdir(directory, "p")

    local out = fn.system(
      string.format("git clone https://github.com/wbthomason/packer.nvim %s", directory.."/packer.nvim")
    )

    print(out)
    print "Downloading packer.nvim..."
    print "( You'll need to restart now )"
  end

  return function()
    if not pcall(require, "packer") then
      download_packer()

      return true
    end

    return false
  end