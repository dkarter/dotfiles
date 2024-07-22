-- run tests at the speed of thought
return {
  'janko-m/vim-test',
  keys = require('core.mappings').vim_test_mappings,
  dependencies = { 'benmills/vimux' },
  init = function()
    vim.g['test#strategy'] = 'vimux'
  end,
}
