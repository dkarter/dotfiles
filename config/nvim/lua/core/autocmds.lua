-- put event listeners here

-- automatic spell check for some file types
local spell_group = vim.api.nvim_create_augroup('SetSpell', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md', '*.tex' },
  command = 'setlocal spell',
  group = spell_group,
})
