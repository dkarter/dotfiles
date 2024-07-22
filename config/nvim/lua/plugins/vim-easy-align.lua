local core_mappings = require 'core.mappings'

-- same as tabular but by Junegunn and way easier
return {
  'junegunn/vim-easy-align',
  cmd = 'EasyAlign',
  keys = core_mappings.easy_align_mappings,
}
