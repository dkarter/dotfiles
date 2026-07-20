-- run tests at the speed of thought
---@type LazySpec
return {
  'janko-m/vim-test',
  keys = require('core.mappings').vim_test_mappings,
  dependencies = { 'preservim/vimux' },
  init = function()
    local runner = require('core.utils').in_herdr() and require 'core.smart_herdr' or require 'core.smart_vimux'

    pcall(vim.api.nvim_create_user_command, 'SmartVimuxSmoke', function(opts)
      local cmd = opts.args ~= '' and opts.args or 'printf "smart-vimux smoke\n"'
      runner.run(cmd)
    end, { nargs = '*' })

    local custom_strategies = vim.g['test#custom_strategies'] or {}
    custom_strategies.smart_vimux = function(cmd)
      runner.run(cmd)
    end
    vim.g['test#custom_strategies'] = custom_strategies

    vim.g['test#strategy'] = 'smart_vimux'
  end,
}
