-- git integration
---@type LazySpec
return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  config = function()
    require('core.mappings').fugitive_mappings()
  end,
}
