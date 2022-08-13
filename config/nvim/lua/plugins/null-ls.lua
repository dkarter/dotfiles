local null_ls_present, null_ls = pcall(require, 'null-ls')
local lsp_format_present, lsp_format = pcall(require, 'lsp-format')

if not null_ls_present or not lsp_format_present then
  vim.notify 'Failed to set up null-ls and lsp-format'
  return
end

local M = {}

M.setup = function()
  local b = null_ls.builtins

  lsp_format.setup {}

  null_ls.setup {
    sources = {
      ----------------------
      --   Code Actions   --
      ----------------------
      b.code_actions.eslint_d,
      b.code_actions.refactoring,
      b.code_actions.shellcheck,

      ----------------------
      --   Completions    --
      ----------------------
      b.completion.spell,

      ----------------------
      --    Diagnostics   --
      ----------------------
      b.diagnostics.actionlint,
      b.diagnostics.codespell,
      b.diagnostics.credo.with {
        -- run credo in strict mode even if strict mode is not enabled in .credo.exs
        args = { 'credo', 'suggest', '--strict', '--format', 'json', '--read-from-stdin', '$FILENAME' },
      },
      b.diagnostics.eslint_d,
      b.diagnostics.rubocop,
      b.diagnostics.shellcheck,
      b.diagnostics.yamllint,

      ----------------------
      --    Formatters    --
      ----------------------
      b.formatting.mix,
      -- Doesn't work for heex files
      -- .with {
      --   extra_filetypes = { 'eelixir', 'heex' },
      --   -- we can't use stdin to format heex files due to how formatter
      --   -- plugins work (they rely on file extensions)
      --   -- see https://hexdocs.pm/mix/main/Mix.Tasks.Format.html#module-plugins
      --   -- It might be nicer to split this into a efm custom lsp just for
      --   -- formatting heex files (see example at
      --   -- https://github.com/lukas-reineke/lsp-format.nvim#how-do-i-use-format-options)
      --   -- or to keep things in null-ls, I could register a custom null-ls
      --   -- server such as in this example https://github.com/jose-elias-alvarez/null-ls.nvim#parsing-buffer-content
      --   args = { 'format', '$FILENAME' },
      -- },
      b.formatting.pg_format,
      b.formatting.prettierd,
      b.formatting.shfmt,
      b.formatting.stylua,
    },
    on_attach = function(client)
      if client.supports_method 'textDocument/formatting' then
        lsp_format.on_attach(client)
      end
    end,
  }
end

return M
