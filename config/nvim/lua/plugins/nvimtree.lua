local present, nvimtree = pcall(require, 'nvim-tree')

if not present then
  return
end

local config = {
  renderer = {
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
      glyphs = {
        default = '',
        git = {
          unstaged = '',
          staged = '',
          unmerged = '',
          renamed = '',
          untracked = '',
          deleted = '',
        },
      },
    },
  },
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
