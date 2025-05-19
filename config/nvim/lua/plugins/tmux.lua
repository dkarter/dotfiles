-- Tmux + nvim integration (seamless navigation etc)
---@type LazySpec
return {
  'aserowy/tmux.nvim',
  event = 'VeryLazy',
  opts = {
    copy_sync = {
      -- was clashing with WhichKey registers plugin
      enable = false,
    },
  },
  config = function(_self, opts)
    require('tmux').setup(opts)
    -- this is a stupid fix so seamless tmux navigation works with Snacks
    -- explorer
    require('tmux.wrapper.nvim').is_nvim_float = function()
      if Snacks then
        local is_explorer = vim
          .iter(Snacks.picker.get { source = 'explorer' })
          :any(function(picker) ---@param picker snacks.Picker
            return picker:is_focused()
          end)
        if is_explorer then
          return false
        end
      end
      return vim.api.nvim_win_get_config(0).relative ~= ''
    end
  end,
}
