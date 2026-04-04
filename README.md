# Manuscript

A lightweight, floating notepad for Neovim designed for quick thoughts,
scratchpads, and Markdown drafting without breaking your flow.

## Features

- Centered Floating UI: A focused, aesthetic writing space that stays out of your way
- Save your note in your obsidian vault or wherever you want
- Delete your note draft with a simple keypress

## Installation

Using ***lazy.nvim***

```lua
{
    "VoluteTech/manuscript.nvim", version = "*",
    config = function()
        require("manuscript").setup({
            vault_path = "~/personal/vault", -- Pass your preferences here
            border = "rounded", -- The default border is a custom one
        })
    end,
}
```

## Usage

Try running `:ManuscriptToggle` to see if manuscript.nvim is correctly installed.

```lua
vim.keymap.set("n", "<leader>mo", ":ManuscriptToggle<CR>", { desc = "Toggle manuscript window" })
vim.keymap.set("n", "<leader>md", ":ManuscriptClear<CR>", { desc = "Clear the current draft" })
```

## Contribution

All contributions are welcome! Just open a pull request or suggest evolutions
and features. I will be happy to take them into account!
