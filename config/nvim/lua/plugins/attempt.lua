local present, attempt = pcall(require, 'attempt')

if not present then
  return
end

local M = {}

M.elixir_template = [[
defmodule Example do
  def run do
    IO.puts("Do stuff")
  end
end

Example.run()
]]

M.setup = function()
  attempt.setup {
    autosave = true,
    initial_content = {
      ex = M.elixir_template,
    },
    ext_options = { 'lua', 'js', 'ex', 'rb', '' },
    format_opts = { [''] = '[None]', js = 'JavaScript', lua = 'Lua', rb = 'Ruby', ex = 'Elixir' },
    run = {
      ex = { 'w', '!elixir %' },
      rb = { 'w', '!ruby %' },
    },
  }

  require('core.mappings').attempt_mappings(attempt)
end

return M
