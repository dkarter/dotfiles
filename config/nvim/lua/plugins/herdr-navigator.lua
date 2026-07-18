local keys = {}

for _, navigation in ipairs {
  { name = 'left', key = '<C-h>', vim_direction = 'h' },
  { name = 'down', key = '<C-j>', vim_direction = 'j' },
  { name = 'up', key = '<C-k>', vim_direction = 'k' },
  { name = 'right', key = '<C-l>', vim_direction = 'l' },
} do
  local name = navigation.name
  local vim_direction = navigation.vim_direction
  keys[#keys + 1] = {
    navigation.key,
    function()
      require('herdr-navigator')[name]()
    end,
    mode = { 'n', 'x', 's' },
    desc = 'Navigate ' .. name,
  }
  keys[#keys + 1] = {
    navigation.key,
    function()
      require('herdr-navigator').navigate_terminal(vim_direction, name)
    end,
    mode = 't',
    desc = 'Navigate ' .. name,
  }
end

---@type LazySpec
return {
  'willfish/herdr-navigator.nvim',
  cond = require('core.utils').in_herdr(),
  keys = keys,
}
