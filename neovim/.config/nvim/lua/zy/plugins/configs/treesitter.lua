local keys = require('zy.keybindings')

require'nvim-treesitter.configs'.setup({
    ensure_installed = {
        "bash",
        "bibtex",
        -- "c",
        -- "cpp",
        "css",
        "go",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "latex",
        "lua",
        "markdown",
        "python",
        "scss",
        "toml",
        "typescript",
        "tsx",
        "vim",
        "vue",
        "yaml",
    },

    sync_install = false,

    -- ignore_install = { "javascript" },

    highlight = {
        enable = true,
        -- disable = { "c", "rust" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = keys.ts.incremental_selection,
    },

    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    }
})
