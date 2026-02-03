return {
	inlay_hints = false, -- Off by default for TS as requested
	settings = {
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = "all" },
				variableTypes = { enabled = "all" },
				propertyDeclarationTypes = { enabled = "all" },
				functionLikeReturnTypes = { enabled = "all" },
				enumMemberValues = { enabled = "all" },
			},
		},
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Disable formatting to let Biome handle it
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		-- Call base on_attach for general keymaps
		require("config.lsp.init").on_attach(client, bufnr)

		-- Vtsls specific keymaps
		local opts = { buffer = bufnr }
		vim.keymap.set("n", "gD", "<cmd>VtslsCommand goto_source_definition<cr>", { buffer = bufnr, desc = "Go to Source Definition" })
	end,
}
