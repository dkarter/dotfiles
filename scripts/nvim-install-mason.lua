local mason_ok, mason = pcall(require, 'mason')

if not mason_ok then
  vim.notify('mason.nvim is not available; skipping Mason package install', vim.log.levels.WARN)
  vim.cmd 'qall'
  return
end

mason.setup {}

local packages = require 'core.mason_packages'
local registry = require 'mason-registry'
local failures = {}
local pending = 0
local refreshed = false

local function record_failure(package_name, err)
  table.insert(failures, string.format('%s: %s', package_name, err))
end

registry.refresh(function()
  refreshed = true

  for _, package_name in ipairs(packages) do
    local package_ok, package = pcall(registry.get_package, package_name)

    if not package_ok then
      record_failure(package_name, package)
    elseif not package:is_installed() then
      pending = pending + 1

      local install_ok, handle = pcall(function()
        return package:install()
      end)

      if not install_ok then
        pending = pending - 1
        record_failure(package_name, handle)
      else
        handle:once('closed', function()
          if not package:is_installed() then
            record_failure(package_name, 'install failed')
          end

          pending = pending - 1
        end)
      end
    end
  end
end)

local completed = vim.wait(900000, function()
  return refreshed and pending == 0
end, 1000)

if not completed then
  record_failure('mason', 'timed out waiting for package installs')
end

if #failures > 0 then
  vim.notify('Some Mason packages were not installed:\n' .. table.concat(failures, '\n'), vim.log.levels.ERROR)
  vim.cmd 'cquit'
  return
end

vim.cmd 'qall'
