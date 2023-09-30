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
      b.code_actions.gomodifytags,

      ----------------------
      --    Diagnostics   --
      ----------------------
      b.diagnostics.actionlint,
      b.diagnostics.codespell,

      b.diagnostics.eslint_d,
      b.diagnostics.rubocop,
      b.diagnostics.shellcheck,
      b.diagnostics.yamllint,
      b.diagnostics.zsh,
      require 'plugins.null-ls.commitlint',

      ----------------------
      --    Formatters    --
      ----------------------
      b.formatting.clang_format,
      b.formatting.gofmt,
      b.formatting.goimports,

      -- Doesn't work for heex files
      b.formatting.mix.with {
        extra_filetypes = { 'eelixir', 'heex' },
        args = { 'format', '-' },
        extra_args = function(_params)
          local version_output = vim.fn.system 'elixir -v'
          local minor_version = vim.fn.matchlist(version_output, 'Elixir \\d.\\(\\d\\+\\)')[2]

          local extra_args = {}

          -- tells the formatter the filename for the code passed to it via stdin.
          -- This allows formatting heex files correctly. Only available for
          -- Elixir >= 1.14
          if tonumber(minor_version, 10) >= 14 then
            extra_args = { '--stdin-filename', '$FILENAME' }
          end

          return extra_args
        end,
      },
      b.formatting.pg_format,
      b.formatting.prettierd.with {
        extra_filetypes = { 'ruby' },
        disabled_filetypes = { 'markdown' },
      },
      b.formatting.prettier.with {
        filetypes = { 'markdown' },
      },
      b.formatting.shfmt,
      b.formatting.stylua,
      b.formatting.xq.with {
        extra_filetypes = { 'plist' },
      },
    },
    on_attach = function(client)
      if client.supports_method 'textDocument/formatting' then
        lsp_format.on_attach(client)
      end
    end,
  }
end

return M
