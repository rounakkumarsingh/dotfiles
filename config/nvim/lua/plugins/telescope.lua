return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.0",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {
			desc = "Find files",
		})

		vim.keymap.set("n", "<C-p>", builtin.git_files, {
			desc = "Find git files",
		})

		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, {
			desc = "Grep search string",
		})
	end,
}
