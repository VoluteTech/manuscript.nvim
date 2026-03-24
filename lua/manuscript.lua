local M = {}

local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}

  local buf = nil

  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = math.ceil((ui.width - width) / 2),
    row = math.ceil((ui.height - height) / 2),
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)
  vim.wo[win].number = true
  vim.wo[win].relativenumber = true
  return { buf = buf, win = win }
end


M.toggle_window = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set("n", "<leader>m", M.toggle_window, {})

return M
