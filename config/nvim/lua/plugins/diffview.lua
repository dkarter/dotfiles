-- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  keys = require('core.mappings').diffview_mappings,
}
