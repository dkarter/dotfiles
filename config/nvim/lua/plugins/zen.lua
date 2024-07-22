-- ZEN MODE 🧘
return {
  'folke/zen-mode.nvim',
  cmd = { 'ZenMode' },
  dependencies = { 'folke/twilight.nvim' },
  keys = require('core.mappings').zen_mode_mappings,
  opts = {
    plugins = {
      -- disables git signs
      gitsigns = { enabled = true },
      -- disables the tmux statusline
      tmux = { enabled = true },
      twilight = { enabled = true },
      wezterm = {
        enabled = true,
        -- can be either an absolute font size or the number of incremental steps
        font = '+4', -- (10% increase per step)
      },
    },
    -- callback where you can add custom code when the Zen window opens
    on_open = function(_win)
      -- disable indentscope animation
      vim.g.miniindentscope_disable = true

      -- disable indentation markers
      require('ibl').update { enabled = false }

      -- disable colorcolumn
      vim.o.colorcolumn = ''
    end,
    -- callback where you can add custom code when the Zen window closes
    on_close = function()
      -- re-enable indentscope animation
      vim.g.miniindentscope_disable = false

      -- re-enable indentation markers
      require('ibl').update { enabled = true }

      -- re-enable color column
      vim.o.colorcolumn = '80'
    end,
  },
}
