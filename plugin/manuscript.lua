vim.keymap.set("n", "<leader>mm", function()
  require("manuscript").toggle()
end, { desc = "Toggle manuscript window" })

vim.keymap.set("n", "<leader>md", function()
  require("manuscript").clear_draft()
end, { desc = "Delete current note draft" })
