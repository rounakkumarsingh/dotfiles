local M = {}

vim.g.lsp_auto_save_workspace_edits = vim.g.lsp_auto_save_workspace_edits or false
vim.g.lsp_prompt_on_rename = vim.g.lsp_prompt_on_rename or true

function M.get_filetype_group()
	local ft = vim.bo.filetype
	if ft == "c" or ft == "cpp" or ft == "objc" or ft == "objcpp" then
		return "c"
	elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
		return "ts"
	elseif ft == "python" then
		return "py"
	elseif ft == "go" then
		return "go"
	elseif ft == "json" or ft == "jsonc" then
		return "json"
	elseif ft == "css" or ft == "scss" or ft == "less" then
		return "css"
	end
	return "generic"
end

function M.on_attach(client, bufnr)
	local ft_group = M.get_filetype_group()

	local generic_keymaps = {
		{ "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
		{ "gr", vim.lsp.buf.references, desc = "Go to References" },
		{ "gi", vim.lsp.buf.implementation, desc = "Go to Implementation" },
		{ "gy", vim.lsp.buf.type_definition, desc = "Go to Type Definition" },
		{ "gs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document Symbols" },
		{ "gS", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "Workspace Symbols" },
		{ "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
		{ "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code Action", mode = { "n", "v" } },
		{ "<leader>cs", vim.lsp.buf.signature_help, desc = "Signature Help" },
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
		{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions/references/... (Trouble)" },
		{ "<leader>ti", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end, desc = "Toggle Inlay Hints" },
	}

	local function do_rename()
		if vim.g.lsp_prompt_on_rename then
			vim.ui.input({ prompt = "New name: " }, function(new_name)
				if new_name and new_name ~= "" then
					vim.lsp.buf.rename(new_name)
				end
			end)
		else
			vim.lsp.buf.rename()
		end
	end

	table.insert(generic_keymaps, { "<leader>cr", do_rename, desc = "Rename Symbol" })

	if ft_group == "ts" then
		table.insert(generic_keymaps, {
			"<leader>cf",
			function()
				vim.lsp.buf.code_action({
					context = { only = { "source.fixAll" } },
					apply = true,
				})
			end,
			desc = "Fix All (Biome/LSP)"
		})
	else
		table.insert(generic_keymaps, {
			"<leader>cf",
			function()
				vim.lsp.buf.code_action({
					context = { only = { "source.fixAll" } },
					apply = true,
				})
			end,
			desc = "Fix All"
		})
	end

	for _, map in ipairs(generic_keymaps) do
		local opts = { buffer = bufnr, desc = map.desc }
		local mode = map.mode or "n"
		vim.keymap.set(mode, map[1], map[2], opts)
	end

	local inlay_hints_enabled = true
	if client.config and client.config.inlay_hints == false then
		inlay_hints_enabled = false
	end

	if inlay_hints_enabled and client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

function M.get_capabilities()
	local capabilities = vim.tbl_deep_extend("force",
		vim.lsp.protocol.make_client_capabilities(),
		require("blink.cmp").get_lsp_capabilities()
	)
	return capabilities
end

function M.setup()
	vim.api.nvim_create_user_command("LspToggleAutoSave", function()
		vim.g.lsp_auto_save_workspace_edits = not vim.g.lsp_auto_save_workspace_edits
		vim.notify("LSP auto-save: " .. (vim.g.lsp_auto_save_workspace_edits and "enabled" or "disabled"))
	end, {})

	vim.api.nvim_create_user_command("LspToggleRenamePrompt", function()
		vim.g.lsp_prompt_on_rename = not vim.g.lsp_prompt_on_rename
		vim.notify("LSP rename prompt: " .. (vim.g.lsp_prompt_on_rename and "enabled" or "disabled"))
	end, {})

	if not _G.__lsp_workspace_edit_hooked then
		_G.__lsp_workspace_edit_hooked = true
		local original_apply_workspace_edit = vim.lsp.util.apply_workspace_edit
		vim.lsp.util.apply_workspace_edit = function(workspace_edit, offset_encoding)
			local res = original_apply_workspace_edit(workspace_edit, offset_encoding)

			if not vim.g.lsp_auto_save_workspace_edits then
				return res
			end

			vim.schedule(function()
				local modified_bufs = {}
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified and vim.bo[bufnr].buftype == "" then
						local buf_name = vim.api.nvim_buf_get_name(bufnr)
						if buf_name ~= "" then
							table.insert(modified_bufs, bufnr)
						end
					end
				end

				for _, bufnr in ipairs(modified_bufs) do
					if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified then
						pcall(vim.api.nvim_buf_call, bufnr, function()
							vim.cmd("silent! w")
						end)
					end
				end
			end)
			return res
		end
	end

	vim.diagnostic.config({
		virtual_text = {
			prefix = "●",
			source = "if_many",
		},
		float = {
			border = "rounded",
			source = "always",
		},
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	local servers_path = vim.fn.stdpath("config") .. "/lua/config/lsp/servers"
	local server_files = vim.fn.glob(servers_path .. "/*.lua", false, true)

	for _, file in ipairs(server_files) do
		local server_name = vim.fn.fnamemodify(file, ":t:r")
		local config = require("config.lsp.servers." .. server_name)

		local final_config = vim.tbl_deep_extend("force", {
			on_attach = M.on_attach,
			capabilities = M.get_capabilities(),
		}, config or {})

		vim.lsp.config(server_name, final_config)
		vim.lsp.enable(server_name)
	end
end

return M
