local M = {}

M.get_current_directory = function()
  local curr_dir = vim.fn.getcwd(0, 0)
  local split_str = {}
  for str in string.gmatch(curr_dir, "[^/]+") do
    table.insert(split_str, str)
  end
  return split_str[#split_str]
end

return M
