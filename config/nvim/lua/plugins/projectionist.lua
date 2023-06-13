local config = {
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
    -- malomo.js
    ['src/*.js'] = {
      alternate = {
        'test/{dirname}/{basename}.test.js',
      },
      type = 'source',
      make = 'yarn',
    },
    ['test/*.test.js'] = {
      alternate = {
        'src/{dirname}/{basename}.js',
      },
      type = 'test',
      make = 'yarn',
    },
    -- end malomo.js
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

local M = {}

function M.setup()
  local new_heuristics
  if vim.g.projectionist_heuristics then
    new_heuristics = vim.tbl_extend('force', vim.g.projectionist_heuristics, config)
  else
    new_heuristics = config
  end

  vim.g.projectionist_heuristics = new_heuristics
end

return M
