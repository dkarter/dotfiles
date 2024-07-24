-- automatic bulleted lists
return {
  'dkarter/bullets.vim',
  init = function()
    vim.g.bullets_enabled_file_types = {
      'markdown',
      'text',
      'gitcommit',
      'scratch',
    }
    vim.g.bullets_outline_levels = {}
  end,
  ft = {
    'markdown',
    'text',
    'gitcommit',
    'scratch',
  },
}
