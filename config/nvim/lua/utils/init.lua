local M = {}

-- Load project specific vimrc
function M.load_local_vimrc()
  local cwd = vim.fn.getcwd()
  local home_dir = vim.fn.expand("~")
  local local_vimrc = vim.fn.glob(cwd .. "/.vimrc")

  if cwd ~= home_dir and vim.fn.empty(local_vimrc) == 0 then
    print("------> loading local vimrc for project")
    vim.opt.exrc = true
    vim.cmd("source " .. local_vimrc)
  end
end

return M
