local harpoon = require("harpoon")

-- REQUIRED for Harpoon v2 (sets up autocmds & state)
harpoon:setup({
	settings = {
		save_on_toggle = true,
		sync_on_ui_close = true,
		key = function()
			-- Per-project Harpoon list
			return vim.loop.cwd()
		end,
	},
})

-- === Primeagen keymaps ===

-- Add current file to Harpoon
vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Harpoon add file" })

-- Toggle Harpoon quick menu
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

-- Direct file jumps (Prime's muscle memory)
vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end, { desc = "Harpoon file 1" })

vim.keymap.set("n", "<C-t>", function()
	harpoon:list():select(2)
end, { desc = "Harpoon file 2" })

vim.keymap.set("n", "<C-n>", function()
	harpoon:list():select(3)
end, { desc = "Harpoon file 3" })

vim.keymap.set("n", "<C-s>", function()
	harpoon:list():select(4)
end, { desc = "Harpoon file 4" })

-- Navigate Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
	harpoon:list():prev()
end, { desc = "Harpoon previous" })

vim.keymap.set("n", "<C-S-N>", function()
	harpoon:list():next()
end, { desc = "Harpoon next" })
