-- github support for fugitive
---@type LazySpec
return {
  'tpope/vim-rhubarb',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'tpope/vim-fugitive' },
  keys = require('core.mappings').rhubarb_mappings,
}
