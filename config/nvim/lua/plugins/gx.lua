-- smarter gx mapping
---@type LazySpec
return {
  'chrishrb/gx.nvim',
  -- recent changes broke the plugin - see https://github.com/chrishrb/gx.nvim/issues/97
  commit = 'c7e6a0ace694a098a5248d92a866c290bd2da1cc',
  keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
  dependencies = { 'nvim-lua/plenary.nvim' },
  submodules = false,
  opts = {
    handler_options = {
      search_engine = 'https://kagi.com/search?q=',
    },
  },
}
