-- run tests at the speed of thought
---@type LazySpec
return {
  'janko-m/vim-test',
  keys = require('core.mappings').vim_test_mappings,
  init = function()
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
