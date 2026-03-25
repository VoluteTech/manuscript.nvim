local ui = require("manuscript.ui")
local storage = require("manuscript.storage")
local utils = require("manuscript.utils")

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

M.clear_draft = function()
  local filename = utils.get_current_directory()

  local vault = vim.fn.expand(M.config.vault)
  local full_path = vault:gsub("/$", "") .. "/" .. filename .. "-draft.md"

  local result = vim.fn.delete(full_path)

  if result == 0 then
    vim.notify("Draft deleted: " .. filename, vim.log.levels.INFO)
  else
    vim.notify("Could not find draft to delete at: " .. full_path, vim.log.levels.WARN)
  end

  if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
    vim.api.nvim_buf_set_lines(M.state.floating.buf, 0, -1, false, {})
    ---@diagnostic disable-next-line: deprecated
    vim.api.nvim_buf_set_option(M.state.floating.buf, 'modified', false)
  end
end

M.toggle = function()
  if vim.api.nvim_win_is_valid(M.state.floating.win) then
    vim.api.nvim_win_hide(M.state.floating.win)
    return
  end

  if not vim.api.nvim_buf_is_valid(M.state.floating.buf) then
    local buf = ui.create_float_buffer()
    M.state.floating.buf = buf

    local content = storage.load_last_draft(M.config.vault)
    if content then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    end

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
