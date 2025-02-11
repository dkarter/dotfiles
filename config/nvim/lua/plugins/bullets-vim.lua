-- automatic bulleted lists
---@type LazySpec
return {
  'dkarter/bullets.vim',
  -- temporarily disable until I can figure out the conflict with Snacks.picker
  -- and <CR> imap
  init = function()
    vim.g.bullets_enabled_file_types = {
      'markdown',
      'text',
      'gitcommit',
      'scratch',
    }
    vim.g.bullets_outline_levels = {}
    vim.g.bullets_nested_checkboxes = 0
    vim.g.bullets_enable_in_empty_buffers = 0
  end,
  ft = {
    'markdown',
    'text',
    'gitcommit',
    'scratch',
  },
}
