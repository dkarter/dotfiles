-- put event listeners here

--- Create augroup
---@param name string
local augroup = function(name)
  vim.api.nvim_create_augroup(name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

-- automatic spell check for some file types
local spell_group = augroup 'SetSpell'
autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md', '*.tex' },
  command = 'setlocal spell',
  group = spell_group,
})

local firenvim_group = augroup 'Firenvim'
autocmd('BufEnter', {
  pattern = 'github.com_*.txt',
  command = 'set filetype=markdown',
  group = firenvim_group,
})

-- share data between nvim instances (registers etc)
local shada_group = augroup 'Shada'
autocmd({ 'CursorHold', 'TextYankPost', 'FocusGained', 'FocusLost' }, {
  pattern = '*',
  command = "if exists(':rshada') | rshada | wshada | endif",
  group = shada_group,
})
