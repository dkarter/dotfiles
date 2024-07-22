--[[

 ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
 ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██
▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░
         ░    ░  ░    ░ ░        ░   ░         ░
                                ░

        - Dorian's NeoVim Configuration -
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enables the experimental Lua module loader:
-- • overrides loadfile
-- • adds the lua loader using the byte-compilation cache
-- • adds the libs loader
-- • removes the default Neovim loader
vim.loader.enable()

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

-- Local config (useful for customizing config on another machine which is not
-- transferable)
if vim.fn.filereadable(vim.fn.expand '~/.vimrc.local') == 1 then
  vim.cmd [[source ~/.vimrc.local]]
end

-- require new configuration
local modules = {
  'core.filetypes',
  'core.globals',
  'core.options',
  'core.commands',
  'core.autocmds',
  'core.mappings',
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error('Error loading ' .. module .. '\n\n' .. err)
  end
end

require('lazy').setup({
  { import = 'plugins' },
}, {
  concurrency = 8,
  -- Uncomment to debug an issue with a plugin by disabling all other plugins
  -- defaults = {
  --   cond = function(plugin)
  --     local _, plugin_name = next(plugin)
  --
  --     local enabledPlugins = { 'foo', 'bar', 'baz' }
  --     local found = false
  --
  --     for _, value in ipairs(enabledPlugins) do
  --       if value == plugin_name then
  --         return true
  --       end
  --     end
  --
  --     return false
  --   end,
  -- },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

-- Load project specific vimrc
require('core.utils').load_local_vimrc()
