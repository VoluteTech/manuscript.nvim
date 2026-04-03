---@class ManuscriptFloat
---@field buf_id number
---@field win_id number
local ManuscriptFloat = {}
ManuscriptFloat.__index = ManuscriptFloat

---@private
local function create_win_config()
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)

  return {
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
end

---@return ManuscriptFloat
function ManuscriptFloat.new()
  local self = setmetatable({}, ManuscriptFloat)
  self.buf_id = -1
  self.win_id = -1
  return self
end

---@return number, number
function ManuscriptFloat:toggle()
  if self:is_open() then
    self:close()
    return self.buf_id, self.win_id
  else
    self:open()
    return self.buf_id, self.win_id
  end
end

---@return boolean
function ManuscriptFloat:is_open()
  return vim.api.nvim_win_is_valid(self.win_id)
end

---@param content string[] | nil
function ManuscriptFloat:open(content)
  if self:is_open() then
    return
  end

  if not vim.api.nvim_buf_is_valid(self.buf_id) then
    self.buf_id = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(self.buf_id, "manuscript-buffer")
    vim.api.nvim_buf_set_option(self.buf_id, 'filetype', 'markdown')
    vim.api.nvim_buf_set_option(self.buf_id, 'buftype', 'acwrite')
    vim.api.nvim_buf_set_option(self.buf_id, 'modified', false)

    if content then
      vim.api.nvim_buf_set_lines(self.buf_id, 0, -1, false, content)
    end
  end

  local win_config = create_win_config()
  self.win_id = vim.api.nvim_open_win(self.buf_id, true, win_config)
  vim.wo[self.win_id].number = true
  vim.wo[self.win_id].relativenumber = true
end

function ManuscriptFloat:close()
  if vim.api.nvim_win_is_valid(self.win_id) then
    vim.api.nvim_win_hide(self.win_id)
  end
end

function ManuscriptFloat:clear_buffer()
  if vim.api.nvim_buf_is_valid(self.buf_id) then
    vim.api.nvim_buf_set_lines(self.buf_id, 0, -1, false, {})
    vim.api.nvim_buf_set_option(self.buf_id, 'modified', false)
  end
end

---@return number
function ManuscriptFloat:get_buffer()
  return self.buf_id
end

return ManuscriptFloat
