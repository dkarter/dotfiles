-- installs/updates LSPs, linters and DAPs
---@type LazySpec
return {
  'mason-org/mason.nvim',
  -- temporarily lock to v1 to avoid dealing with breaking changes - after v2
  -- stabilizes this can be updated to 2.0.0 or removed
  build = ':MasonUpdate',
  cmd = { 'Mason', 'MasonUpdate', 'MasonUpdateAll' },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local mason = require 'mason'

    local package_list = require 'core.mason_packages'

    ---@type MasonSettings
    mason.setup {}

    if vim.env.DOTFILES_SKIP_MASON_AUTOINSTALL == '1' then
      return
    end

    -- Auto install all packages in the package_list
    local mr = require 'mason-registry'
    local function ensure_installed()
      for _, tool in ipairs(package_list) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end

    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}
