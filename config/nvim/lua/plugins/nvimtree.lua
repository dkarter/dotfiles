local g = vim.g
local keymap = vim.api.nvim_set_keymap

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

keymap('n', '<leader>nt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

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
end

return M
