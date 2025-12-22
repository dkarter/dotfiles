-- bracket shortcuts like unimpaired
---@type LazySpec
return {
  'nvim-mini/mini.bracketed',
  event = 'VeryLazy',
  version = '*',
  opts = {
    diagnostic = {
      float = true,
    },
  },
}
