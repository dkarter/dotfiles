local core_mappings = require 'core.mappings'

require('lazy').setup({
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- snippet engine, required by cmp
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          -- snippets!
          'rafamadriz/friendly-snippets',
        },
      },
      -- LSP driven completions
      'hrsh7th/cmp-nvim-lsp',
      -- completion from buffer text
      'hrsh7th/cmp-buffer',
      -- file path completion
      'hrsh7th/cmp-path',
      -- command line completion
      'hrsh7th/cmp-cmdline',
      -- neovim lua config api completion
      'hrsh7th/cmp-nvim-lua',
      -- emoji completion (triggered by `:`)
      'hrsh7th/cmp-emoji',
      -- snippets in completion sources
      'saadparwaiz1/cmp_luasnip',
      -- git completions
      'petertriho/cmp-git',
      -- tmux pane completion
      'andersevenrud/cmp-tmux',
      -- icons for the completion menu
      'onsails/lspkind.nvim',
    },
    config = function()
      require('plugins.cmp').setup()
    end,
  },

  -- installs/updates LSPs, linters and DAPs
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    event = 'VeryLazy',
    dependencies = {
      -- handles connection of LSP Configs and Mason
      'williamboman/mason-lspconfig.nvim',

      -- Collection of configurations for the built-in LSP client
      'neovim/nvim-lspconfig',

      -- required for setting up capabilities for cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('plugins.lsp').setup()
    end,
  },

  -- elixir lsp support
  {
    'elixir-tools/elixir-tools.nvim',
    version = '*',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local elixir = require 'elixir'
      local elixirls = require 'elixir.elixirls'

      elixir.setup {
        nextls = { enable = false },
        credo = { enable = true },
        elixirls = {
          enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = true,
            enableTestLenses = false,
          },
          on_attach = function(client, bufnr)
            core_mappings.elixir_mappings()
            require('plugins.lsp').on_attach(client, bufnr)
          end,
        },
      }
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- Neovim as a language server to inject LSP diagnostics, code
  -- actions, and more via Lua.
  -- This is now using the community fork: https://github.com/nvimtools/none-ls.nvim
  {
    'nvimtools/none-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'williamboman/mason.nvim',
      'lukas-reineke/lsp-format.nvim',
    },
    config = function()
      require('plugins.null-ls').setup()
    end,
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
    },
    -- this is a good example of how to have both `opts` and `config`
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
  },

  --  pretty diagnostics, references, telescope results, quickfix and location
  --  list to help you solve all the trouble your code is causing.
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble', 'TroubleToggle' },
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = core_mappings.trouble_mappings,
    opts = {},
  },

  -- modern vim command line replacement, requires nvim 0.9 or higher
  {
    'folke/noice.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 1,
            col = '50%',
          },
        },
      },
      presets = {
        -- you can enable a preset by setting it to true, or a table that will override the preset config
        -- you can also add custom presets that you can enable/disable with enabled=true
        bottom_search = true, -- use a classic bottom cmdline for search
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },

      routes = {
        -- hide buffer written messages
        {
          view = 'mini',
          filter = {
            event = 'msg_show',
            kind = '',
            find = 'written',
          },
          opts = {},
        },
        -- hide the annoying code_action notifications from null ls
        {
          filter = {
            event = 'lsp',
            kind = 'progress',
            cond = function(message)
              local title = vim.tbl_get(message.opts, 'progress', 'title')
              local client = vim.tbl_get(message.opts, 'progress', 'client')

              -- skip null-ls noisy messages
              return client == 'null-ls' and title == 'code_action'
            end,
          },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      { 'MunifTanjim/nui.nvim', lazy = true },
      'rcarriga/nvim-notify',
    },
  },

  -- color schemes
  ----------------
  {
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('tokyonight').setup {
        style = 'moon',
        transparent = true,
      }

      vim.cmd [[colorscheme tokyonight]]
    end,
  },

  -- highlight color hex codes with their color (fast!)
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      '*',
      '!lazy',
    },
  },

  -- highlight and search todo/fixme/hack etc comments
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {},
    keys = core_mappings.todo_comments_mappings,
  },

  -- status line
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('plugins.lualine').setup()
    end,
  },

  -- Visual git gutter (also used by feline)
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = require 'plugins.gitsigns',
  },

  -- syntax highlighting for zinit (zsh plugin manager)
  { 'zdharma-continuum/zinit-vim-syntax', ft = { 'zsh' } },

  -- Comment out code easily
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('plugins.comment').setup()
    end,
  },

  {
    'echasnovski/mini.bufremove',
    keys = core_mappings.bufremove_mappings,
  },

  -- nginx syntax support
  'chr4/nginx.vim',

  -- run tests at the speed of thought
  {
    'janko-m/vim-test',
    keys = core_mappings.vim_test_mappings,
    dependencies = { 'benmills/vimux' },
    init = function()
      vim.g['test#strategy'] = 'vimux'
      -- accommodations for Malomo's unusual folder structure on Dash
      vim.cmd [[let test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test|__tests__))\.(js|jsx|coffee|ts|tsx)$']]
    end,
  },

  -- git integration
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    config = function()
      core_mappings.fugitive_mappings()
    end,
  },

  -- github support for fugitive
  {
    'tpope/vim-rhubarb',
    event = 'VeryLazy',
    dependencies = { 'tpope/vim-fugitive' },
    keys = core_mappings.rhubarb_mappings,
  },

  --  Better syntax highlighting (and more)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-context',
    },
    config = function()
      require('plugins.treesitter').setup()
    end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- play with TreeShitter
  {
    'nvim-treesitter/playground',
    cmd = 'TSPlaygroundToggle',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- support for MJML templates
  -- NOTE: technically ftdetection dictates that this shouldn't be VeryLazy, but
  -- the chances of me opening an mjml file as the first file are relatively
  -- low, so I think this is OK
  { 'amadeus/vim-mjml', event = 'VeryLazy' },

  -- auto complete closable pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  -- auto close html/tsx tags using TreeSitter
  {
    'windwp/nvim-ts-autotag',
    ft = {
      'html',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'svelte',
      'vue',
      'tsx',
      'jsx',
      'rescript',
      'xml',
      'php',
      'markdown',
      'astro',
      'glimmer',
      'handlebars',
      'hbs',
    },
    opts = {},
  },

  -- file tree
  {
    'nvim-tree/nvim-tree.lua',
    keys = core_mappings.nvim_tree_mappings,
    cmd = 'NvimTreeToggle',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = require 'plugins.nvimtree',
  },

  -- navigate to directory of current file using `-`
  'tpope/vim-vinegar',

  -- automatically adjusts 'shiftwidth' and 'expandtab' heuristically
  'tpope/vim-sleuth',

  -- ruby gem info directly in a Gemfile
  { 'alexbel/vim-rubygems', ft = { 'ruby' } },

  -- Elixir: {{{

  -- pulls info on hex packages (dependencies mattn/webapi-vim)
  { 'lucidstack/hex.vim', ft = { 'elixir' }, dependencies = { 'mattn/webapi-vim' } },
  -- }}},

  -- Vim sugar for the UNIX shell commands that need it the most.
  {
    'tpope/vim-eunuch',
    cmd = {
      'Remove',
      'Delete',
      'Move',
      'Rename',
      'Copy',
      'Duplicate',
      'Chmod',
      'Mkdir',
      'Cfind',
      'Clocate',
      'Lfind',
      'Llocate',
      'Wall',
      'SudoWrite',
      'SudoEdit',
    },
  },

  -- allow (non-native) plugins to the . command
  { 'tpope/vim-repeat', event = 'VeryLazy' },

  -- Surround text with closures
  { 'tpope/vim-surround', event = { 'BufReadPost', 'BufNewFile' } },

  -- vim projectionist allows creating :Esomething custom shortcuts (required by vim rake)
  {
    'tpope/vim-projectionist',
    config = function()
      require('plugins.projectionist').setup()
    end,
  },

  -- vim unimpaired fixes daily annoyances
  { 'tpope/vim-unimpaired', event = 'VeryLazy' },

  -- abolish.vim: easily search for, substitute, and abbreviate multiple variants
  -- of a word
  { 'tpope/vim-abolish', event = 'VeryLazy' },

  -- Support emacs keybindings in insert mode
  { 'tpope/vim-rsi', event = 'VeryLazy' },

  -- RagTag: Auto-close html tags + mappings for template scripting languages
  -- TODO: add ft lazy loading
  { 'tpope/vim-ragtag', event = { 'BufReadPost', 'BufNewFile' } },

  -- smarter gx mapping
  {
    'chrishrb/gx.nvim',
    keys = { 'gx' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      handler_options = {
        search_engine = 'duckduckgo',
      },
    },
  },

  -- automatic bulleted lists
  {
    'dkarter/bullets.vim',
    init = function()
      vim.g.bullets_enabled_file_types = {
        'markdown',
        'text',
        'gitcommit',
        'scratch',
      }
    end,
    ft = {
      'markdown',
      'text',
      'gitcommit',
      'scratch',
    },
  },

  -- replacement for matchit
  {
    'andymass/vim-matchup',
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      vim.g.matchup_matchparen_deferred = 1
    end,
  },

  -- show trailing white spaces and automatically delete them on write
  {
    'zakharykaplan/nvim-retrail',
    event = { 'BufReadPost', 'BufNewFile' },
    opt = require 'plugins.retrail',
  },

  -- Convert code to multiline
  {
    'AndrewRadev/splitjoin.vim',
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      vim.g.splitjoin_align = 1
      vim.g.splitjoin_trailing_comma = 1
      vim.g.splitjoin_ruby_curly_braces = 0
      vim.g.splitjoin_ruby_hanging_args = 0
    end,
  },

  -- Toggle between different language verbs or syntax styles
  {
    'AndrewRadev/switch.vim',
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      vim.g.switch_custom_definitions = {
        { 'up', 'down', 'change' },
        { 'add', 'drop', 'remove' },
        { 'create', 'drop' },
        { 'row', 'column' },
        { 'first', 'second', 'third', 'fourth', 'fifth' },
        { 'yes', 'no' },
      }
    end,
  },

  -- The ultimate undo history visualizer for VIM
  {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle' },
    keys = core_mappings.undotree_mappings,
  },

  --  Indent lines (visual indication)
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = {
        char = '│',
      },
      exclude = {
        filetypes = {
          '',
          'alpha',
          'NvimTree',
          'TelescopePrompt',
          'checkhealth',
          'dashboard',
          'help',
          'lazy',
          'lazyterm',
          'lspinfo',
          'man',
          'mason',
          'notify',
          'nofile',
          'qf',
          'quickfix',
          'terminal',
        },
      },
      scope = {
        enabled = false,
      },
    },
  },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    'echasnovski/mini.indentscope',
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      -- symbol = "▏",
      symbol = '│',
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          '',
          'alpha',
          'NvimTree',
          'TelescopePrompt',
          'checkhealth',
          'dashboard',
          'help',
          'lazy',
          'lazyterm',
          'lspinfo',
          'man',
          'mason',
          'notify',
          'nofile',
          'qf',
          'quickfix',
          'terminal',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- start page
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      -- Set header
      dashboard.section.header.val = {
        '                                                     ',
        '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        '                                                     ',
      }

      dashboard.section.buttons.val = {
        dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files <CR>'),
        dashboard.button('n', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('s', ' ' .. ' Git Status files', ':Telescope git_status<CR>'),
        dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles <CR>'),
        dashboard.button('g', ' ' .. ' Grep', ':FzfRg!<CR>'),
        dashboard.button('c', ' ' .. ' Config', ":lua require('plugins.telescope').find_dotfiles()<CR>"),
        dashboard.button('l', '󰒲 ' .. ' Lazy', ':Lazy<CR>'),
        dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
      }

      alpha.setup(dashboard.opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					-- stylua: ignore
					dashboard.section.footer.val = '⚡ ' .. stats.count .. ' plugins loaded in ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- fuzzy find things
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-github.nvim',
      'olacin/telescope-cc.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'folke/tokyonight.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      -- Telescope uses treesitter for previews
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('plugins.telescope').setup()
    end,
    keys = core_mappings.telescope_mappings,
  },

  { 'junegunn/fzf', event = 'VeryLazy', build = ':call fzf#install()' },

  {
    'junegunn/fzf.vim',
    event = 'VeryLazy',
    config = function()
      vim.cmd [[
        command! -bang -nargs=* FzfRg
          \ call fzf#vim#grep(
          \   'rg --column --line-number --no-heading --color=always --smart-case --hidden '.shellescape(<q-args>), 1,
          \   <bang>0 ? fzf#vim#with_preview('up:60%')
          \           : fzf#vim#with_preview('right:50%:hidden', '?'),
          \   <bang>0)

        nnoremap <silent> <C-g>g :FzfRg!<CR>
      ]]
    end,
  },

  -- better ui for vim.ui commands
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
  },

  -- RipGrep - grep is dead. All hail the new king RipGrep.
  {
    'jremmen/vim-ripgrep',
    cmd = 'Rg',
    init = function()
      -- allow hidden files to be searched and smart case
      vim.g.rg_command = 'rg --vimgrep --hidden --smart-case'
      vim.g.rg_highlight = 1
    end,
    keys = core_mappings.ripgrep_mappings,
  },

  -- displays a popup with possible key bindings e.g. <leader>f will show f as
  -- the next possible character
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  -- same as tabular but by Junegunn and way easier
  {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
    keys = core_mappings.easy_align_mappings,
  },

  -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = core_mappings.diffview_mappings,
  },

  -- Helm Chart syntax
  { 'towolf/vim-helm', event = { 'BufReadPre', 'BufNewFile' } },

  -- attempt stuff using scratch buffer and pre-configured bootstrap
  {
    'm-demare/attempt.nvim',
    keys = core_mappings.attempt_mappings,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('attempt').setup(require 'plugins.attempt')
      require('telescope').load_extension 'attempt'
    end,
  },

  --- TMUX ---

  -- tmux config file stuff
  { 'tmux-plugins/vim-tmux', ft = 'tmux' },

  {
    'aserowy/tmux.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  -- notifications
  {
    'rcarriga/nvim-notify',
    opts = {
      background_colour = '#000',
    },
    config = function(_notify, opts)
      local notify = require 'notify'
      notify.setup(opts)
      vim.notify = notify
      core_mappings.notify_mappings()
    end,
  },
}, {
  concurrency = 8,
  -- Uncomment to debug an issue with a plugin by disabling all other plugins
  -- defaults = {
  --   cond = function(plugin)
  --     local _, plugin_name = next(plugin)
  --
  --     local enabledPlugins = { 'foo', 'bar', 'baz' }
  --     local found = false
  --
  --     for _, value in ipairs(enabledPlugins) do
  --       if value == plugin_name then
  --         return true
  --       end
  --     end
  --
  --     return false
  --   end,
  -- },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
