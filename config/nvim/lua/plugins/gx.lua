local M = {}

-- Opens URL in default browser. Works on macOS and Linux only.
--- @param url string
M.open_url = function(url)
  vim.fn['netrw#BrowseX'](url, 0)
end

M.package_json_gx = function()
  local line = vim.api.nvim_get_current_line()
  local package = string.match(line, '"(.-)": "(.-)"')

  if package ~= nil then
    local package_name = package
    local url = 'https://www.npmjs.com/package/' .. package_name
    M.open_url(url)
  end
end

return M
