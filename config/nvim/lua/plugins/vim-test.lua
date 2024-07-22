local core_mappings = require 'core.mappings'

-- run tests at the speed of thought
return {
  'janko-m/vim-test',
  keys = core_mappings.vim_test_mappings,
  dependencies = { 'benmills/vimux' },
  init = function()
    vim.g['test#strategy'] = 'vimux'
  end,
}
