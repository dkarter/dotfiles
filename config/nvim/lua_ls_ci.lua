local vim_runtime = os.getenv 'VIMRUNTIME'

return {
  Lua = {
    runtime = {
      version = 'LuaJIT',
    },
    diagnostics = {
      globals = { 'vim', 'Snacks' },
      disable = { 'undefined-doc-name', 'undefined-field' },
    },
    workspace = {
      library = { vim_runtime },
      checkThirdParty = false,
    },
  },
}
