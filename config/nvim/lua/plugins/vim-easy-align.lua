-- same as tabular but by Junegunn and way easier
---@type LazySpec
return {
  'junegunn/vim-easy-align',
  cmd = 'EasyAlign',
  keys = require('core.mappings').easy_align_mappings,
}
