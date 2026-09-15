local mason_ok, mason = pcall(require, 'mason')

if not mason_ok then
  vim.cmd 'qall'
  return
end

mason.setup {}

local registry = require 'mason-registry'
registry.refresh()

local packages = {}
for _, package_name in ipairs(require 'core.mason_packages') do
  local package = registry.get_package(package_name)
  if vim.startswith(package.spec.source.id, 'pkg:pypi/') then
    table.insert(packages, package_name)
  end
end

if #packages > 0 then
  vim.api.nvim_out_write('Reinstalling Mason Python packages: ' .. table.concat(packages, ', ') .. '\n')
  require('mason.api.command').MasonInstall(packages)
end

vim.cmd 'qall'
