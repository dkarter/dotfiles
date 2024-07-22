local core_mappings = require 'core.mappings'

-- The ultimate undo history visualizer for VIM
return {
  'mbbill/undotree',
  cmd = { 'UndotreeToggle' },
  keys = core_mappings.undotree_mappings,
}
