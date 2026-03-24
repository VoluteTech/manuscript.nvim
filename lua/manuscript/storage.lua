local M = {}

M.save_file = function(buf, vault_path)
  local expanded_path = vim.fn.expand(vault_path)

  if vim.fn.isdirectory(expanded_path) == 0 then
    vim.fn.mkdir(expanded_path, "p")
  end

  local filename = "manuscript-" .. os.date("%Y-%m-%d-%H%M") .. ".md"
  local full_filepath = expanded_path .. "/" .. filename

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local ok, err = pcall(vim.fn.writefile, lines, full_filepath)

  if ok then
    vim.api.nvim_buf_set_option(buf, 'modified', false)
    vim.notify("Manuscript saved: " .. filename, vim.log.levels.INFO)
  else
    vim.notify("Failed to save: " .. tostring(err), vim.log.levels.ERROR)
  end
end

return M
