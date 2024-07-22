local core_mappings = require 'core.mappings'

-- deletes all other buffers
return {
  'echasnovski/mini.bufremove',
  keys = core_mappings.bufremove_mappings,
}
