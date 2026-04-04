local ui = require("manuscript.ui")
local storage = require("manuscript.storage")

---@class ManuscriptApp
---@field float ManuscriptFloat
---@field store ManuscriptStore
local ManuscriptApp = {}
ManuscriptApp.__index = ManuscriptApp

---@class ManuscriptAppConfig
---@field vault_path string
---@field border string|string[]

---@param opts ManuscriptAppConfig
---@return ManuscriptApp
function ManuscriptApp.new(opts)
  opts = opts or {}
  local self = setmetatable({}, ManuscriptApp)

  local vault = opts.vault_path or "~/personal/vault"
  local border = opts.border

  self.float = ui.new(border)
  self.store = storage.new(vault)
  self.opts = opts

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
  local app = ManuscriptApp.new(opts)
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

function ManuscriptApp:setup()
  vim.api.nvim_create_user_command("ManuscriptToggle", function()
    ManuscriptApp.get():toggle()
  end, {})

  vim.api.nvim_create_user_command("ManuscriptClear", function()
    ManuscriptApp.get():clear_draft()
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
