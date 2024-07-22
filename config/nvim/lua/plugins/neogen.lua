local core_mappings = require 'core.mappings'

-- generate annotations for documenting functions
-- supported languages: https://github.com/danymat/neogen#supported-languages
return {
  'danymat/neogen',
  keys = core_mappings.neogen_mappings,
  opts = { snippet_engine = 'luasnip' },
}
