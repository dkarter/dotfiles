-- it's claude code, not claude code
---@type LazySpec
return {
  'coder/claudecode.nvim',
  -- load on start (but delayed) to allow IDE integration from another tmux pane
  -- (/ide)
  event = 'VeryLazy',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    diff_opts = {
      open_in_current_tab = false, -- Open diffs in a new tab
      auto_close_on_accept = true, -- Automatically close diff after accepting
    },
  },
  keys = require('core.mappings').claudecode_mappings,
}
