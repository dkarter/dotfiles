local M = {}

M.is_helm_file = function(path)
  local check = vim.fs.find('Chart.yaml', { path = vim.fs.dirname(path), upward = true })
  return not vim.tbl_isempty(check)
end

M.yaml_detect = function(path, _bufnr)
  if M.is_helm_file(path) then
    return 'helm'
  end

  -- return yaml if nothing else
  return 'yaml'
end

return M
