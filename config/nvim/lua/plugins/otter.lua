-- LSP support for embedded languages
---@type LazySpec
return {
  'jmbuhr/otter.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  ft = { 'toml', 'yaml', 'markdown' },
  config = function()
    local group = vim.api.nvim_create_augroup('Otter', {})
    vim.api.nvim_create_autocmd({ 'FileType' }, {
      pattern = { 'toml', 'yaml', 'markdown' },
      group = group,
      callback = function()
        require('otter').activate()
      end,
    })
  end,
}
