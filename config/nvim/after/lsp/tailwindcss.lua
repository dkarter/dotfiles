local lspconfig = require 'lspconfig'
local root_pattern = lspconfig.util.root_pattern

vim.lsp.config('tailwindcss', {
  root_dir = root_pattern(
    'assets/tailwind.config.js',
    'tailwind.config.js',
    'tailwind.config.ts',
    'postcss.config.js',
    'postcss.config.ts',
    'package.json',
    'node_modules'
  ),
  init_options = {
    userLanguages = {
      elixir = 'phoenix-heex',
      eruby = 'erb',
      heex = 'phoenix-heex',
      svelte = 'html',
    },
  },
  handlers = {
    ['tailwindcss/getConfiguration'] = function(_, _, params, _, bufnr, _)
      vim.lsp.buf_notify(bufnr, 'tailwindcss/getConfigurationResponse', { _id = params._id })
    end,
  },
  settings = {
    includeLanguages = {
      typescript = 'javascript',
      typescriptreact = 'javascript',
      ['html-eex'] = 'html',
      ['phoenix-heex'] = 'html',
      heex = 'html',
      eelixir = 'html',
      elm = 'html',
      erb = 'html',
      svelte = 'html',
    },
    tailwindCSS = {
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidConfigPath = 'error',
        invalidScreen = 'error',
        invalidTailwindDirective = 'error',
        invalidVariant = 'error',
        recommendedVariantOrder = 'warning',
      },
      experimental = {
        classRegex = {
          [[class= "([^"]*)]],
          [[class: "([^"]*)]],
          '~H""".*class="([^"]*)".*"""',
        },
      },
      validate = true,
    },
  },
  filetypes = {
    'css',
    'scss',
    'sass',
    'html',
    'heex',
    'elixir',
    'eruby',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'svelte',
  },
})
