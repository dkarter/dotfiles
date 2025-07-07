-- Improved git blame
---@type LazySpec
return {
  {
    'FabijanZulj/blame.nvim',
    keys = require('core.mappings').blame_mappings,
    opts = {},
  },
}
