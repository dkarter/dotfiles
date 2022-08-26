vim.g.projectionist_heuristics = {
  -- Elixir
  ['mix.exs'] = {
    ['apps/*/mix.exs'] = { type = 'app' },
    ['lib/*.ex'] = {
      type = 'lib',
      alternate = {
        'test/{}_test.exs',
      },
      template = { 'defmodule {camelcase|capitalize|dot} do', 'end' },
    },
    ['test/*_test.exs'] = {
      type = 'test',
      alternate = { 'lib/{}.ex', '{}.ex' },
      template = {
        'defmodule {camelcase|capitalize|dot}Test do',
        '  use ExUnit.Case, async: true',
        '',
        '  alias {camelcase|capitalize|dot}, as: Subject',
        '',
        '  doctest Subject',
        'end',
      },
    },
    ['mix.exs'] = { type = 'mix' },
    ['config/*.exs'] = { type = 'config' },
  },

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
      alternate = { '{dirname}/{basename}.js', '{dirname}/../{basename}.js' },
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
