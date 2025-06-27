-- displays a popup with possible key bindings e.g. <leader>f will show f as
-- the next possible character
---@type LazySpec
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Keymaps (which-key)',
    },
  },

  ---@module "which-key"
  ---@class wk.Opts
  opts = {
    preset = 'helix',
    spec = {
      {
        mode = { 'n', 'v' },
        { '<leader>a', group = 'AI' },
        { '<leader>g', group = 'git' },
        { '<leader>f', group = 'find/file' },
        { '<leader>h', group = 'hunks', icon = '󰄷' },
        { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'gs', group = 'surround' },
        { 'z', group = 'fold' },
        { '<leader>b', group = 'buffer' },
        { '<leader>w', group = 'windows', proxy = '<c-w>' },
        -- better descriptions
        { 'gx', desc = 'Open with system app' },
      },
    },
    plugins = {
      spelling = { enabled = false },
    },
  },
}
