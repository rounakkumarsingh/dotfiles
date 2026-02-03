return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format", "ruff_fix" },
			go = { "goimports-reviser", "gofumpt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
		formatters = {
			["goimports-reviser"] = {
				prepend_args = { "-rm-unused", "-set-alias" },
			},
		},
	},
}
