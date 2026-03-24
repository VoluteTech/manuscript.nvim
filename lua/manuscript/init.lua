local M = {}

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local vault_path = vim.fn.expand("~/personal/vault")
if vim.fn.isdirectory(vault_path) then
  vim.fn.mkdir(vault_path, "p")
end

local function get_timestamp()
  return os.date("%Y-%m-%d-%H%M")
end

local function save_to_vault()
  local buf = state.floating.buf
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines == 0 or (lines[1] == "" and #lines == 1) then
    return
  end

  local filename = "manuscript-" .. get_timestamp() .. ".md"
  local filepath = vault_path .. "/" .. filename

  vim.fn.writefile(lines, filepath)
  vim.api.nvim_buf_set_option(buf, 'modified', false)
  vim.notify("Saved to " .. filename, vim.log.levels.INFO)
end

local function create_floating_window(opts)
  opts = opts or {}

  local buf = (opts.buf and vim.api.nvim_buf_is_valid(opts.buf))
      and opts.buf
      or vim.api.nvim_create_buf(false, false)

  if vim.api.nvim_buf_get_name(buf) == "" then
    vim.api.nvim_buf_set_name(buf, "manuscript-buffer")
  end

  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_option(buf, 'buftype', 'acwrite')

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

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    group = vim.api.nvim_create_augroup("save-file", {}),
    buffer = buf,
    callback = save_to_vault
  })

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
