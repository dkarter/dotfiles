-- pulls info on hex packages (dependencies mattn/webapi-vim)
---@type LazySpec
return {
  'lucidstack/hex.vim',
  ft = { 'elixir' },
  dependencies = { 'mattn/webapi-vim' },
}
