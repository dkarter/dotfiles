return {
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
