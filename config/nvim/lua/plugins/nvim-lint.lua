return {
	"mfussenegger/nvim-lint",
	dependencies = { "williamboman/mason.nvim" },
	event = "VeryLazy",
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			go = { "golangcilint" },
			python = { "ruff" },
		}

		-- Use project-specific ruff if available
		local ruff = lint.linters.ruff
		if ruff then
			ruff.cmd = function()
				return require("utils.project").get_executable(vim.api.nvim_buf_get_name(0), "ruff")
			end
		end

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
