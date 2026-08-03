-- Code walkthroughs in Neovim
---@type LazySpec
return {
  'kitlangton/navi.nvim',
  cmd = {
    'NaviClear',
    'NaviLoad',
    'NaviNext',
    'NaviPick',
    'NaviPrev',
  },
  keys = require('core.mappings').navi_mappings,
}
