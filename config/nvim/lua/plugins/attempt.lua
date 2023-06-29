local elixir_template = [[
defmodule Example do
  def run do
    IO.puts("Do stuff")
  end
end

Example.run()
]]

return {
  autosave = true,
  initial_content = {
    ex = elixir_template,
  },
  ext_options = { 'lua', 'js', 'ex', 'rb', 'sql', '' },
  format_opts = {
    [''] = '[None]',
    js = 'JavaScript',
    lua = 'Lua',
    rb = 'Ruby',
    ex = 'Elixir',
    sql = 'SQL',
  },
  run = {
    ex = { 'w', '!elixir %' },
    rb = { 'w', '!ruby %' },
  },
}
