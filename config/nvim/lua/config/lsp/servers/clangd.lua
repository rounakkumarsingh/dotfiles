return {
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
		local base_on_attach = require("config.lsp.init").on_attach
		base_on_attach(client, bufnr)

		local function get_alternate_file()
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local ext = vim.fn.fnamemodify(bufname, ":e")
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
			vim.lsp.buf.code_action({
				context = {
					only = { "source" },
				},
			}, function(_, result)
				if not result or vim.tbl_isempty(result) then
					vim.notify("No code actions available", vim.log.levels.INFO)
					return
				end

				local implement_actions = {}
				for _, action in ipairs(result) do
					if action.title:lower():match("implement") or 
					   action.title:lower():match("add definition") or
					   action.title:lower():match("generate") then
						table.insert(implement_actions, action)
					end
				end

				if #implement_actions > 0 then
					vim.ui.select(implement_actions, { prompt = "Select action:" }, function(choice)
						if choice and choice.edit then
							vim.lsp.util.apply_workspace_edit(choice.edit)
						elseif choice and choice.command then
							client:execute_command(choice.command, {})
						end
					end)
				else
					vim.notify("No implementation actions available", vim.log.levels.INFO)
				end
			end)
		end, { buffer = bufnr, desc = "Implement Functions" })

		vim.keymap.set("n", "<leader>co", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source", "quickfix" },
				},
			}, function(_, result)
				if not result or vim.tbl_isempty(result) then
					vim.notify("No code actions available", vim.log.levels.INFO)
					return
				end

				local include_actions = {}
				for _, action in ipairs(result) do
					local title = action.title:lower()
					if title:match("include") or title:match("remove") or title:match("organize") then
						table.insert(include_actions, action)
					end
				end

				if #include_actions > 0 then
					vim.ui.select(include_actions, { prompt = "Select action:" }, function(choice)
						if choice and choice.edit then
							vim.lsp.util.apply_workspace_edit(choice.edit)
						elseif choice and choice.command then
							client:execute_command(choice.command, {})
						end
					end)
				else
					vim.notify("No include actions available", vim.log.levels.INFO)
				end
			end)
		end, { buffer = bufnr, desc = "Add/Organize Includes" })
	end,
}
