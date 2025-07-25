--- share context with opencode
---@type LazySpec
return {
  'cousine/opencode-context.nvim',
  opts = {
    tmux_target = nil, -- Manual override: "session:window.pane"
    auto_detect_pane = true, -- Auto-detect opencode pane in current window
  },
  keys = require('core.mappings').opencode_mappings,
  cmd = { 'OpencodeSend', 'OpencodeSwitchMode' },
}
