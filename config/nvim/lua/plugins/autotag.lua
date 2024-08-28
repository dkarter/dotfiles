-- auto close html/tsx tags using TreeSitter
---@type LazySpec
return {
  'windwp/nvim-ts-autotag',
  event = { 'InsertEnter' },
  ft = {
    'html',
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'svelte',
    'vue',
    'tsx',
    'jsx',
    'rescript',
    'xml',
    'php',
    'markdown',
    'astro',
    'glimmer',
    'handlebars',
    'hbs',
  },
  opts = {},
}
