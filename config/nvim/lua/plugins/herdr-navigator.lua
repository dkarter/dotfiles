local navigator = require 'core.herdr_navigator'
local keys = navigator.keymaps()
if navigator.in_native_herdr() then
  for _, key in ipairs(keys) do
    vim.keymap.set(key.mode, key[1], key[2], { desc = key.desc })
  end
end

---@type LazySpec
return {
  'willfish/herdr-navigator.nvim',
  cond = require('core.utils').in_herdr(),
  keys = keys,
}
