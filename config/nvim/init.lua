-- init.lua

-- iterative migration: source old config first, then overwrite it with new
-- configs
-- source a vimscript file
vim.cmd("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
vim.cmd("let &packpath = &runtimepath")
vim.cmd("source ~/.vimrc")

-- require `new_config.lua` from the nvim/lua folder:
require("new_config")
