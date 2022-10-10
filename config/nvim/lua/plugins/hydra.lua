local present, Hydra = pcall(require, 'hydra')

if not present then
  return
end

local cmd = require('hydra.keymap-util').cmd

local setup_telescope_hydra = function()
  local hint = [[
  ^^^^^ _f_: files            _b_: buffers           ^
  ^^^^^ _o_: old files        _w_: file bro[w]ser    ^

  ^^^^^ _/_: search in file   _g_: live [g]rep       ^
  ^^^^^ _?_: search history   _t_: tags              ^

  ^^^^^ _r_: resume           _l_: re[l]oader        ^
  ^^^^^ _h_: vim [h]elp       _:_: execute  command  ^
  ^^^^^ _k_: keymaps          _;_: commands history  ^
  ^^^^^ _O_: options          _p_: packer            ^
  ^
  ^^^^   _<Enter>_: Telescope     _<Esc>_: quit      ^
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
      { '/', cmd 'Telescope current_buffer_fuzzy_find' },
      { ';', cmd 'Telescope command_history' },
      { '?', cmd 'Telescope search_history' },
      { 'O', cmd 'Telescope vim_options' },
      { 'b', cmd 'Telescope buffers' },
      { ':', cmd 'Telescope commands' },
      { 'f', cmd 'Telescope find_files' },
      { 'g', cmd 'Telescope live_grep' },
      { 'h', cmd 'Telescope help_tags' },
      { 'k', cmd 'Telescope keymaps' },
      { 'l', cmd 'Telescope reloader' },
      { 'o', cmd 'Telescope oldfiles' },
      { 'p', cmd 'Telescope packer' },
      { 'r', cmd 'Telescope resume' },
      -- The `Telescope current_buffer_tags` command sucks currently, I might be
      -- able to submit a PR to improve it, but for now let's just use FZF's
      -- Buffer Tags (BTags) command
      { 't', cmd 'BTags' },
      { 'w', cmd 'Telescope file_browser' },
      { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
      { '<Esc>', nil, { exit = true, nowait = true } },
    },
  }
end

local setup_git_hydra = function()
  local hint = [[
  ^^^^^^^^ _c_: Conflicts         _S_: Stage File       ^
  ^^^^^^^^ _b_: Blame             _R_: Revert File      ^
  ^
  ^^^^^^^^ _s_: Stage Hunk        _u_: Unstage Hunk     ^
  ^^^^^^^^ _r_: Revert Hunk                             ^
  ^
  ^                   Github
  ^^^^^ _p_: Pull Requests          _i_: Github Issues  ^
  ^^^^^ _g_: List Gists             _a_: Github Actions ^
  ^^^^^ _Y_: Yank File Link         _O_: File in Github ^
  ^^^^^ _y_: Yank Line Link         _o_: Line in Github ^
  ^
  ^^^^^  _<Enter>_: Fugitive Summary    _<Esc>_: quit   ^
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
      { 'o', cmd '.GBrowse' },
      { 'O', cmd 'GBrowse' },
      { 'p', cmd 'Telescope gh pull_request' },
      { 'r', cmd 'Gitsigns reset_hunk' },
      { 'R', cmd 'Gread' },
      { 'S', cmd 'Gwrite' },
      { 'Y', cmd 'GBrowse!' },
      { 'y', cmd '.GBrowse!' },
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
