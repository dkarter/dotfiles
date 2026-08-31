--  Better syntax highlighting (and more)
---@type string[]
local parsers = {
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
  'kdl',
  'liquid',
  'llvm',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'mermaid',
  'nginx',
  'promql',
  'python',
  'query',
  'regex',
  'ruby',
  'rust',
  'scss',
  'sql',
  'ssh_config',
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
}

---@type LazySpec[]
---@diagnostic disable: missing-fields
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = function()
      require('nvim-treesitter').update(parsers):wait(300000)
    end,
    dependencies = {},
    opts = {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    },
    init = function()
      require('vim.treesitter.query').add_predicate('is-mise?', function(_, _, bufnr, _)
        local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
        local filename = vim.fn.fnamemodify(filepath, ':t')
        return string.match(filename, '.*mise.*%.toml$') ~= nil
      end, { force = true, all = false })
    end,
    config = function(_, opts)
      local ts = require 'nvim-treesitter'
      ts.setup(opts)
      if vim.fn.executable 'tree-sitter' == 1 then
        ts.install(parsers)
      end

      local augroup = require('core.utils').augroup

      local function is_supported_by_treesitter(buf)
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang or lang == '' then
          return false
        end

        local ok, parser = pcall(vim.treesitter.get_parser, buf, lang, { error = false })
        return ok and parser ~= nil
      end

      local function is_small_file(buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        return not (ok and stats and stats.size > max_filesize)
      end

      augroup('TreesitterStuff', {
        {
          event = { 'FileType' },
          pattern = { '*' },
          command = function()
            local buf = vim.api.nvim_get_current_buf()
            local supported = is_supported_by_treesitter(buf)

            if supported and is_small_file(buf) then
              pcall(vim.treesitter.start, buf)
            end

            if supported then
              vim.bo.autoindent = false
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            else
              vim.bo.autoindent = true
              vim.bo.indentexpr = ''
            end
          end,
        },
        {
          event = { 'FileType' },
          pattern = { '*' },
          command = function(args)
            local disabled_fts = { 'gitcommit' }

            if not vim.tbl_contains(disabled_fts, args.match) then
              local winid = vim.api.nvim_get_current_win()
              vim.wo[winid][0].foldmethod = 'expr'
              vim.wo[winid][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
              -- disable folds at startup
              vim.wo[winid][0].foldenable = false
            end
          end,
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local swap = require 'nvim-treesitter-textobjects.swap'
      local move = require 'nvim-treesitter-textobjects.move'

      local select_maps = {
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
        am = '@class.outer',
        im = '@class.inner',
        ia = '@parameter.inner',
        aa = '@parameter.outer',
        ib = '@block.inner',
        ab = '@block.outer',
        ik = '@comment.inner',
        ak = '@comment.outer',
        ['is'] = '@scope.inner',
        ['as'] = '@scope.outer',
      }

      for lhs, query in pairs(select_maps) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(query, 'textobjects')
        end, { desc = 'Treesitter textobject: ' .. lhs })
      end

      vim.keymap.set('n', '<leader>>', function()
        swap.swap_next '@parameter.inner'
      end, { desc = 'Swap next parameter' })

      vim.keymap.set('n', '<leader><', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = 'Swap previous parameter' })

      local modes = { 'n', 'x', 'o' }

      vim.keymap.set(modes, ']m', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next method/fun' })
      vim.keymap.set(modes, ']k', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class start' })
      vim.keymap.set(modes, ']o', function()
        move.goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end, { desc = 'Next loop' })
      vim.keymap.set(modes, ']S', function()
        move.goto_next_start('@local.scope', 'locals')
      end, { desc = 'Next scope' })
      vim.keymap.set(modes, ']z', function()
        move.goto_next_start('@fold', 'folds')
      end, { desc = 'Next fold' })

      vim.keymap.set(modes, '[m', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Prev method/fun' })
      vim.keymap.set(modes, '[k', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Prev class start' })
      vim.keymap.set(modes, '[o', function()
        move.goto_previous_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end, { desc = 'Prev loop' })
      vim.keymap.set(modes, '[S', function()
        move.goto_previous_start('@local.scope', 'locals')
      end, { desc = 'Prev scope' })
      vim.keymap.set(modes, '[z', function()
        move.goto_previous_start('@fold', 'folds')
      end, { desc = 'Prev fold' })

      vim.keymap.set(modes, ']M', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next method/fun end' })
      vim.keymap.set(modes, ']K', function()
        move.goto_next_end('@class.outer', 'textobjects')
      end, { desc = 'Next class/module end' })

      vim.keymap.set(modes, '[M', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Prev method/fun end' })
      vim.keymap.set(modes, '[K', function()
        move.goto_previous_end('@class.outer', 'textobjects')
      end, { desc = 'Prev class/module end' })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'RRethy/nvim-treesitter-endwise',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
