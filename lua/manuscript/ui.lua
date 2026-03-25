local M = {}

M.create_float_buffer = function()
  local buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_name(buf, "manuscript-buffer")
  ---@diagnostic disable-next-line: deprecated
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  ---@diagnostic disable-next-line: deprecated
  vim.api.nvim_buf_set_option(buf, 'buftype', 'acwrite')
  return buf
end

M.open_window = function(buf)
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = math.ceil((ui.width - width) / 2),
    row = math.ceil((ui.height - height) / 2.5),
    style = 'minimal',
    border = 'rounded',
    title = 'Manuscript',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)
  vim.wo[win].number = true
  vim.wo[win].relativenumber = true

  return win
end

return M
