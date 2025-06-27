-- show trailing white spaces and automatically delete them on write
---@type LazySpec
return {
  'zakharykaplan/nvim-retrail',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
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
        'snacks_dashboard',
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
