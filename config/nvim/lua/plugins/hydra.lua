local present, Hydra = pcall(require, 'hydra')

if not present then
  return
end

local cmd = require('hydra.keymap-util').cmd

local setup_telescope_hydra = function()
  local hint = [[
  ^^^^^ _f_: files       _b_: file browser     ^
  ^^^^^ _o_: old files   _g_: live grep        ^
  ^^^^^ _p_: packer      _/_: search in file   ^

  ^^^^^ _r_: resume                            ^
  ^^^^^ _h_: vim help    _c_: execute command  ^
  ^^^^^ _k_: keymaps     _;_: commands history ^
  ^^^^^ _O_: options     _?_: search history   ^
  ^
  ^^^^ _<Enter>_: Telescope    _<Esc>_: quit   ^
  ]]

  Hydra {
    name = 'Telescope',
    hint = hint,
    config = {
      color = 'teal',
      invoke_on_body = true,
      hint = {
        position = 'middle',
        border = 'rounded',
      },
    },
    mode = 'n',
    body = '<Leader>f',
    heads = {
      { '/', cmd 'Telescope current_buffer_fuzzy_find', { desc = 'search in file' } },
      { ';', cmd 'Telescope command_history', { desc = 'command-line history' } },
      { '?', cmd 'Telescope search_history', { desc = 'search history' } },
      { 'O', cmd 'Telescope vim_options' },
      { 'b', cmd 'Telescope file_browser' },
      { 'c', cmd 'Telescope commands', { desc = 'execute command' } },
      { 'f', cmd 'Telescope find_files' },
      { 'g', cmd 'Telescope live_grep' },
      { 'h', cmd 'Telescope help_tags', { desc = 'vim help' } },
      { 'k', cmd 'Telescope keymaps' },
      { 'o', cmd 'Telescope oldfiles', { desc = 'recently opened files' } },
      { 'p', cmd 'Telescope packer', { desc = 'packer plugins' } },
      { 'r', cmd 'Telescope resume' },
      { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
      { '<Esc>', nil, { exit = true, nowait = true } },
    },
  }
end

local setup_git_hydra = function()
  local hint = [[
  ^^^^^   _c_: Conflicts         _S_: Stage File         ^
  ^^^^^   _b_: Blame             _R_: Revert File        ^
  ^
  ^^^^^   _s_: Stage Hunk        _u_: Unstage Hunk       ^
  ^^^^^   _r_: Revert Hunk                               ^
  ^
  ^                       Github
  ^^^^^   _p_: Pull Requests          _i_: Github Issues      ^
  ^^^^^   _g_: List Gists             _a_: Github Actions     ^
  ^^^^^   _Y_: Yank File Link         _O_: Open in Github     ^
  ^^^^^   _y_: Yank Line Link         _O_: Open in Github     ^
  ^
  ^^^^ _<Enter>_: Fugitive Summary    _<Esc>_: quit      ^
  ]]

  Hydra {
    name = 'Git',
    hint = hint,
    config = {
      color = 'teal',
      invoke_on_body = true,
      hint = {
        position = 'middle',
        border = 'rounded',
      },
    },
    mode = 'n',
    body = '<Leader>g',
    heads = {
      { 'a', cmd 'Telescope gh run' },
      { 'b', cmd 'Git blame' },
      { 'c', cmd 'Gconflict' },
      { 'g', cmd 'Telescope gh gist' },
      { 's', cmd 'Gitsigns stage_hunk' },
      { 'u', cmd 'Gitsigns undo_stage_hunk' },
      { 'i', cmd 'Telescope gh issues' },
      { 'O', cmd 'GBrowse' },
      { 'p', cmd 'Telescope gh pull_request' },
      { 'r', cmd 'Gitsigns reset_hunk' },
      { 'R', cmd 'Gread' },
      { 'S', cmd 'Gwrite' },
      { 'Y', cmd 'GBrowse!' },
      { '<Enter>', cmd 'Git', { exit = true, desc = 'Fugitive Summary' } },
      { '<Esc>', nil, { exit = true, nowait = true } },
    },
  }
end

local M = {}

M.setup = function()
  setup_telescope_hydra()
  setup_git_hydra()
end

return M
