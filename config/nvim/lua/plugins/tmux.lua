-- Tmux + nvim integration (seamless navigation etc)
---@type LazySpec
return {
  'aserowy/tmux.nvim',
  event = 'VeryLazy',
  opts = {
    copy_sync = {
      -- was clashing with WhichKey registers plugin
      enable = false,
    },
  },
}
