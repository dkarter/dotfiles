--  Better syntax highlighting (and more)
---@type LazySpec[]
return {
  {
    'dkarter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {},
    ---@type TSConfig
    opts = {
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      -- List of parsers to ignore installing
      ignore_install = { 'tmux' },

      -- see full list here:
      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      ensure_installed = {
        'arduino',
        'bash',
        'c',
        'cmake',
        'comment',
        'cpp',
        'css',
        'csv',
        'diff',
        'dockerfile',
        'eex',
        'elixir',
        'elm',
        'erlang',
        'gitcommit',
        'git_rebase',
        'gitignore',
        'gleam',
        'go',
        'graphql',
        'haskell',
        'heex',
        'helm',
        'hjson',
        'html',
        'http',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'jsonc',
        'llvm',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'nginx',
        'python',
        'query',
        'regex',
        'ruby',
        'rust',
        'scss',
        'sql',
        'surface',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
        'zig',
      },
      ---@type TSModule
      highlight = { enable = true },
      ---@type TSModule
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- disable folds at startup
      vim.o.foldenable = false
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      ---@type TSConfig
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['ip'] = '@parameter.inner',
              ['ap'] = '@parameter.outer',
              ['ib'] = '@block.inner',
              ['ab'] = '@block.outer',
              ['ik'] = '@comment.inner',
              ['ak'] = '@comment.outer',
              ['is'] = '@scope.inner',
              ['as'] = '@scope.outer',
            },
          },

          swap = {
            enable = true,
            swap_next = {
              ['<leader>pn'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>pp'] = '@parameter.inner',
            },
          },

          move = {
            enable = true,
            -- whether to set jumps in the jumplist
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ['<leader>df'] = '@function.outer',
              ['<leader>dF'] = '@class.outer',
            },
          },
        },
      }
    end,
    dependencies = {
      'dkarter/nvim-treesitter',
    },
  },
  {
    'RRethy/nvim-treesitter-endwise',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      ---@type TSConfig
      require('nvim-treesitter.configs').setup {
        ---@type TSModule
        endwise = {
          enable = true,
        },
      }
    end,
    dependencies = {
      'dkarter/nvim-treesitter',
    },
  },
  {
    'nvim-treesitter/playground',
    cmd = 'TSPlaygroundToggle',
    config = function()
      ---@type TSConfig
      require('nvim-treesitter.configs').setup {
        -- :TSPlaygroundToggle
        ---@type TSModule
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'gq',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        ---@type TSModule
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { 'BufWrite', 'CursorHold' },
        },
      }
    end,
    dependencies = {
      'dkarter/nvim-treesitter',
    },
  },
}
