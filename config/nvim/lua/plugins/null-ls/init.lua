local null_ls_present, null_ls = pcall(require, 'null-ls')

if not null_ls_present then
  vim.notify 'Failed to set up null-ls'
  return
end

local M = {}

M.setup = function()
  local b = null_ls.builtins

  null_ls.setup {
    sources = {
      ----------------------
      --   Code Actions   --
      ----------------------
      b.code_actions.gomodifytags,
      -- Injects code actions for Git operations at the current cursor position (stage / preview / reset hunks, blame, etc.).
      b.code_actions.gitsigns,

      ----------------------
      --    Diagnostics   --
      ----------------------
      b.diagnostics.actionlint,
      b.diagnostics.ansiblelint,
      b.diagnostics.codespell.with {
        disabled_filetypes = { 'NvimTree' },
      },

      b.diagnostics.rubocop,
      b.diagnostics.yamllint,
      b.diagnostics.zsh,
      require 'plugins.null-ls.commitlint',
    },
  }
end

return M
