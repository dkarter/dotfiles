--- integrate with opencode
---@type LazySpec
return {
  'NickvanDyke/opencode.nvim',
  ---@module 'opencode'
  ---@type opencode.Opts
  opts = {
    provider = {
      enabled = 'tmux',
    },
  },
  config = function(_self, opts)
    -- idk why they do it this way - very weird
    vim.g.opencode_opts = opts
  end,
  keys = require('core.mappings').opencode_mappings,
}
