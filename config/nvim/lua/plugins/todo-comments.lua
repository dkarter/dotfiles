-- highlight and search todo/fixme/hack etc comments
---@type LazySpec
return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  dependencies = 'nvim-lua/plenary.nvim',
  opts = {},
  keys = require('core.mappings').todo_comments_mappings,
}
