local ui = require("manuscript.ui")
local storage = require("manuscript.storage")

local M = {}

M.state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

M.setup = function(opts)
  M.config = vim.tbl_deep_extend("force", { vault = "~/personal/vault" }, opts or {})
end

M.toggle = function()
  if vim.api.nvim_win_is_valid(M.state.floating.win) then
    vim.api.nvim_win_hide(M.state.floating.win)
    return
  end

  if not vim.api.nvim_buf_is_valid(M.state.floating.buf) then
    local buf = ui.create_float_buffer()
    M.state.floating.buf = buf

    vim.api.nvim_create_autocmd("BufWriteCmd", {
      group = vim.api.nvim_create_augroup("save-file", {}),
      buffer = M.state.floating.buf,
      callback = function()
        storage.save_file(buf, M.config.vault)
      end
    })
  end

  M.state.floating.win = ui.open_window(M.state.floating.buf)
end

return M
