-- vim projectionist allows creating :Esomething custom shortcuts (required by vim rake)
---@type LazySpec
return {
  'tpope/vim-projectionist',
  config = function()
    local config = {
      -- neovim
      ['config/nvim/init.lua'] = {
        -- neovim plugins
        ['config/nvim/lua/plugins/*.lua'] = {
          type = 'plugin',
          template = {
            '-- <description>',
            '---@type LazySpec',
            'return {',
            "  'author/plugin',",
            '}',
          },
        },
        ['config/nvim/after/lsp/*.lua'] = {
          type = 'lsp',
          template = {
            'vim.lsp.config("{}", {',
            '})',
          },
        },
      },
      -- Rust
      ['Cargo.toml'] = {
        ['*.rs'] = {
          make = 'cargo build',
        },
        ['src/*.rs'] = {
          type = 'source',
          alternate = { 'tests/{}.rs' },
        },
        ['tests/*.rs'] = {
          type = 'test',
          alternate = { 'src/{}.rs' },
        },
      },
      --
      -- BEGIN mod for PDQ codebase
      ['mix.exs'] = {
        ['lib/*_test.exs'] = {
          type = 'test',
          alternate = 'lib/{}.ex',
          template = {
            'defmodule {camelcase|capitalize|dot|elixir_module}Test do',
            '  use ExUnit.Case, async: true',
            '',
            '  alias {camelcase|capitalize|dot|elixir_module}',
            'end',
          },
        },
        ['lib/*.ex'] = {
          type = 'source',
          alternate = { 'test/{}_test.exs', 'lib/{}_test.exs' },
          template = { 'defmodule {camelcase|capitalize|dot} do', 'end' },
        },
      },
      -- END mod for PDQ codebase
      --
      -- JavaScript / TypeScript
      ['package.json'] = {
        ['*.js'] = {
          alternate = {
            '{dirname}/{basename}.test.js',
            '{dirname}/__tests__/{basename}.test.js',
            '{dirname}/{basename}.__tests__.js',
          },
          type = 'source',
          make = 'yarn',
        },
        ['*.__tests__.js'] = {
          alternate = { '{dirname}/{basename}.js', '{dirname}/../{basename}.js' },
          type = 'test',
        },
        ['*.test.js'] = {
          alternate = {
            '{dirname}/{basename}.js',
            '{dirname}/../{basename}.js',
          },
          type = 'test',
        },
        ['*.ts'] = {
          alternate = {
            '{dirname}/{basename}.test.ts',
            '{dirname}/{basename}.__tests__.ts',
            '{dirname}/__tests__/{basename}.test.ts',
          },
          type = 'source',
        },
        ['*.__tests__.ts'] = {
          alternate = { '{dirname}/{basename}.ts', '{dirname}/../{basename}.ts' },
          type = 'test',
        },
        ['*.__tests__.tsx'] = {
          alternate = { '{dirname}/{basename}.tsx', '{dirname}/../{basename}.tsx' },
          type = 'test',
        },
        ['*.test.ts'] = {
          alternate = {
            '{dirname}/{basename}.ts',
            '{dirname}/{basename}.tsx',
            '{dirname}/../{basename}.ts',
            '{dirname}/../{basename}.tsx',
          },
          type = 'test',
        },
        ['*.tsx'] = {
          alternate = {
            '{dirname}/{basename}.test.tsx',
            '{dirname}/{basename}.__tests__.tsx',
            '{dirname}/__tests__/{basename}.test.tsx',
          },
          type = 'source',
        },
        ['*.test.tsx'] = {
          alternate = {
            '{dirname}/{basename}.ts',
            '{dirname}/{basename}.tsx',
            '{dirname}/../{basename}.ts',
            '{dirname}/../{basename}.tsx',
          },
          type = 'test',
        },
        ['package.json'] = { type = 'package' },
      },
    }

    local new_heuristics
    if vim.g.projectionist_heuristics then
      new_heuristics = vim.tbl_deep_extend('force', vim.g.projectionist_heuristics, config)
    else
      new_heuristics = config
    end

    vim.g.projectionist_heuristics = new_heuristics
  end,
}
