local utils = require 'core.utils'

local lspconfig_present, lspconfig = pcall(require, 'lspconfig')
local cmp_lsp_present, cmp_lsp = pcall(require, 'cmp_nvim_lsp')

local deps = {
  cmp_lsp_present,
  lspconfig_present,
}

if utils.contains(deps, false) then
  vim.notify 'Failed to load dependencies in plugins/lsp.lua'
  return
end

local M = {}

M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o> (not sure this is necessary with
  -- cmp plugin)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- /BEGIN: Helm file support
  if client.config.name == 'yamlls' and vim.bo.filetype == 'helm' then
    vim.lsp.stop_client(client.id)
    vim.lsp.buf_detach_client(bufnr, client.id)
  end

  if vim.bo[bufnr].buftype ~= '' or vim.bo.filetype == 'helm' then
    vim.diagnostic.disable(bufnr)
    vim.defer_fn(function()
      vim.diagnostic.reset(nil, bufnr)
    end, 1000)
  end
  -- /END: Helm file support

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  require('core.mappings').lsp_mappings()
end

-- Add completion and documentation capabilities for cmp completion
---@param opts table|nil
M.create_capabilities = function(opts)
  local default_opts = {
    with_snippet_support = true,
  }
  opts = opts or default_opts
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = opts.with_snippet_support
  if opts.with_snippet_support then
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      },
    }
  end

  return cmp_lsp.default_capabilities(capabilities)
end

M.setup_diagnostics = function()
  -- icons
  for name, icon in pairs(require('core.utils').icons.diagnostics) do
    name = 'DiagnosticSign' .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
  end

  local diagnostic_config = {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = 'if_many',
      prefix = '●',
      -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
      -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
      -- prefix = "icons",
    },
    severity_sort = true,
    float = {
      border = 'rounded',
    },
  }

  vim.diagnostic.config(diagnostic_config)
end

M.setup = function()
  -- set up global mappings for diagnostics
  require('core.mappings').lsp_diagnostic_mappings()

  M.setup_diagnostics()

  -- inject our custom on_attach after the built in on_attach from the lspconfig
  lspconfig.util.on_setup = lspconfig.util.add_hook_after(lspconfig.util.on_setup, function(config)
    if config.on_attach then
      config.on_attach = lspconfig.util.add_hook_after(config.on_attach, M.on_attach)
    else
      config.on_attach = M.on_attach
    end

    config.capabilities = M.create_capabilities()
  end)

  require('plugins.mason').setup()
end

return M
