-- put event listeners here

--- Create augroup
---@param name string
augroup = function(name)
  vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd = vim.api.nvim_create_autocmd

-- automatic spell check for some file types
local spell_group = augroup 'SetSpell'
autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md', '*.tex' },
  command = 'setlocal spell',
  group = spell_group,
})

autocmd('FileType', {
  pattern = { 'gitcommit' },
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

-- Redefine FileTypes
local filetypes_group = augroup 'FileTypes AutoCmds'

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '.eslintrc', '.prettierrc', '.babelrc' },
  command = 'set filetype=json',
  group = filetypes_group,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.yrl',
  command = 'set filetype=erlang',
  group = filetypes_group,
})

-- When editing a file, always jump to the last known cursor position.
-- Don't do it for gitcommit messages
local auto_resume_group = augroup 'Auto Resume'
autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype

    if not (ft == 'gitcommit') then
      vim.fn.execute 'normal g`"'
    end
  end,
  group = auto_resume_group,
})

local general_improvements_group = augroup 'General Improvements'
-- Vim/tmux layout rebalancing
-- automatically rebalance windows on vim resize
autocmd('VimResized', {
  pattern = '*',
  command = 'wincmd =',
  group = general_improvements_group,
})

-- Automatically git commit text at 72 characters
autocmd('FileType', {
  pattern = 'gitcommit',
  command = 'setlocal textwidth=72',
  group = general_improvements_group,
})

-- notify if file changed outside of vim to avoid multiple versions
autocmd('FocusGained', {
  pattern = '*',
  command = 'checktime',
  group = general_improvements_group,
})

return {
  autocmd = autocmd,
  augroup = augroup,
}