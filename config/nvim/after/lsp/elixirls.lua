---@type vim.lsp.Config
return {
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = false,
      enableTestLenses = false,
      suggestSpecs = true,
    },
  },
  on_attach = function(client, bufnr)
    local add_user_cmd = vim.api.nvim_buf_create_user_command
    local pipes = require 'elixir.manipulate_pipes'
    local map_keys = require 'elixir.map_key_toggle'
    add_user_cmd(bufnr, 'ElixirFromPipe', pipes.from_pipe(client), {})
    add_user_cmd(bufnr, 'ElixirToPipe', pipes.to_pipe(client), {})
    add_user_cmd(bufnr, 'ElixirToggleMapKeys', map_keys.toggle_elixir_map_keys, {})

    require('core.mappings').elixir_mappings()

    -- setup codelens
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh { bufnr = bufnr }
      end,
    })
    vim.lsp.codelens.refresh { bufnr = bufnr }
  end,
}
