local core_mappings = require 'core.mappings'

-- a modern fugitive style git blame
return {
  'FabijanZulj/blame.nvim',
  keys = core_mappings.blame_nvim_mappings,
  cmd = { 'BlameToggle' },
  opts = {},
}
