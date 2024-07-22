local core_mappings = require 'core.mappings'

--  pretty diagnostics, references, telescope results, quickfix and location
--  list to help you solve all the trouble your code is causing.
return {
  'folke/trouble.nvim',
  cmd = { 'Trouble', 'TroubleToggle' },
  dependencies = 'nvim-tree/nvim-web-devicons',
  keys = core_mappings.trouble_mappings,
  opts = {},
}
