-- Comment out code easily
---@type LazySpec
return {
  'numToStr/Comment.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'dkarter/nvim-treesitter',
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      opts = {},
    },
  },
  opts = function(_self, _opts)
    return {
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }
  end,
}
