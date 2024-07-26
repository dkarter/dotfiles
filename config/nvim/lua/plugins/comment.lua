-- Comment out code easily
---@type LazySpec
return {
  'numToStr/Comment.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local comment = require 'Comment'

    comment.setup {
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }
  end,
}
