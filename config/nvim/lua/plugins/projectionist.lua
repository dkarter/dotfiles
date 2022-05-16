vim.g.projectionist_heuristics = {
  -- Elixir
  ['mix.exs'] = {
    ['apps/*/mix.exs'] = { type = 'app' },
    ['lib/*.ex'] = {
      type = 'lib',
      alternate = {
        'test/{}_test.exs',
        'test/lib/{}_test.exs',
      },
      template = { 'defmodule {camelcase|capitalize|dot} do', 'end' },
    },
    ['test/*_test.exs'] = {
      type = 'test',
      alternate = { 'lib/{}.ex', '{}.ex' },
      template = {
        'defmodule {camelcase|capitalize|dot}Test do',
        '  use ExUnit.Case',
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
        '{dirname}/{basename}.test.tsx',
        '{dirname}/__tests__/{basename}.test.ts',
        '{dirname}/__tests__/{basename}.test.tsx',
      },
      type = 'source',
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
        '{dirname}/{basename}.test.ts',
        '{dirname}/{basename}.test.tsx',
        '{dirname}/__tests__/{basename}.test.ts',
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
