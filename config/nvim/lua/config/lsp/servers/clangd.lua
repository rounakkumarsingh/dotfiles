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
	on_attach = function(client, bufnr)
		-- Call the base on_attach for general keymaps and hints
		require("config.lsp.init").on_attach(client, bufnr)

		-- C/C++ Specific: Switch between Source and Header
		vim.keymap.set("n", "<leader>ch", function()
			local client_obj = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
			if client_obj then
				client_obj:request("textDocument/switchSourceHeader", { uri = vim.uri_from_bufnr(bufnr) }, function(err, result)
					if err then
						return
					end
					if not result then
						vim.notify("Corresponding file not found", vim.log.levels.WARN)
						return
					end
					vim.api.nvim_command("edit " .. vim.uri_to_fname(result))
				end, bufnr)
			end
		end, { buffer = bufnr, desc = "Switch Source/Header" })
	end,
}
