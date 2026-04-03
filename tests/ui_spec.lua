local ManuscriptFloat = require("manuscript.ui")
local stub = require("luassert.stub")

describe("ManuscriptFloat", function()
  local float

  before_each(function()
    float = ManuscriptFloat.new()
  end)

  describe("new", function()
    it("creates a float with invalid buffer and window", function()
      assert.are.equal(-1, float.buf_id)
      assert.are.equal(-1, float.win_id)
    end)
  end)

  describe("get_buffer", function()
    it("returns the buffer id", function()
      float.buf_id = 42
      assert.are.equal(42, float:get_buffer())
    end)
  end)

  describe("is_open", function()
    local win_is_valid_stub

    before_each(function()
      win_is_valid_stub = stub(vim.api, "nvim_win_is_valid")
    end)

    after_each(function()
      win_is_valid_stub:revert()
    end)

    it("returns true when window is valid", function()
      win_is_valid_stub.returns(true)
      float.win_id = 1
      assert.is_true(float:is_open())
    end)

    it("returns false when window is invalid", function()
      win_is_valid_stub.returns(false)
      float.win_id = -1
      assert.is_false(float:is_open())
    end)
  end)

  describe("clear_buffer", function()
    local buf_is_valid_stub
    local buf_set_lines_stub
    local buf_set_option_stub

    before_each(function()
      buf_is_valid_stub = stub(vim.api, "nvim_buf_is_valid")
      buf_set_lines_stub = stub(vim.api, "nvim_buf_set_lines")
      buf_set_option_stub = stub(vim.api, "nvim_buf_set_option")
    end)

    after_each(function()
      buf_is_valid_stub:revert()
      buf_set_lines_stub:revert()
      buf_set_option_stub:revert()
    end)

    it("clears buffer and marks as unmodified when buffer is valid", function()
      buf_is_valid_stub.returns(true)
      float.buf_id = 42

      float:clear_buffer()

      assert.stub(buf_set_lines_stub).was_called_with(42, 0, -1, false, {})
      assert.stub(buf_set_option_stub).was_called_with(42, "modified", false)
    end)

    it("does nothing when buffer is invalid", function()
      buf_is_valid_stub.returns(false)
      float.buf_id = -1

      float:clear_buffer()

      assert.stub(buf_set_lines_stub).was_not_called()
    end)
  end)
end)
