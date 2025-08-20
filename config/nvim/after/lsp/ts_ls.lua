local lspconfig = require 'lspconfig'

vim.lsp.config('ts_ls', {
  root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', 'node_modules'),
  on_attach = function(client, bufnr)
    -- prevent conflict with Deno (ts_ls was showing false positives)
    if lspconfig.util.root_pattern('deno.json', 'deno.jsonc')(vim.fn.getcwd()) then
      vim.lsp.stop_client(client.id)
      vim.lsp.buf_detach_client(bufnr, client.id)
    end
  end,
})
