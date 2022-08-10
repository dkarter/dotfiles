local installer_present, installer = pcall(require, 'mason-tool-installer')

if not installer_present then
  vim.notify 'Failed to initialize Mason Tool Installer!'
  return
end

local M = {}

M.setup = function()
  installer.setup {

    -- a list of all tools you want to ensure are installed upon
    -- start; they should be the names Mason uses for each tool
    ensure_installed = {
      'actionlint',
      'eslint_d',
      'prettierd',
      'rubocop',
      'shellcheck',
      'shfmt',
      'stylua',
    },
  }
end

return M
