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

-- Speed up loading Lua modules in Neovim to improve startup time.
local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
end

-- iterative migration: source old config first, then overwrite it with new
-- configs
local config_path = vim.fn.stdpath 'config'
vim.cmd(string.format('source %s/migrate_me.vim', config_path))

-- Local config (useful for customizing config on another machine which is not
-- transferable)
if vim.fn.filereadable(vim.fn.expand '~/.vimrc.local') == 1 then
  vim.cmd [[source ~/.vimrc.local]]
end

-- require new configuration
local modules = {
  'core.options',
  'core.commands',
  'core.autocmds',
  'core.mappings',
  'plugins',
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error('Error loading ' .. module .. '\n\n' .. err)
  end
end

-- Load project specific vimrc
require('core.utils').load_local_vimrc()
