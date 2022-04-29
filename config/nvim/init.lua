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
-- source a vimscript file
vim.cmd 'source ~/.vimrc'

-- Local config (useful for customizing config on another machine which is not
-- transferable)
if vim.fn.filereadable(vim.fn.expand '~/.vimrc.local') == 1 then
  vim.cmd [[source ~/.vimrc.local]]
end

-- require `new_config.lua` from the nvim/lua folder:
require 'new_config'

-- Load project specific vimrc
require('utils').load_local_vimrc()
