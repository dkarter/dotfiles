-- a distraction and chaos agent
---@type LazySpec
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  ---@module 'copilot'
  ---@type CopilotConfig
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = '<C-\\>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-[>',
      },
    },
  },
}
