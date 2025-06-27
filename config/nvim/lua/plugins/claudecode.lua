-- it's claude code, not claude code
---@type LazySpec
return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {},
  keys = require('core.mappings').claudecode_mappings,
}
