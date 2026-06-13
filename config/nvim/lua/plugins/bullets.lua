-- automatic bulleted lists
---@type LazySpec
return {
  'bullets-vim/bullets.nvim',
  ft = { 'markdown', 'text', 'gitcommit', 'scratch', '' },
  opts = {
    enabled_file_types = {
      'markdown',
      'text',
      'gitcommit',
      'scratch',
    },
    outline_levels = {},
    nested_checkboxes = false,
    enable_in_empty_buffers = true,
  },
  -- for dev uncomment this
  -- dir = '~/dev/bullets.nvim',
}
