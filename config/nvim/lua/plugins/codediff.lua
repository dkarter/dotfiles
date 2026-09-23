-- Live code review workspace for Git changes
---@type LazySpec
return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  keys = require('core.mappings').codediff_mappings,
}
