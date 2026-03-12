return {
  -- Configure TreeSitter: enable in general but disable most key features
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.highlight = opts.highlight or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bibtex" })
      end
      -- Syntax Highlight: disable TreeSitter
      if type(opts.highlight.disable) == "table" then
        vim.list_extend(opts.highlight.disable, { "latex" })
      else
        opts.highlight.disable = { "latex" }
      end
    end,
  },
  -- Don't configure LSP at all. Let's see if VimTeX does everything perfectly
  -- VimTeX
  {
    "lervag/vimtex",
    init = function()
      local g = vim.g

      -- Auto view after compile: use VimTeX, not LSP
      -- -- It is related to what I use for auto compile
      -- -- Also, VimTeX can configure whether or not to give up window focus to PDF previewer
      if vim.fn.has("mac") then
        g.vimtex_view_method = "skim"
        g.vimtex_view_skim_sync = 1
        g.vimtex_view_skim_activate = 0
        g.vimtex_view_skim_reading_bar = 1
      end

      -- Syntax Highlight: use VimTeX, not TreeSitter.
      -- -- See *vimtex-faq-treesitter*
      -- -- Plus, current latex TS seems to not support expl3

      -- Syntax textobjects: use VimTeX, not TreeSitter.
      -- Because TS unifies the names across all languages (classes, methods...),
      -- and they contradict Tex terms (C for commands=functions, not classes)

      -- Completion: use VimTeX, not LSP
      g.vimtex_complete_enabled = 1

      -- Diagnostic: Prevent the quickfix window from automatically opening
      g.vimtex_quickfix_mode = 0

      -- Fold: use VimTeX, not TS
      g.vimtex_fold_enabled = 1

      -- Conceal: use VimTeX, not TS
      g.vimtex_syntax_conceal = {
        ligatures = 0,
        spacing = 0,
        sections = 1,
      }
      g.vimtex_syntax_conceal_cites = {
        ["type"] = "icon",
      }
      g.vimtex_syntax_custom_cmds = {
        {
          name = "chapter",
          conceal = true,
          concealchar = "§",
        },
        {
          name = "label",
          conceal = true,
          concealchar = "@",
        },
      }

      -- Auto compile: use VimTeX, not LSP

      -- math mode imaps
      g.vimtex_imaps_leader = "@"

      -- Compiler
      g.vimtex_compiler_latexmk = {
        aux_dir = "",
        out_dir = "",
        callback = 1,
        continuous = 0, -- I don't like continuous mode
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      vim.api.nvim_create_augroup("vimtex_config", {})
      vim.api.nvim_create_autocmd("User", {
        group = "vimtex_config",
        pattern = "VimtexEventInitPost",
        callback = function()
          -- Auto compile LaTeX when VimTex launches
          local vimtex = vim.api.nvim_buf_get_var(0, "vimtex")
          if vimtex.compiler.status and vimtex.compiler.status < 1 then
            vim.cmd("VimtexCompile")
          end

          -- More VimTex mappings
          vim.keymap.set({ "n", "i", "x" }, "ysc", "<Plug>(vimtex-cmd-create)", {
            buffer = true,
          })
          vim.keymap.set("n", "yse", "<Plug>(vimtex-env-surround-line)", {
            buffer = true,
          })
          vim.keymap.set("x", "yse", "<Plug>(vimtex-env-surround-visual)", {
            buffer = true,
          })
        end,
      })
    end,
  },
}
