-- show trailing white spaces and automatically delete them on write
return {
  'zakharykaplan/nvim-retrail',
  event = { 'BufReadPost', 'BufNewFile' },
  opt = {
    -- Highlight group to use for trailing whitespace.
    hlgroup = 'IncSearch',
    -- Enabled filetypes.
    filetype = {
      -- Excluded filetype list. Overrides `include` list.
      exclude = {
        '',
        'TelescopePrompt',
        'Trouble',
        'WhichKey',
        'alpha',
        'checkhealth',
        'diff',
        'fugitive',
        'git',
        'gitcommit',
        'help',
        'lspinfo',
        'lspsagafinder',
        'lspsagaoutline',
        'man',
        'markdown',
        'mason',
        'null-ls-info',
        'qf',
        'unite',
      },
    },
  },
}
