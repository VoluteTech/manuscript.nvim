local utils = require("manuscript.utils")
local stub = require("luassert.stub")
local eq = assert.are.same

describe("utils", function()
  it("should return the last segment of the nested path", function()
    stub(vim.fn, "getcwd", "/home/bakabruh/personal/claw-code/")
    eq("claw-code", utils.get_current_directory())
  end)
end)
