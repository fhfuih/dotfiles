local keymaps = require("configs.keymaps")

local highlight_disable_size = 1024 * 1024 -- 1M

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    keys = keymaps.treesitter.lazy,
    ---@type TSConfig
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      ignore_install = { "latex" },
      highlight = {
        enable = true,
        disable = function(_, buf)
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > highlight_disable_size then
            vim.notify("File too large. TS highlight is disabled", vim.log.levels.INFO)
            return true
          end
        end,
        additional_vim_regex_highlighting = { "latex" },
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = keymaps.treesitter.config.incremental_selection,
      },
      -- JoosepAlviste/nvim-ts-context-commentstring
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      -- nvim-treesitter/nvim-treesitter-textobjects
      textobjects = {
        enable = true,
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = keymaps.treesitter.config.textobjects,
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = true,
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local tsps = require("nvim-treesitter.parsers")
          local ft = args.match
          if tsps.has_parser(tsps.ft_to_lang(ft)) then
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
          end
        end,
      })
    end,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
}
