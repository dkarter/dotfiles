local core_mappings = require 'core.mappings'

-- github support for fugitive
return {
  'tpope/vim-rhubarb',
  event = 'VeryLazy',
  dependencies = { 'tpope/vim-fugitive' },
  keys = core_mappings.rhubarb_mappings,
}
