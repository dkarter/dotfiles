-- init.lua

-- source a vimscript file
vim.cmd('source ~/.config/nvim/old_init.vim')

-- require `new_config.lua` from the nvim/lua folder:
require("new_config")
