local lspconfig = require 'lspconfig'

vim.lsp.config('denols', {
  lint = true,
  root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
})
