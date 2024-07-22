local core_mappings = require 'core.mappings'

-- highlight and search todo/fixme/hack etc comments
return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  dependencies = 'nvim-lua/plenary.nvim',
  opts = {},
  keys = core_mappings.todo_comments_mappings,
}
