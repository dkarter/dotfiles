-- splitting/joining blocks of code
---@type LazySpec
return {
  'Wansmer/treesj',
  keys = require('core.mappings').splitjoin_mappings,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    ---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
    use_default_keymaps = false,
    ---
    ---@type number If line after join will be longer than max value, node will not be formatted
    max_join_length = 240,
    ---
    ---@type table Presets for languages
    langs = {
      elixir = {
        arguments = {
          both = {
            separator = ',',
            last_separator = false,
          },
        },
        tuple = {
          both = {
            separator = ',',
            last_separator = false,
          },
        },
        keywords = {
          both = {
            separator = ',',
            last_separator = false,
            non_bracket_node = true,
            recursive = false,
          },
        },
        map_content = {
          both = {
            separator = ',',
            last_separator = false,
            non_bracket_node = true,
          },
        },
        list = {
          both = {
            separator = ',',
            last_separator = false,
          },
        },
      },
    },
  },
}
