# Expert LSP quick recovery

If `:ElixirToPipe` and `:ElixirFromPipe` suddenly stop working, the usual cause is a broken Expert engine cache.

## How to spot this specific issue

Check your project log:

```bash
grep -nE "no module definition|Build script exited with status: 1|elixir_sense" .expert/expert.log
```

If you see lines like these, you are likely hitting the same cache problem:

- `src/elixir_sense_parser.erl:1:1: no module definition`
- `Build script exited with status: 1`

Optional extra check (the broken file is often zero bytes):

```bash
ls -l "$HOME/Library/Caches/expert/0.1.0/ex-1.19.5-erl-16.3"/*/deps/elixir_sense/src/elixir_sense_parser.erl
```

## Fix

Remove the Expert cache for your Elixir/Erlang combo and let Expert rebuild it:

```bash
rm -rf "$HOME/Library/Caches/expert/0.1.0/ex-1.19.5-erl-16.3"
```

Then restart Neovim in the project and wait for initial engine build to finish.

## Small test script to confirm refactors are back

Run this from your Elixir project root:

```bash
cat > /tmp/expert_pipe_check.lua <<'LUA'
local bufnr = vim.api.nvim_get_current_buf()
local function text()
  return table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\\n')
end

assert(vim.wait(30000, function()
  return #vim.lsp.get_clients { bufnr = bufnr, name = 'expert' } > 0
end, 100), 'expert did not attach')

local client = vim.lsp.get_clients { bufnr = bufnr, name = 'expert' }[1]
vim.api.nvim_win_set_cursor(0, { 4, 4 })

local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
params.context = { diagnostics = vim.diagnostic.get(bufnr) }
local actions = {}
assert(vim.wait(30000, function()
  local response = client:request_sync('textDocument/codeAction', params, 10000, bufnr)
  actions = (response and response.result) or {}
  return #actions > 0
end, 250), 'no code actions yet')

vim.cmd 'ElixirToPipe'
assert(vim.wait(5000, function()
  return text():find('|>', 1, true) ~= nil
end, 100), 'ElixirToPipe failed')

vim.cmd 'ElixirFromPipe'
assert(vim.wait(5000, function()
  return text():find('|>', 1, true) == nil
end, 100), 'ElixirFromPipe failed')

print('EXPERT_PIPE_OK')
LUA

cat > /tmp/expert_pipe_check.ex <<'EX'
defmodule ExpertPipeCheck do
  def run do
    value = "  hi  "
    String.trim(value)
  end
end
EX

nvim --headless \
  "+edit /tmp/expert_pipe_check.ex" \
  "+write" \
  "+lua dofile('/tmp/expert_pipe_check.lua')" \
  "+qa!"
```

Expected output:

```text
EXPERT_PIPE_OK
```
