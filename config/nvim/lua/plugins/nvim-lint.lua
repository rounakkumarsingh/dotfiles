return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile", "BufWritePost" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			python = { "ruff" },
			go = { "golangcilint" },
			javascript = { "oxlint" },
			typescript = { "oxlint" },
			javascriptreact = { "oxlint" },
			typescriptreact = { "oxlint" },
			json = { "oxlint" },
			jsonc = { "oxlint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				local names = lint.linters_by_ft[vim.bo.filetype]
				if names and #names > 0 then
					lint.try_lint()
				end
			end,
		})
	end,
}
