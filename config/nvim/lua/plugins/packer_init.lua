vim.cmd 'packadd packer.nvim'

local present, packer = pcall(require, 'packer')

if not present then
  print 'Packer not found - installing...'
  local base_path = vim.fn.stdpath 'data'
  local packer_path = base_path .. '/site/pack/packer/opt/packer.nvim'

  print 'Cloning packer..'
  -- remove the dir before cloning
  vim.fn.delete(packer_path, 'rf')
  vim.fn.system {
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    '--depth',
    '20',
    packer_path,
  }

  vim.cmd 'packadd packer.nvim'
  present, packer = pcall(require, 'packer')

  if present then
    print 'Packer cloned successfully.'
  else
    error("Couldn't clone packer !\nPacker path: " .. packer_path .. '\n' .. packer)
  end
end

packer.init {
  git = {
    clone_timeout = 6000, -- seconds
  },
  auto_clean = true,
  compile_on_sync = true,
  max_jobs = 6,
}

return packer
