local packer = require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'
    -- use 'dstein64/vim-startuptime'

    -- Put color scheme at top to be sourced by others.
    use {
        'EdenEast/nightfox.nvim',
        config = function ()
            vim.cmd("colorscheme nightfox")
        end
    }
    -- use {
    --     'rmehri01/onenord.nvim',
    --     config = function ()
    --         require('onenord').setup()
    --     end
    -- }
    -- use {
    --     'olimorris/onedarkpro.nvim',
    --     config = function ()
    --         require("onedarkpro").load()
    --     end
    -- }
    -- use {
    --     'rafamadriz/neon',
    --     config = function ()
    --         vim.cmd[[colorscheme neon]]
    --         vim.g.neon_style = 'doom'
    --     end
    -- }

    -- text functions
    -- Edit pair surroundings
    use 'machakann/vim-sandwich'
    -- Detect indent
    use 'tpope/vim-sleuth'
    -- Auto-complete pairs
    use {
        'windwp/nvim-autopairs',
        config = function ()
            require('nvim-autopairs').setup{}
        end
    }
    -- comment
    use {
        'numToStr/Comment.nvim',
        config = function ()
            require('zy.plugins.configs.comment')
        end
    }

    -- language specific
    -- use 'KeitaNakamura/tex-conceal.vim' -- TeX conceal. TODO: Not working?
    use 'folke/lua-dev.nvim' -- Lua lsp config + nvim API

    -- editor functions
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icon
        },
        config = function() require'nvim-tree'.setup {} end
    }
    use {
        'ahmedkhalf/project.nvim',
        config = function ()
            require("project_nvim").setup({
                patterns = {
                    ".git",
                    "package.json",
                    "requirements.txt",
                    "go.mod",
                    ".sln",
                    "Makefile",
                    "_darcs",
                    ".svn",
                    ".hg",
                    ".bzr",
                }
            })
        end
    }
    use {
        'folke/which-key.nvim',
        config = function ()
            require("which-key").setup{}
        end
    }
    use {
        'goolord/alpha-nvim',
        config = function ()
            require('zy.plugins.configs.alpha')
        end
    }
    use {
        'lewis6991/gitsigns.nvim',
        config = function ()
            require('gitsigns').setup()
        end
    }
    use {
        'Tastyep/structlog.nvim',
        disable = true,
        config = function ()
            require('zy.plugins.configs.structlog')
        end
    }

    -- lsp
    use {
        'neovim/nvim-lspconfig',
        config = function ()
            require('zy.plugins.lsp')
        end
    }
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })
    -- use {
    --     'glepnir/lspsaga.nvim',
    --     config = function () require('lspsaga').init_lsp_saga() end
    -- }
    -- use 'onsails/lspkind-nvim' -- a type icon for each suggestion

    -- cmp
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-nvim-lsp',
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
            { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
            {'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp'},
            'lukas-reineke/cmp-under-comparator',
        },
        config = function ()
            require('zy.plugins.configs.cmp')
        end,
        event = 'InsertEnter *',
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                run = 'make',
            },
        },
        after = "project.nvim",
        config = function ()
            require('zy.plugins.configs.telescope')
        end
    }

    -- dap
    use 'mfussenegger/nvim-dap'

    -- editor UI
    -- status lines
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        after = 'nightfox.nvim',
        config = function ()
            require('lualine').setup()
        end,
        disable = true,
    }
    use {
        'feline-nvim/feline.nvim',
        requires = {
            {'kyazdani42/nvim-web-devicons', opt=true},
            {'lewis6991/gitsigns.nvim', opt=true},
        },
        after = 'nightfox.nvim',
        config = function ()
            require('zy.plugins.feline')
        end
    }
    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function ()
            require("bufferline").setup({
                close_icon = "窱"
            })
        end
    }
    use {
        'nvim-lua/lsp-status.nvim',
        config = function ()
            require('zy.plugins.configs.lsp-status')
        end
    }
    use {
        'rcarriga/nvim-notify',
        config = function ()
            require('zy.plugins.configs.nvim-notify')
        end
    }

    -- treesitter
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function ()
            require('zy.plugins.configs.treesitter')
        end
    }

    -- misc
    use 'antoinemadec/FixCursorHold.nvim'

    -- playgrounds
    use {
        'rafcamlet/nvim-luapad',
        cmd = 'Luapad',
    }
    use {
        'nvim-treesitter/playground',
        requires = {
            'nvim-treesitter/nvim-treesitter'
        },
        config = function ()
            require "nvim-treesitter.configs".setup({})
        end,
        cmd = {
            'TSPlaygroundToggle',
            'TSHighlightCapturesUnderCursor',
        },
    }
end)

return packer

-- vim: set foldmethod=marker:
