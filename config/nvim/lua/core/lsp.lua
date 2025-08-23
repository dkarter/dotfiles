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
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  require('core.mappings').lsp_mappings()
end

-- Add completion and documentation capabilities for cmp completion
M.create_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- this is a fix for nvim 10 - it appears that cmp_nvim_lsp was overwriting
  -- the capabilities.textDocument which caused errors in json-lsp
  capabilities.textDocument.completion = {
    dynamicRegistration = false,
    completionItem = {
      snippetSupport = true,
      commitCharactersSupport = true,
      deprecatedSupport = true,
      preselectSupport = true,
      tagSupport = {
        valueSet = {
          1, -- Deprecated
        },
      },
      insertReplaceSupport = true,
      resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
          'sortText',
          'filterText',
          'insertText',
          'textEdit',
          'insertTextFormat',
          'insertTextMode',
        },
      },
      insertTextModeSupport = {
        valueSet = {
          1, -- asIs
          2, -- adjustIndentation
        },
      },
      labelDetailsSupport = true,
    },
    contextSupport = true,
    insertTextMode = 1,
    completionList = {
      itemDefaults = {
        'commitCharacters',
        'editRange',
        'insertTextFormat',
        'insertTextMode',
        'data',
      },
    },
  }

  return capabilities
end

M.setup = function()
  -- set up global mappings for diagnostics
  require('core.mappings').lsp_diagnostic_mappings()

  -- inject our custom on_attach after the built in on_attach from the lspconfig
  lspconfig.util.on_setup = lspconfig.util.add_hook_after(lspconfig.util.on_setup, function(config)
    if config.on_attach then
      config.on_attach = lspconfig.util.add_hook_after(config.on_attach, M.on_attach)
    else
      config.on_attach = M.on_attach
    end

    config.capabilities = M.create_capabilities()
  end)
end

return M
