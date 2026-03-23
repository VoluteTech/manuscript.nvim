# Manuscript

A lightweight, floating notepad for Neovim designed for quick thoughts, scratchpads, and Markdown drafting without breaking your flow.

---

## Features
- Centered Floating UI: A focused, aesthetic writing space that stays out of your way

## Installation

Using ***lazy.nvim***

```lua
{
    "VoluteTech/manuscript.nvim", version = "*",
    config = function()
        -- optional config
    end,
}
```

## Usage

```lua
local manuscript = require("manuscript")
vim.keymap.set("n", "<leader>m", manuscript.toggle_window, { desc = "Toggle manuscript window" })
```
