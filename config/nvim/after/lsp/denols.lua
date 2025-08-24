local lspconfig = require 'lspconfig'

---@type vim.lsp.Config
return {
  root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
  settings = {
    deno = {
      enable = true,
      lint = true,
    },
  },
}
