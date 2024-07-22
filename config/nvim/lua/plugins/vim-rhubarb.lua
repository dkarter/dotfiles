-- github support for fugitive
return {
  'tpope/vim-rhubarb',
  event = 'VeryLazy',
  dependencies = { 'tpope/vim-fugitive' },
  keys = require('core.mappings').rhubarb_mappings,
}
