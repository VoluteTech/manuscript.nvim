local M = {}

M.open_floating_window = function()
  local buf = vim.api.nvim_create_buf(false, true)

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(vim.o.columns * 0.8) -- 80% of screen width
  local height = math.floor(vim.o.lines * 0.8)  -- 80% of screen height

  local opts = {
    relative = 'editor',                       -- Position relative to the whole editor
    width = width,                             -- Width of the window
    height = height,                           -- Height of the window
    col = math.ceil((ui.width - width) / 2),   -- Column position (left to right)
    row = math.ceil((ui.height - height) / 2), -- Row position (top to bottom)
    style = 'minimal',                         -- Removes line numbers, sign columns, etc.
    border = 'rounded',                        -- Adds a pretty border (can be 'single', 'double', etc.)
  }

  vim.api.nvim_open_win(buf, true, opts)
end

M.close_floating_window = function()
  vim.api.nvim_win_close(0, true)
end

function M.setup(opts)
  opts = opts or {}

  vim.api.nvim_create_user_command("ManuscriptOpen", M.open_floating_window, {})
  vim.keymap.set("n", "<leader>mo", M.open_floating_window, {})
  vim.keymap.set("n", "<leader>mc", M.close_floating_window, {})
end

return M
