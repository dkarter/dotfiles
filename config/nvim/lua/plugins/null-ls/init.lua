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
      b.code_actions.shellcheck,

      ----------------------
      --    Diagnostics   --
      ----------------------
      b.diagnostics.actionlint,
      b.diagnostics.codespell,

      b.diagnostics.credo.with {
        -- run credo in strict mode even if strict mode is not enabled in
        -- .credo.exs
        extra_args = { '--strict' },
        -- only register credo source if it is installed in the current project
        condition = function(_utils)
          local cmd = { 'rg', ':credo', 'mix.exs' }
          local credo_installed = ('' == vim.fn.system(cmd))
          return not credo_installed
        end,
      },
      b.diagnostics.eslint_d,
      b.diagnostics.rubocop,
      b.diagnostics.shellcheck,
      b.diagnostics.yamllint,
      b.diagnostics.zsh,
      require 'plugins.null-ls.commitlint',

      ----------------------
      --    Formatters    --
      ----------------------
      -- Doesn't work for heex files
      b.formatting.mix.with {
        extra_filetypes = { 'eelixir', 'heex' },
        -- tells the formatter the filename for the code passed to it via stdin.
        -- This allows formatting heex files correctly. Only available for
        -- Elixir >= 1.14
        --[[ extra_args = { '--stdin-filename', '$FILENAME' }, ]]
      },
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