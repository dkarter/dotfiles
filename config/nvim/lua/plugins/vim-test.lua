-- run tests at the speed of thought
---@type LazySpec
return {
  'janko-m/vim-test',
  keys = require('core.mappings').vim_test_mappings,
  dependencies = { 'preservim/vimux' },
  init = function()
    local smart_vimux = require 'core.smart_vimux'

    pcall(vim.api.nvim_create_user_command, 'SmartVimuxSmoke', function(opts)
      local cmd = opts.args ~= '' and opts.args or 'printf "smart-vimux smoke\n"'
      smart_vimux.run(cmd)
    end, { nargs = '*' })

    local custom_strategies = vim.g['test#custom_strategies'] or {}
    custom_strategies.smart_vimux = function(cmd)
      smart_vimux.run(cmd)
    end
    vim.g['test#custom_strategies'] = custom_strategies

    vim.g['test#strategy'] = 'smart_vimux'
  end,
}
