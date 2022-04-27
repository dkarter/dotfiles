local present, lspconfig = pcall(require, 'lspconfig')

if not present then
  return
end

local M = {}

M.setup = function()
  -- TODO: expose this as a function from mappings module e.g. require('core.mappings').diagnostic_mappigns()
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  require('core.mappings').lsp_diagnostic_mappings()

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o> (not sure this is necessary with
    -- vmp plugin)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('core.mappings').lsp_mappings(bufnr)
  end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local simple_servers = {
    -- sudo apt install clangd-12
    'clangd',

    -- https://rust-analyzer.github.io/manual.html#installation
    'rust_analyzer',

    -- yarn global add typescript typescript-language-server
    'tsserver',

    -- gem install solargraph
    'solargraph',

    -- yarn global add dockerfile-language-server-nodejs
    'dockerls',

    -- npm i -g @ansible/ansible-language-server
    'ansiblels',

    -- npm i -g vscode-langservers-extracted
    'jsonls',
    'cssls',
    'html',

    -- go install golang.org/x/tools/gopls@latest
    'gopls',
  }

  -- nvim-cmp supports additional completion capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  for _, lsp in pairs(simple_servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end

  -- Example custom server
  -- Make runtime files discoverable to the server
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }

  -- Elixir
  lspconfig.elixirls.setup {
    on_attach = function(client, bufnr)
      -- regular on_attach for lsp
      on_attach(client, bufnr)
      require('elixir').on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    cmd = { vim.loop.os_homedir() .. '/.elixir_ls/release/language_server.sh' },
  }
end

return M
