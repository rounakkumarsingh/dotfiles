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

		local function rename_and_refactor(new_name)
			local params = vim.lsp.util.make_position_params()
			params.newName = new_name

			client:request("textDocument/rename", params, function(err, result)
				if err or not result or vim.tbl_isempty(result) then
					vim.notify("Rename not available or no changes needed", vim.log.levels.WARN)
					return
				end

				vim.lsp.util.apply_workspace_edit(result)

				vim.schedule(function()
					local changes = result.documentChanges or result.changes or {}
					if #changes > 0 then
						vim.cmd("DoCleanup")
					end
				end)
			end, bufnr)
		end

		vim.keymap.set("n", "<leader>cr", function()
			vim.ui.input({ prompt = "New name: " }, function(new_name)
				if new_name and new_name ~= "" then
					rename_and_refactor(new_name)
				end
			end)
		end, { buffer = bufnr, desc = "Rename Symbol (with refactor)" })
	end,
}
