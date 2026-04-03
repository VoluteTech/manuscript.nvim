local ui = require("manuscript.ui")
local storage = require("manuscript.storage")

---@class ManuscriptApp
---@field float ManuscriptFloat
---@field store ManuscriptStore
local ManuscriptApp = {}
ManuscriptApp.__index = ManuscriptApp

---@class ManuscriptAppConfig
---@field vault string

---@param vault_path string
---@return ManuscriptApp
function ManuscriptApp.new(vault_path)
  local self = setmetatable({}, ManuscriptApp)

  local vault = vault_path or "~/personal/vault"

  self.float = ui.new()
  self.store = storage.new(vault)

  return self
end

---Singleton instance
local _instance = nil

---Get or create the singleton instance
---@return ManuscriptApp
function ManuscriptApp.get()
  if not _instance then
    _instance = ManuscriptApp.new()
  end
  return _instance
end

---@param opts ManuscriptAppConfig|nil
function ManuscriptApp.setup(opts)
  opts = opts or {}
  local vault = opts.vault or opts.vault_path or "~/personal/vault"
  local app = ManuscriptApp.new(vault)
  _instance = app
  app:setup()
end

function ManuscriptApp:toggle()
  if self.float:is_open() then
    self.float:close()
  else
    self:open()
  end
end

function ManuscriptApp:open()
  local content = self.store:load()
  self.float:open(content)
  self:setup_autocmd()
  self:setup_bufhidden()
end

function ManuscriptApp:setup_bufhidden()
  vim.api.nvim_create_autocmd("BufHidden", {
    buffer = self.float.buf_id,
    once = true,
    callback = function()
      vim.api.nvim_buf_set_option(self.float.buf_id, 'modified', false)
    end
  })
end

function ManuscriptApp:close()
  self.float:close()
end

function ManuscriptApp:clear_draft()
  local ok, info = self.store:delete()

  if ok then
    vim.notify("Draft deleted: " .. info, vim.log.levels.INFO)
  else
    vim.notify("Could not find draft to delete at: " .. info, vim.log.levels.WARN)
  end

  self.float:clear_buffer()
end

---Get the buffer handle
---@return number
function ManuscriptApp:get_buffer()
  return self.float:get_buffer()
end

---Setup keymaps
function ManuscriptApp:setup(key)
  key = key or "<leader>m"

  vim.keymap.set("n", key, function()
    self:toggle()
  end, {})
end

function ManuscriptApp:setup_autocmd()
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    group = vim.api.nvim_create_augroup("manuscript-save", {}),
    buffer = self.float.buf_id,
    callback = function()
      self.store:save(self.float.buf_id)
    end
  })
end

return ManuscriptApp
