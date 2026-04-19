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

    if vim.fn.exists ':OpencodeTmuxCompatToggle' == 0 then
      vim.api.nvim_create_user_command('OpencodeTmuxCompatToggle', function()
        local enabled = vim.g.opencode_tmux_compat_fix == true or vim.g.opencode_tmux_compat_fix == 1
        vim.g.opencode_tmux_compat_fix = not enabled
        vim.notify(
          'opencode tmux compat fix '
            .. (vim.g.opencode_tmux_compat_fix and 'enabled' or 'disabled')
            .. '; restart nvim to apply'
        )
      end, { desc = 'Toggle opencode tmux compat fix' })
    end

    -- opt-in toggle for local tmux compatibility patch
    -- enable with: :let g:opencode_tmux_compat_fix = 1
    if vim.g.opencode_tmux_compat_fix == true or vim.g.opencode_tmux_compat_fix == 1 then
      require('opencode_tmux_compat').apply()
    end
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
