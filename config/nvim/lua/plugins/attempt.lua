local core_mappings = require 'core.mappings'

-- attempt stuff using scratch buffer and pre-configured bootstrap

local elixir_template = [[
defmodule Example do
  def run do
    IO.puts("Do stuff")
  end
end

Example.run()
]]

return {
  'm-demare/attempt.nvim',
  keys = core_mappings.attempt_mappings,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    autosave = true,
    initial_content = {
      ex = elixir_template,
    },
    ext_options = { 'lua', 'js', 'ex', 'rb', 'sql', 'sh', '' },
    format_opts = {
      [''] = '[None]',
      js = 'JavaScript',
      lua = 'Lua',
      rb = 'Ruby',
      ex = 'Elixir',
      sql = 'SQL',
      sh = 'Bash',
    },
    run = {
      ex = { 'w', '!elixir %' },
      rb = { 'w', '!ruby %' },
      sh = { 'w', '!bash %' },
    },
  },
  config = function(_, opts)
    require('attempt').setup(opts)
    require('telescope').load_extension 'attempt'
  end,
}
