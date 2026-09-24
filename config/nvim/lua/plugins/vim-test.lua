-- run tests at the speed of thought
---@type LazySpec
return {
  'janko-m/vim-test',
  keys = require('core.mappings').vim_test_mappings,
  init = function()
    -- Prefer an explicit Vitest import over Playwright's project-wide detection.
    -- Houston has Playwright at the root, so its assets/*.test.tsx files otherwise
    -- get picked up by Playwright before vim-test checks for Vitest.
    vim.g['test#custom_runners'] = { JavaScript = { 'Vitest' } }

    local function configure_houston_vitest()
      local file = vim.api.nvim_buf_get_name(0)
      local root = vim.fs.root(0, 'mix.exs')
      local is_houston_assets = root
        and file:sub(1, #root + 8) == root .. '/assets/'
        and vim.uv.fs_stat(root .. '/assets/package.json') ~= nil

      if is_houston_assets then
        vim.g['test#javascript#vitest#executable'] = 'aube --filter assets run test:vitest --'
        -- aube runs the script inside assets, so pass Vitest an absolute file path.
        vim.g['test#filename_modifier'] = ':p'
      else
        vim.g['test#javascript#vitest#executable'] = nil
        vim.g['test#filename_modifier'] = nil
      end
    end

    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('vim_test_houston_vitest', { clear = true }),
      callback = configure_houston_vitest,
    })
    configure_houston_vitest()

    if not require('core.utils').in_herdr() then
      return
    end

    local runner = require 'core.smart_herdr'

    pcall(vim.api.nvim_create_user_command, 'SmartHerdrSmoke', function(opts)
      local cmd = opts.args ~= '' and opts.args or 'printf "smart-herdr smoke\n"'
      runner.run(cmd)
    end, { nargs = '*' })

    local custom_strategies = vim.g['test#custom_strategies'] or {}
    custom_strategies.smart_herdr = function(cmd)
      runner.run(cmd)
    end
    vim.g['test#custom_strategies'] = custom_strategies

    vim.g['test#strategy'] = 'smart_herdr'
  end,
}
