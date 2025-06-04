-- give AI agents access to MCP servers
---@type LazySpec
return {
  'ravitemer/mcphub.nvim',
  cmd = { 'MCPHub' },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- Installs `mcp-hub` node binary globally
  build = 'npm install -g mcp-hub@latest',
  opts = {},
}
