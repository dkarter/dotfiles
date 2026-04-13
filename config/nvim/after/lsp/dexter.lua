---@type vim.lsp.Config
return {
  cmd = { 'dexter', 'lsp' },
  root_markers = { '.dexter.db', '.git', 'mix.exs' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
  init_options = {
    followDelegates = true, -- jump through defdelegate to the target function
    -- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
    -- debug = false,        -- verbose logging to stderr (view with :LspLog)
  },
}
