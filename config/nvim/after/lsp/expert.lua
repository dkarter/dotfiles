---@type vim.lsp.Config
return {
  settings = {
    workspaceSymbols = {
      minQueryLength = 2,
    },
    logLevel = 'info',
  },
  on_attach = function(client, bufnr)
    local add_user_cmd = vim.api.nvim_buf_create_user_command
    local pipes = require 'elixir.manipulate_pipes'
    local map_keys = require 'elixir.map_key_toggle'
    add_user_cmd(bufnr, 'ElixirFromPipe', pipes.from_pipe(client), {})
    add_user_cmd(bufnr, 'ElixirToPipe', pipes.to_pipe(client), {})
    add_user_cmd(bufnr, 'ElixirToggleMapKeys', function(opts)
      map_keys.toggle_elixir_map_keys { deep = opts.bang }
    end, { bang = true, desc = 'Toggle Elixir map keys (use ! for deep mode)' })

    require('core.mappings').elixir_mappings()
  end,
}
