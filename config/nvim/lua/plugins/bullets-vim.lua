-- automatic bulleted lists
---@type LazySpec
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
    vim.g.bullets_nested_checkboxes = 0
  end,
  ft = {
    'markdown',
    'text',
    'gitcommit',
    'scratch',
  },
}
