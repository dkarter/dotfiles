---@type vim.lsp.Config
return {
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = false },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        yapf = { enabled = false },
      },
    },
  },
}
