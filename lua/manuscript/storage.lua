---@class ManuscriptStore
---@field vault_path string
local ManuscriptStore = {}
ManuscriptStore.__index = ManuscriptStore

---@private
local function get_current_directory()
  local curr_dir = vim.fn.getcwd(0, 0)
  local split_str = {}
  for str in string.gmatch(curr_dir, "[^/]+") do
    table.insert(split_str, str)
  end
  return split_str[#split_str]
end

---@private
local function get_draft_filename()
  return get_current_directory() .. "-draft.md"
end

---@param vault_path string
function ManuscriptStore.new(vault_path)
  local self = setmetatable({}, ManuscriptStore)
  self.vault_path = vault_path
  return self
end

---@return string
function ManuscriptStore:get_vault_path()
  return self.vault_path
end

---@return string
function ManuscriptStore:get_draft_filepath()
  local expanded = vim.fn.expand(self.vault_path)
  local filename = get_draft_filename()
  return expanded .. "/" .. filename
end

---@return string[]|nil
function ManuscriptStore:load()
  local full_path = self:get_draft_filepath()

  if vim.fn.filereadable(full_path) == 1 then
    return vim.fn.readfile(full_path)
  end
  return nil
end

---@param buf number
function ManuscriptStore:save(buf)
  local expanded = vim.fn.expand(self.vault_path)

  if vim.fn.isdirectory(expanded) == 0 then
    vim.fn.mkdir(expanded, "p")
  end

  local full_path = self:get_draft_filepath()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local ok, err = pcall(vim.fn.writefile, lines, full_path)

  if ok then
    vim.api.nvim_buf_set_option(buf, 'modified', false)
    vim.notify("Manuscript saved: " .. get_draft_filename(), vim.log.levels.INFO)
  else
    vim.notify("Failed to save: " .. tostring(err), vim.log.levels.ERROR)
  end
end

---@return boolean, string|nil
function ManuscriptStore:delete()
  local full_path = self:get_draft_filepath()
  local result = vim.fn.delete(full_path)

  if result == 0 then
    return true, get_current_directory()
  else
    return false, full_path
  end
end

return ManuscriptStore
