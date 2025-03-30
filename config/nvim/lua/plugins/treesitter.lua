--  Better syntax highlighting (and more)
---@type LazySpec[]
---@diagnostic disable: missing-fields
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
        'editorconfig',
        'eex',
        'elixir',
        'elm',
        'erlang',
        'git_config',
        'git_rebase',
        'gitcommit',
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
        'promql',
        'python',
        'query',
        'regex',
        'ruby',
        'rust',
        'scss',
        'sql',
        'surface',
        'terraform',
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
      highlight = {
        enable = true,
        -- disable treesitter highlighting for really large files
        disable = function(_lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      ---@type TSModule
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      local augroup = require('core.utils').augroup

      augroup('TreesitterStuff', {
        -- toggle `autoindent` based on treesitter support - for langs that don't support
        -- treesitter `autoindent` is fine, but for langs that do have support, I'd rather
        -- use treesitter for indentation (this was an issue in Lua when pressing `o` on
        -- a line, in a table of strings, the line below would deindent to the left and
        -- a message showed up saying "Workspace edit Indent Fix". Turning off
        -- `autoindent` fixed the issue)
        {
          event = { 'FileType' },
          pattern = { '*' },
          command = function()
            local function is_supported_by_treesitter()
              local parsers = require 'nvim-treesitter.parsers'
              local buf = vim.api.nvim_get_current_buf()
              local lang = parsers.get_buf_lang(buf)
              return parsers.has_parser(lang)
            end

            if is_supported_by_treesitter() then
              vim.bo.autoindent = false
            else
              vim.bo.autoindent = true
            end
          end,
        },
      })
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
              -- repeat for module - does the same thing but maps differently in
              -- my 🧠
              ['am'] = '@class.outer',
              ['im'] = '@class.inner',
              ['ia'] = '@parameter.inner',
              ['aa'] = '@parameter.outer',
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
              ['<leader>>'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader><'] = '@parameter.inner',
            },
          },

          move = {
            enable = true,
            -- whether to set jumps in the jumplist
            set_jumps = true,
            goto_next_start = {
              [']m'] = { query = '@function.outer', desc = 'Next method/fun' },
              [']c'] = { query = '@class.outer', desc = 'Next class start' },
              [']o'] = { query = { '@loop.inner', '@loop.outer' }, desc = 'Next loop' },
              [']S'] = { query = '@local.scope', query_group = 'locals', desc = 'Next scope' },
              [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
            },
            goto_previous_start = {
              ['[m'] = { query = '@function.outer', desc = 'Prev method/fun' },
              ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
              ['[o'] = { query = { '@loop.inner', '@loop.outer' }, desc = 'Prev loop' },
              ['[S'] = { query = '@local.scope', query_group = 'locals', desc = 'Prev scope' },
              ['[z'] = { query = '@fold', query_group = 'folds', desc = 'Prev fold' },
            },
            goto_next_end = {
              [']M'] = { query = '@function.outer', desc = 'Next method/fun end' },
              [']C'] = { query = '@class.outer', desc = 'Next class/module end' },
            },
            goto_previous_end = {
              [']M'] = { query = '@function.outer', desc = 'Prev method/fun end' },
              [']C'] = { query = '@class.outer', desc = 'Prev class/module end' },
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
