-- a modern fugitive style git blame
return {
  'FabijanZulj/blame.nvim',
  keys = require('core.mappings').blame_nvim_mappings,
  cmd = { 'BlameToggle' },
  opts = {},
}
