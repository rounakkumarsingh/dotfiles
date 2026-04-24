vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable Neovim 0.11 default LSP mappings to avoid 'gr' collisions
-- and restore native motion speed.
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")

vim.keymap.set("n", "<leader>te", vim.cmd.Ex, { desc = "Toggle file explorer" })
-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- Paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Diagnostics
vim.keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

-- Show keymaps
vim.keymap.set("n", "<leader>?", "<cmd>WhichKey<CR>", { desc = "Show keymaps" })
