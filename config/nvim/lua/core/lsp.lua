local utils = require 'core.utils'

local lspconfig_present, lspconfig = pcall(require, 'lspconfig')
local navic_present, navic = pcall(require, 'nvim-navic')

local deps = {
  lspconfig_present,
  navic_present,
}

if utils.contains(deps, false) then
  vim.notify 'Failed to load dependencies in plugins/lsp.lua'
  return
end

local M = {}

M.on_attach = function(client, bufnr)
  -- support for lsp based breadcrumbs
  if client.server_capabilities.documentSymbolProvider and not vim.startswith(client.name, 'otter-ls') then
    navic.attach(client, bufnr)
  end

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  require('core.mappings').lsp_mappings()
end

M.setup = function()
  -- set up global mappings for diagnostics
  require('core.mappings').lsp_diagnostic_mappings()

  -- inject our custom on_attach after the built in on_attach from the lspconfig
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp', {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      local existing_capabilities = client.config.capabilities or vim.lsp.protocol.make_client_capabilities()
      -- merge blink cmp capabilities
      client.config.capabilities = require('blink.cmp').get_lsp_capabilities(existing_capabilities)

      M.on_attach(client, args.buf)
    end,
  })
end

return M
