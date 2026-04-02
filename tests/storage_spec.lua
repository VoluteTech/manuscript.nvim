local stub = require("luassert.stub")
local mock = require("luassert.mock")
local storage = require("manuscript.storage")
local utils = require("manuscript.utils")

describe("load_last_draft", function()
  -- Create stubs for the vim functions
  local expand_stub
  local readable_stub
  local readfile_stub
  local utils_stub

  before_each(function()
    expand_stub = stub(vim.fn, "expand")
    readable_stub = stub(vim.fn, "filereadable")
    readfile_stub = stub(vim.fn, "readfile")
    utils_stub = stub(utils, "get_current_directory")
  end)

  after_each(function()
    expand_stub:revert()
    readable_stub:revert()
    readfile_stub:revert()
    utils_stub:revert()
  end)

  it("returns file content when the draft exists", function()
    -- Arrange: Setup the "fake" environment
    expand_stub.returns("/abs/path/vault")
    utils_stub.returns("my-project")
    readable_stub.returns(1) -- 1 means 'true' in VimScript
    readfile_stub.returns({ "line 1", "line 2" })

    -- Act: Call your function
    local result = storage.load_last_draft("~/vault")

    -- Assert: Verify the logic
    assert.are.same({ "line 1", "line 2" }, result)
    assert.stub(readable_stub).was_called_with("/abs/path/vault/my-project-draft.md")
  end)

  it("returns nil when the draft does not exist", function()
    -- Arrange
    expand_stub.returns("/abs/path/vault")
    utils_stub.returns("empty-project")
    readable_stub.returns(0) -- File not found

    -- Act
    local result = storage.load_last_draft("~/vault")

    -- Assert
    assert.is_nil(result)
    assert.stub(readfile_stub).was_not_called()
  end)
end)
