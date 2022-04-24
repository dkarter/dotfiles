local g = vim.g
local keymap = vim.api.nvim_set_keymap

-- is this line necessary???
-- local action = require("nvim-tree.config").nvim_tree_callback

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

local default = {
  disable_netrw = false,
  hijack_netrw = false,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  auto_close = false,
  auto_reload_on_write = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = false,
  update_to_buf_dir = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    },
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = { '.DS_Store', 'fugitive:', '.git' },
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {},
    },
    number = false,
    relativenumber = false,
    signcolumn = 'yes',
  },
  trash = {
    cmd = 'trash',
    require_confirm = true,
  },
  actions = {
    change_dir = {
      global = false,
    },
    open_file = {
      quit_on_open = false,
    },
  },
  show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
  },
  icons = {
    default = '',
    symlink = '',
    git = {
      unstaged = '',
      staged = 'S',
      unmerged = '',
      renamed = '➜',
      deleted = '',
      untracked = 'U',
      ignored = '◌',
    },
    folder = {
      default = '',
      open = '',
      empty = '',
      empty_open = '',
      symlink = '',
    },
  },
}

local M = {}

M.setup = function()
  nvimtree.setup(default)
end

return M
