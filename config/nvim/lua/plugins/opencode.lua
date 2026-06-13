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

    local state_ok, tmux_state = pcall(require, 'opencode-tmux.state')
    if state_ok and tmux_state.patched then
      local api_prompt = require 'opencode.api.prompt'
      if not api_prompt._dk_tmux_signature_compat then
        local original_prompt = api_prompt.prompt
        api_prompt.prompt = function(prompt_text, server_or_opts, context)
          if type(server_or_opts) == 'table' and server_or_opts.url then
            return original_prompt(prompt_text, {
              context = context,
              submit = not prompt_text:match ' $',
            })
          end

          return original_prompt(prompt_text, server_or_opts)
        end
        api_prompt._dk_tmux_signature_compat = true
      end
    end

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
