-- generate annotations for documenting functions
-- supported languages: https://github.com/danymat/neogen#supported-languages
---@type LazySpec
return {
  'danymat/neogen',
  keys = require('core.mappings').neogen_mappings,
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      dependencies = {
        -- snippets!
        'rafamadriz/friendly-snippets',
      },

      build = 'make install_jsregexp',
    },
  },
  opts = { snippet_engine = 'luasnip' },
}
