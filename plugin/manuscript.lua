local app = require("manuscript.init")

vim.keymap.set("n", "<leader>mo", function()
  app.get():toggle()
end, { desc = "Toggle manuscript window" })

vim.keymap.set("n", "<leader>md", function()
  app.get():clear_draft()
end, { desc = "Delete current note draft" })
