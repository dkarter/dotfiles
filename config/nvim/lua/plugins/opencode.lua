--- integrate with opencode
---@type LazySpec
return {
  'NickvanDyke/opencode.nvim',
  ---@module 'opencode'
  ---@type opencode.Opts
  opts = {},
  config = function(_self, opts)
    -- idk why they do it this way - very weird
    vim.g.opencode_opts = opts
  end,

  dependencies = {
    -- tmux discovery and integration for opencode.nvim
    {
      'e-cal/opencode-tmux.nvim',
      opts = {
        options = '-h',
        focus = false,
        auto_close = false,
        allow_passthrough = false,
        find_sibling = true,
      },
    },
  },
  keys = require('core.mappings').opencode_mappings,
}
