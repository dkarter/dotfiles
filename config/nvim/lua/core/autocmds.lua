-- put event listeners here

-- spell check markdown and txt
vim.api.nvim_create_autocmd(
  { 'BufRead', 'BufNewFile' },
  { pattern = { '*.txt', '*.md', '*.tex' }, command = 'setlocal spell' }
)
