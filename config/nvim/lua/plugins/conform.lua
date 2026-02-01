-- lua/plugins/conform.lua
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- The `opts` function is the modern way to configure lazy.nvim plugins.
	opts = function()
		local project = require("utils.project")

		return {
			-- A map of filetypes to the formatters to use.
			formatters_by_ft = {
				lua = { "stylua" },
				-- For python, we run ruff which can do both fixing and formatting.
				python = { "ruff_fix", "ruff_format" },
				go = { "goimports-reviser", "gofumpt" },
			},
			-- Define all our formatters here.
			formatters = {
				["goimports-reviser"] = {
					prepend_args = { "-rm-unused" },
				},
				ruff_format = {
					command = function(self, bufnr)
						return require("utils.project").get_executable(vim.api.nvim_buf_get_name(bufnr), "ruff")
					end,
					args = { "format", "--force-exclude", "--stdin-filename", "$FILENAME", "-" },
				},
				ruff_fix = {
					command = function(self, bufnr)
						return require("utils.project").get_executable(vim.api.nvim_buf_get_name(bufnr), "ruff")
					end,
					args = { "check", "--fix", "--force-exclude", "--exit-zero", "--no-cache", "--stdin-filename", "$FILENAME", "-" },
				},
			},
			-- Configuration for the format-on-save behavior.
			format_on_save = {
				timeout_ms = 2000,
				lsp_format = "fallback",
			},
		}
	end,
}
