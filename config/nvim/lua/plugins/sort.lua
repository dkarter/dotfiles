-- allow sorting code lines or within a line by delimiter
---@type LazySpec
return {
  'sQVe/sort.nvim',
  cmd = { 'Sort' },
  keys = require('core.mappings').sort_mappings,
  opts = {},
}
