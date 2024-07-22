-- The ultimate undo history visualizer for VIM
return {
  'mbbill/undotree',
  cmd = { 'UndotreeToggle' },
  keys = require('core.mappings').undotree_mappings,
}
