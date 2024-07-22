return {

  -- syntax highlighting for zinit (zsh plugin manager)
  { 'zdharma-continuum/zinit-vim-syntax', ft = { 'zsh' } },

  -- support for MJML templates
  -- NOTE: technically ftdetection dictates that this shouldn't be VeryLazy, but
  -- the chances of me opening an mjml file as the first file are relatively
  -- low, so I think this is OK
  { 'amadeus/vim-mjml', event = 'VeryLazy' },

  -- automatically adjusts 'shiftwidth' and 'expandtab' heuristically
  'tpope/vim-sleuth',

  --- TMUX ---

  -- tmux config file stuff
  -- TODO: deprecate once the treesitter version is stable
  { 'tmux-plugins/vim-tmux', ft = 'tmux' },
}
