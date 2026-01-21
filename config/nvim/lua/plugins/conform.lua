return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },

			javascript = { "biome", "prettier" },
			typescript = { "biome", "prettier" },
			javascriptreact = { "biome", "prettier" },
			typescriptreact = { "biome", "prettier" },
			json = { "biome", "prettier" },

			html = { "prettier" },
			css = { "prettier" },
			yaml = { "prettier" },
		},
		default_format_opts = {
			lsp_format = "never",
		},

		format_on_save = {
			timeout_ms = 500,
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
