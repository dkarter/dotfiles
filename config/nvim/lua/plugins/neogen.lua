-- generate annotations for documenting functions
-- supported languages: https://github.com/danymat/neogen#supported-languages
return {
  'danymat/neogen',
  keys = require('core.mappings').neogen_mappings,
  opts = { snippet_engine = 'luasnip' },
}
