local feline_vi = require("feline.providers.vi_mode")
local feline_cursor = require("feline.providers.cursor")
local palette = require('nightfox.palette').load('nightfox')
local spec = require('nightfox.spec').load('nightfox')
local lsp_status = require('lsp-status')

---- feline keyword
-- { "violet", "yellow", "fg", "red", "orange", "black", "bg", "green", "oceanblue", "cyan", "magenta", "skyblue", "white" }
---- nightfox
-- { "comment", "orange", "pink", "sel1", "meta", "generate_spec", "bg0", "sel0", "fg3", "bg2", "bg3", "bg4", "fg0", "red", "fg1", "fg2", "black", "bg1", "green", "yellow", "blue", "magenta", "cyan", "white" }

local theme = {
  fg = palette.fg2,
  bg = palette.bg0,
  black = palette.black.base,
  white = palette.white.base,
  red = palette.red.base,
  orange = palette.orange.base,
  yellow = palette.yellow.base,
  green = palette.green.base,
  cyan = palette.cyan.base,
  skyblue = palette.blue.base,
  -- oceanblue,
  magenta = palette.magenta.base,
  violet = palette.pink.base,
}

local icons = {
  unix = "", -- e712
  mac = "", -- e711
  dos = "", -- e70f
  bomb = "", -- f1e2
  bin = "", -- e706
}

local c = {
  vi_mode = {
    provider = function ()
      return ' ' .. feline_vi.get_vim_mode() .. ' '
    end,
    icon = '',
    opts = {
      padding = 'center',
    },
    hl = function()
        return {
            name = require('feline.providers.vi_mode').get_mode_highlight_name(),
            bg = require('feline.providers.vi_mode').get_mode_color(),
            fg = 'bg',
            style = 'bold',
        }
    end,
    right_sep = 'right_filled',
  },
  file_info = {
    provider = {
      name = 'file_info',
      opts = {
        type = 'unique',
      }
    },
  },
  git_branch = {
    provider = 'git_branch',
  },
  lsp_name = {
    provider = 'lsp_client_names',
  },
  lsp_status = {
    provider = function ()
      return lsp_status.status()
    end,
    hl = {
      name = 'SLLspStatus',
      bg = palette.white.dim,
      fg = 'bg',
    },
    left_sep = {
      str = 'left_filled',
      hl = {
        name = 'SLLspStatusLeft',
        fg = palette.white.dim,
      },
      always_visible = true,
    },
  },
  diag_errors = {
    provider = 'diagnostic_errors',
    icon = '',
    hl = {
      name = 'SLError',
      fg = 'bg',
      bg = spec.diag.error,
    },
    left_sep = {
      str = 'left_filled',
      hl = {
        name = 'SLErrorLeft',
        fg = spec.diag.error,
        bg = palette.white.dim,
      },
      always_visible = true,
    },
  },
  diag_warnings = {
    provider = 'diagnostic_warnings',
    icon = '',
    hl = {
      name = 'SLWarn',
      fg = 'bg',
      bg = spec.diag.warn,
    },
    left_sep = {
      str = 'left_filled',
      hl = {
        name = 'SLWarnLeft',
        fg = spec.diag.warn,
        bg = spec.diag.error,
      },
      always_visible = true,
    },
  },
  diag_info = {
    provider = 'diagnostic_info',
    icon = '',
    hl = {
      name = 'SLInfo',
      fg = 'bg',
      bg = spec.diag.info,
    },
    left_sep = {
      str = 'left_filled',
      hl = {
        name = 'SLInfoLeft',
        fg = spec.diag.info,
        bg = spec.diag.warn,
      },
      always_visible = true,
    },
  },
  diag_hints = {
    provider = 'diagnostic_hints',
    icon = '',
    hl = {
      name = 'SLHint',
      fg = 'bg',
      bg = spec.diag.hint,
    },
    left_sep = {
      str = 'left_filled',
      hl = {
        name = 'SLHintLeft',
        fg = spec.diag.hint,
        bg = spec.diag.info,
      },
      always_visible = true,
    },
  },
  file_type = {
    provider = function ()
      local filetype = vim.bo.filetype
      return ' ' .. filetype .. ' '
    end,
    hl = {
      bg = palette.sel0,
      name = 'SLFileType'
    },
    left_sep = {
      str = 'left_filled',
      hl = {
        name = 'SLFileTypeLeft',
        fg = palette.sel0,
        bg = spec.diag.hint,
      },
      always_visible = true,
    },
    right_sep = {
      str = 'left_filled',
      hl = {
        name = 'SLFileTypeLeft',
        fg = 'bg',
        bg = palette.sel0,
      },
      always_visible = true,
    },
  },
  file_encoding = {
    provider = function ()
      local bomb = vim.bo.bomb
      local encoding = vim.bo.fileencoding
      if bomb then
        return encoding .. ' ' .. icons.bomb
      else
        return encoding
      end
    end,
    enabled = function ()
      return vim.bo.bomb or (vim.bo.fileencoding ~= 'utf-8')
    end,
    left_sep = ' ',
  },
  file_format = {
    provider = function ()
      local format = vim.bo.binary and 'bin' or vim.bo.fileformat
      return icons[format]
    end,
    enabled = function ()
      return vim.bo.binary or vim.bo.fileformat ~= 'unix'
    end,
    left_sep = ' ',
  },
  position = {
    provider = function ()
      local position = feline_cursor.position(nil, {})
      local percent = feline_cursor.line_percentage()
      return ' ' .. position .. ' ' .. percent .. ' '
    end,
    hl = function()
        return {
            name = require('feline.providers.vi_mode').get_mode_highlight_name(),
            bg = require('feline.providers.vi_mode').get_mode_color(),
            fg = 'bg',
            style = 'bold',
        }
    end,
    left_sep = "left_filled",
  },
  empty = {},
}


local components = {
    active = {
      {
        c.vi_mode,
        c.file_info,
        c.git_branch,
        c.empty,
      },
      {
        c.lsp_name,
        c.empty,
      },
      {
        c.lsp_status,
        c.diag_errors,
        c.diag_warnings,
        c.diag_info,
        c.diag_hints,
        c.file_type,
        c.file_encoding,
        c.file_format,
        c.position,
        c.empty,
      },
    },
    inactive = {}
}

-- add seps
-- local sep_keys = {'right_sep', nil, 'left_sep'}
-- for i=1,3 do
--   local k = sep_keys[i]
--   if k == nil then
--     goto continue
--   end
--   local section = components.active[i]
--   local cnt = vim.tbl_count(section)
--   local reverse = false
--   local cur = 1
--   local next = 2
--   if k == 'left_sep' then
--     reverse = true
--     cur = cnt
--     next = cnt - 1
--   end
--   while cur <= cnt and cur >= 1 do
--     local cur_hl = section[cur].hl or theme
--     local next_hl = section[next].hl or theme
--     section[cur][k] = {
--       str = reverse and 'left_filled' or 'right_filled',
--       hl = {
--         fg = cur_hl.bg,
--         bg = next_hl.bg,
--         -- name = cur_hl.name .. (reverse and 'Left' or 'Right')
--       }
--     }
--     if cur_hl.name ~= nil then
--       section[cur][k].hl.name = cur_hl.name .. (reverse and 'Left' or 'Right')
--     end
--     if reverse then
--       cur = cur - 1
--       next = next - 1
--     else
--       cur = cur + 1
--       next = next + 1
--     end
--   end
--   ::continue::
-- end
--
require('feline').setup({
  preset = 'noicon',
  components = components,
  theme = theme,
})
