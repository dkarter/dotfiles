local M = {}

-- Load project specific vimrc
function M.load_local_vimrc()
  local cwd = vim.fn.getcwd()
  local home_dir = vim.fn.expand "~"
  local local_vimrc = vim.fn.glob(cwd .. "/.vimrc")

  if cwd ~= home_dir and vim.fn.empty(local_vimrc) == 0 then
    print "------> loading local vimrc for project"
    vim.opt.exrc = true
    vim.cmd("source " .. local_vimrc)
  end
end

-- Reload all lua configuration modules
function M.reload_modules()
  local lua_dirs = vim.fn.glob("./lua/*", 0, 1)
  for _, dir in ipairs(lua_dirs) do
    dir = string.gsub(dir, "./lua/", "")
    require("plenary.reload").reload_module(dir)
  end
end

function M.imap(tbl)
  vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

function M.nmap(tbl)
  vim.keymap.set("n", tbl[1], tbl[2], tbl[3])
end

function M.xmap(tbl)
  vim.keymap.set("x", tbl[1], tbl[2], tbl[3])
end

function M.vmap(tbl)
  vim.keymap.set("v", tbl[1], tbl[2], tbl[3])
end

return M
