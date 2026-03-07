return {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	settings = {
		clangd = {
			inlayHints = {
				enabled = true,
				parameterNames = true,
				deducedTypes = true,
			},
		},
	},
	on_attach = function(client, bufnr)
		client.server_capabilities.semanticTokensProvider = {
			full = vim.empty_dict(),
			legend = {
				tokenTypes = {
					"comment", "keyword", "string", "number", "regexp", "type", "class", "function",
					"variable", "parameter", "property", "label", "operator", "punctuation", "decorator",
				},
				tokenModifiers = {
					"declaration", "definition", "readonly", "static", "deprecated", "abstract", "async",
					"modification", "documentation", "defaultLibrary",
				},
			},
		}

		local base_on_attach = require("config.lsp.init").on_attach
		base_on_attach(client, bufnr)

		local function get_alternate_file()
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local ext = vim.fn.fnamemodify(bufname, ":e")
			local base = vim.fn.fnamemodify(bufname, ":r")
			local dir = vim.fn.fnamemodify(bufname, ":p:h")

			if ext == "h" or ext == "hpp" then
				local cpp_file = dir .. "/" .. vim.fn.fnamemodify(bufname, ":t:r") .. ".cpp"
				local c_file = dir .. "/" .. vim.fn.fnamemodify(bufname, ":t:r") .. ".c"
				if vim.fn.filereadable(cpp_file) == 1 then
					return cpp_file
				elseif vim.fn.filereadable(c_file) == 1 then
					return c_file
				end
			elseif ext == "cpp" or ext == "c" then
				local h_file = dir .. "/" .. vim.fn.fnamemodify(bufname, ":t:r") .. ".h"
				local hpp_file = dir .. "/" .. vim.fn.fnamemodify(bufname, ":t:r") .. ".hpp"
				if vim.fn.filereadable(h_file) == 1 then
					return h_file
				elseif vim.fn.filereadable(hpp_file) == 1 then
					return hpp_file
				end
			end
			return nil
		end

		vim.keymap.set("n", "<leader>ch", function()
			local client_obj = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
			if client_obj then
				client_obj:request("textDocument/switchSourceHeader", { uri = vim.uri_from_bufnr(bufnr) }, function(err, result)
					if err or not result then
						local alternate = get_alternate_file()
						if alternate then
							vim.api.nvim_command("edit " .. alternate)
						else
							vim.notify("Corresponding file not found", vim.log.levels.WARN)
						end
						return
					end
					vim.api.nvim_command("edit " .. vim.uri_to_fname(result))
				end, bufnr)
			end
		end, { buffer = bufnr, desc = "Switch Source/Header" })

		vim.keymap.set("n", "<leader>ci", function()
			local params = vim.lsp.util.make_position_params()
			client:request("textDocument/codeAction", params, function(err, actions)
				if err or not actions then return end

				local implement_actions = {}
				for _, action in ipairs(actions) do
					if action.title:match("implement") or action.title:match("definition") then
						table.insert(implement_actions, action)
					end
				end

				if #implement_actions == 0 then
					vim.notify("No implementations available", vim.log.levels.INFO)
					return
				end

				vim.ui.select(implement_actions, { prompt = "Select action:" }, function(choice)
					if choice and choice.edit then
						vim.lsp.util.apply_workspace_edit(choice.edit)
					elseif choice and choice.command then
						client:execute_command(choice.command, {})
					end
				end)
			end, bufnr)
		end, { buffer = bufnr, desc = "Implement Functions" })

		vim.keymap.set("n", "<leader>co", function()
			local params = vim.lsp.util.make_position_params()
			client:request("textDocument/codeAction", params, function(err, actions)
				if err or not actions then return end

				local include_actions = {}
				for _, action in ipairs(actions) do
					if action.title:match("[Aa]dd include") or action.title:match("[Oo]rganize") then
						table.insert(include_actions, action)
					end
				end

				if #include_actions == 0 then
					vim.notify("No include actions available", vim.log.levels.INFO)
					return
				end

				vim.ui.select(include_actions, { prompt = "Select action:" }, function(choice)
					if choice and choice.edit then
						vim.lsp.util.apply_workspace_edit(choice.edit)
					elseif choice and choice.command then
						client:execute_command(choice.command, {})
					end
				end)
			end, bufnr)
		end, { buffer = bufnr, desc = "Add/Organize Includes" })

		vim.keymap.set("n", "gi", function()
			local params = vim.lsp.util.make_position_params()
			client:request("textDocument/implementation", params, function(err, result)
				if err then
					vim.notify("Implementation not found", vim.log.levels.WARN)
					return
				end
				if result and #result > 0 then
					vim.lsp.util.locations_to_items(result)
					require("telescope.builtin").lsp_implementations()
				else
					vim.notify("No implementations found", vim.log.levels.INFO)
				end
			end, bufnr)
		end, { buffer = bufnr, desc = "Go to Implementation" })
	end,
}
