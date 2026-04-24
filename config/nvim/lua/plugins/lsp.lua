return {
	-- Mason for package management
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ensure_installed = {
				"basedpyright",
				"gopls",
				"ruff",
				"goimports-reviser",
				"gofumpt",
				"golangci-lint",
				"clangd",
				"clang-format",
				"vtsls",
				"tailwindcss-language-server",
				"json-lsp",
				"css-lsp",
			},
		},
	},

	-- Bridge between Mason and nvim-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "basedpyright", "gopls", "clangd", "vtsls", "tailwindcss", "jsonls", "cssls" },
			automatic_enable = true,
		},
	},

	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			"b0o/SchemaStore.nvim",
		},
		config = function()
			require("config.lsp.init").setup()
		end,
	},
}
