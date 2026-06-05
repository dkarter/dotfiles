-- Don't run the standalone rubocop LSP in Standard projects.
-- Mason's rubocop doesn't have the standard gem, so it fires cops that
-- Standard disables (e.g. Style/EmptyMethod vs Style/SingleLineMethods).
-- ruby-lsp detects .standard.yml and handles Standard diagnostics natively.
---@type vim.lsp.Config
return {
  -- nvim 0.11+ root_dir is async: receives (bufnr, on_dir) instead of fname
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local standard_config = vim.fs.find('.standard.yml', { path = fname, upward = true })[1]
    if standard_config then
      -- Returning without calling on_dir prevents rubocop LSP from starting.
      -- ruby-lsp detects .standard.yml and handles Standard diagnostics natively.
      return
    end
    on_dir(vim.fs.dirname(
      vim.fs.find({ '.rubocop.yml', 'Gemfile', '.git' }, { path = fname, upward = true })[1]
    ))
  end,
}
