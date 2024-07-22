local core_mappings = require 'core.mappings'

-- git integration
return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  config = function()
    core_mappings.fugitive_mappings()
  end,
}
