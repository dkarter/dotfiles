---@type LazySpec
return {
  'dkarter/comment-threads.nvim',
  main = 'comment_threads',
  version = '*',
  lazy = false,
  keys = require('core.mappings').comment_threads_mappings,
  opts = {
    -- Agent Mono Nerd Font logos; other authors use the plugin's default dot.
    author_icons = {
      claude = '',
      codex = '',
      opencode = '',
      pi = '',
    },
  },
}
