local g = vim.g

g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1,
}

g.nvim_tree_icons = {
  default = '',
  git = {
    unstaged = '',
    staged = '',
    unmerged = '',
    renamed = '',
    untracked = '',
    deleted = '',
  },
}

local present, nvimtree = pcall(require, 'nvim-tree')

if not present then
  return
end

local config = {
  hijack_netrw = false,
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    },
  },
  filters = {
    dotfiles = false,
    custom = { '.DS_Store', 'fugitive:', '.git' },
    exclude = {},
  },
}

local M = {}

M.setup = function()
  nvimtree.setup(config)
  require('core.mappings').nvim_tree_mappings()
end

return M
