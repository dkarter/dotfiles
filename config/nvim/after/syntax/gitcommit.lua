-- Adjust commit title highlight max width to 72 chars (max gh allows in a title)
vim.cmd [[
syntax match   gitcommitSummary    "^.\{0,72\}" contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
]]
