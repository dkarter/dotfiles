-- a distraction and chaos agent
---@type LazySpec
return {
  'olimorris/codecompanion.nvim',
  cmd = {
    'CodeCompanion',
    'CodeCompanionCmd',
    'CodeCompanionChat',
    'CodeCompanionActions',
  },
  keys = require('core.mappings').codecompanion_mappings,
  opts = {
    strategies = {
      chat = {
        adapter = 'copilot',
      },
    },
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'dkarter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
  },
}
