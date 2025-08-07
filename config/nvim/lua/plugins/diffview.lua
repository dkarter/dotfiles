-- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
---@type LazySpec
return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  keys = require('core.mappings').diffview_mappings,
  opts = {
    hooks = {
      -- disable folding in diffview windows (they are annoying - if the the
      -- file is too large it should probably be split anyways)
      diff_buf_win_enter = function()
        vim.opt_local.foldenable = false
      end,
    },
  },
}
