-- smarter gx mapping
---@type LazySpec
return {
  'chrishrb/gx.nvim',
  keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
  dependencies = { 'nvim-lua/plenary.nvim' },
  submodules = false,
  opts = {
    handler_options = {
      search_engine = 'https://kagi.com/search?q=',
    },
  },
}
