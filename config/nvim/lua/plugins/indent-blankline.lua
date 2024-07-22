--  Indent lines (visual indication)
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    indent = {
      char = '│',
    },
    exclude = {
      filetypes = {
        '',
        'alpha',
        'NvimTree',
        'TelescopePrompt',
        'checkhealth',
        'dashboard',
        'help',
        'lazy',
        'lazyterm',
        'lspinfo',
        'man',
        'mason',
        'notify',
        'nofile',
        'qf',
        'quickfix',
        'terminal',
      },
    },
    scope = {
      enabled = false,
    },
  },
}
