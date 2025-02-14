-- automatic bulleted lists
---@type LazySpec
return {
  'dkarter/bullets.vim',
  event = { 'VeryLazy' },
  init = function()
    vim.g.bullets_enabled_file_types = {
      'markdown',
      'text',
      'gitcommit',
      'scratch',
    }
    vim.g.bullets_outline_levels = {}
    vim.g.bullets_nested_checkboxes = 0
    vim.g.bullets_enable_in_empty_buffers = 1
  end,
  -- for dev uncomment this
  -- dir = '~/dev/bullets.vim',
}
