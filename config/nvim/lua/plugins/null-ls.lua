local present, null_ls = pcall(require, 'null-ls')

if not present then
  return
end

local prettier_filetypes = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'css',
  'scss',
  'less',
  'html',
  'json',
  'jsonc',
  'yaml',
  'markdown',
  'graphql',
  'handlebars',
  'svelte',
  'ruby',
}

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

local format_on_save = function(client, bufnr)
  local supports_formatting = client.supports_method 'textDocument/formatting'

  if supports_formatting then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format {
          bufnr = bufnr,
          filter = function(clients)
            return vim.tbl_filter(function(clnt)
              return clnt.name == 'null-ls'
            end, clients)
          end,
        }
      end,
    })
  end
end

local M = {}

M.setup = function()
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local completion = null_ls.builtins.completion

  null_ls.setup {
    sources = {
      formatting.prettier.with {
        filetypes = prettier_filetypes,
        only_local = 'node_modules/.bin',
      },
      formatting.stylelint,
      formatting.isort,
      formatting.cmake_format,
      formatting.terraform_fmt,
      formatting.codespell,
      formatting.stylua,

      diagnostics.eslint,
      diagnostics.rubocop,

      completion.spell,
    },
    on_attach = function(client, bufnr)
      require('plugins.lsp').common_on_attach(client, bufnr)
      format_on_save(client, bufnr)
    end,
  }
end

return M
