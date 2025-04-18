-- attempt stuff using scratch buffer and pre-configured bootstrap

local elixir_template = [[
defmodule Example do
  def run do
    IO.puts("Do stuff")
  end
end

Example.run()
]]

---@type LazySpec
return {
  'm-demare/attempt.nvim',
  keys = require('core.mappings').attempt_mappings,
  dependencies = {
    'nvim-lua/plenary.nvim',
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
}
