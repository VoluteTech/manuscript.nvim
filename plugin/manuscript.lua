vim.keymap.set("n", "<leader>m", function()
  require("manuscript").toggle()
end, { desc = "Toggle manuscript window" })
