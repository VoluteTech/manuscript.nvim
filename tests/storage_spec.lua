local ManuscriptStore = require("manuscript.storage")
local stub = require("luassert.stub")

describe("ManuscriptStore", function()
  local store

  before_each(function()
    store = ManuscriptStore.new("~/vault")
  end)

  describe("new", function()
    it("creates a store with the given vault path", function()
      assert.are.equal("~/vault", store:get_vault_path())
    end)
  end)

  describe("load", function()
    local expand_stub
    local readable_stub
    local readfile_stub
    local getcwd_stub

    before_each(function()
      expand_stub = stub(vim.fn, "expand")
      readable_stub = stub(vim.fn, "filereadable")
      readfile_stub = stub(vim.fn, "readfile")
      getcwd_stub = stub(vim.fn, "getcwd")
    end)

    after_each(function()
      expand_stub:revert()
      readable_stub:revert()
      readfile_stub:revert()
      getcwd_stub:revert()
    end)

    it("returns file content when draft exists", function()
      getcwd_stub.returns("/home/user/my-project")
      expand_stub.returns("/abs/vault")
      readable_stub.returns(1)
      readfile_stub.returns({ "line 1", "line 2" })

      local result = store:load()

      assert.are.same({ "line 1", "line 2" }, result)
    end)

    it("returns nil when draft does not exist", function()
      getcwd_stub.returns("/home/user/my-project")
      expand_stub.returns("/abs/vault")
      readable_stub.returns(0)

      local result = store:load()

      assert.is_nil(result)
      assert.stub(readfile_stub).was_not_called()
    end)
  end)

  describe("save", function()
    local expand_stub
    local isdirectory_stub
    local mkdir_stub
    local writefile_stub
    local getlines_stub
    local setoption_stub
    local notify_stub
    local getcwd_stub

    before_each(function()
      expand_stub = stub(vim.fn, "expand")
      isdirectory_stub = stub(vim.fn, "isdirectory")
      mkdir_stub = stub(vim.fn, "mkdir")
      writefile_stub = stub(vim.fn, "writefile")
      getlines_stub = stub(vim.api, "nvim_buf_get_lines")
      setoption_stub = stub(vim.api, "nvim_buf_set_option")
      notify_stub = stub(vim, "notify")
      getcwd_stub = stub(vim.fn, "getcwd")
    end)

    after_each(function()
      expand_stub:revert()
      isdirectory_stub:revert()
      mkdir_stub:revert()
      writefile_stub:revert()
      getlines_stub:revert()
      setoption_stub:revert()
      notify_stub:revert()
      getcwd_stub:revert()
    end)

    it("creates directory if missing and saves file", function()
      getcwd_stub.returns("/home/user/my-project")
      expand_stub.returns("/abs/vault")
      isdirectory_stub.returns(0)
      getlines_stub.returns({ "content" })

      store:save(42)

      assert.stub(mkdir_stub).was_called_with("/abs/vault", "p")
      assert.stub(writefile_stub).was_called_with({ "content" }, "/abs/vault/my-project-draft.md")
      assert.stub(setoption_stub).was_called_with(42, "modified", false)
    end)
  end)

  describe("delete", function()
    local expand_stub
    local delete_stub
    local getcwd_stub

    before_each(function()
      expand_stub = stub(vim.fn, "expand")
      delete_stub = stub(vim.fn, "delete")
      getcwd_stub = stub(vim.fn, "getcwd")
    end)

    after_each(function()
      expand_stub:revert()
      delete_stub:revert()
      getcwd_stub:revert()
    end)

    it("returns true and directory name on successful delete", function()
      getcwd_stub.returns("/home/user/my-project")
      expand_stub.returns("/abs/vault")
      delete_stub.returns(0)

      local ok, info = store:delete()

      assert.is_true(ok)
      assert.are.equal("my-project", info)
    end)

    it("returns false and filepath when file not found", function()
      getcwd_stub.returns("/home/user/my-project")
      expand_stub.returns("/abs/vault")
      delete_stub.returns(-1)

      local ok, info = store:delete()

      assert.is_false(ok)
    end)
  end)
end)
