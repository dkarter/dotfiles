-- Toggle between different language verbs or syntax styles
---@type LazySpec
return {
  'AndrewRadev/switch.vim',
  event = { 'BufReadPost', 'BufNewFile' },
  init = function()
    vim.g.switch_custom_definitions = {
      { 'up', 'down', 'change' },
      { 'add', 'drop', 'remove' },
      { 'create', 'drop' },
      { 'row', 'column' },
      { 'first', 'second', 'third', 'fourth', 'fifth' },
      { 'yes', 'no' },
      { 'on', 'off' },
    }
  end,
}
