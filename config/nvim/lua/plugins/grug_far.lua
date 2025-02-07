-- search/replace in multiple file
---@type LazySpec
return {
  'MagicDuck/grug-far.nvim',
  opts = { headerMaxWidth = 80 },
  cmd = 'GrugFar',
  keys = require('core.mappings').grug_far_mappings,
}
