return {
	inlay_hints = false,
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
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = "all" },
				variableTypes = { enabled = "all" },
				propertyDeclarationTypes = { enabled = "all" },
				functionLikeReturnTypes = { enabled = "all" },
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
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		local base_on_attach = require("config.lsp.init").on_attach
		base_on_attach(client, bufnr)

		local opts = { buffer = bufnr }
		vim.keymap.set("n", "gD", "<cmd>VtslsCommand goto_source_definition<cr>", { buffer = bufnr, desc = "Go to Source Definition" })

		vim.keymap.set("n", "<leader>co", function()
			vim.lsp.buf.execute_command({ command = "_typescript.organizeImports", arguments = { vim.api.nvim_buf_get_name(0) } })
		end, { buffer = bufnr, desc = "Organize Imports" })

		vim.keymap.set("n", "<leader>cI", function()
			vim.lsp.buf.execute_command({ command = "_typescript.addMissingImports", arguments = { vim.api.nvim_buf_get_name(0) } })
		end, { buffer = bufnr, desc = "Add Missing Imports" })

		-- Override the generic <leader>cr with TS-aware rename
		vim.keymap.set("n", "<leader>cr", function()
			if vim.g.lsp_prompt_on_rename then
				vim.ui.input({ prompt = "New name: " }, function(new_name)
					if new_name and new_name ~= "" then
						vim.lsp.buf.rename(new_name)
					end
				end)
			else
				vim.lsp.buf.rename()
			end
		end, { buffer = bufnr, desc = "Rename Symbol (vtsls)" })
	end,
}
