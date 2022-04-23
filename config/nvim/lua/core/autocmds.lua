-- put event listeners here
-- local generic_group = vim.api.nvim_create_augroup("GenericGroup", {})

-- -- Lua function
-- local myluafun = function()
--   print("entered buffer")
--   print(vim.bo.filetype)
-- end

-- -- When editing a file, always jump to the last known cursor position.
-- -- Don't do it for commit messages, when the position is invalid, or when
-- -- inside an event handler (happens when dropping a file on gvim).
-- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
--   pattern = { "*" },
--   callback = myluafun,
--   group = generic_group,
-- })
