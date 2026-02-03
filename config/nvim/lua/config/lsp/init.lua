local M = {}

-- Store keymaps in a central table for reuse/customization
M.lsp_keymaps = {
	{ "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
	{ "gr", vim.lsp.buf.references, desc = "Go to References" },
	{ "gi", vim.lsp.buf.implementation, desc = "Go to Implementation" },
	{ "gy", vim.lsp.buf.type_definition, desc = "Go to Type Definition" },
	{ "gs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document Symbols" },
	{ "gS", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "Workspace Symbols" },
	{ "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
	{ "<leader>cr", function() Snacks.rename.rename() end, desc = "Rename Symbol" },
	{ "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code Action", mode = { "n", "v" } },
	{ "<leader>cs", vim.lsp.buf.signature_help, desc = "Signature Help" },
	{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
	{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
	{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions/references/... (Trouble)" },
	{ "<leader>ti", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
	end, desc = "Toggle Inlay Hints" },
}

function M.on_attach(client, bufnr)
	-- Set keymaps
	for _, map in ipairs(M.lsp_keymaps) do
		local opts = { buffer = bufnr, desc = map.desc }
		local mode = map.mode or "n"
		vim.keymap.set(mode, map[1], map[2], opts)
	end

	-- Enable inlay hints by default if supported
	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

function M.get_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- Integrate with blink-cmp
	return require("blink.cmp").get_lsp_capabilities(capabilities)
end

function M.setup()
	-- Configure diagnostics
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

	-- Load modular server configs
	local servers_path = vim.fn.stdpath("config") .. "/lua/config/lsp/servers"
	local server_files = vim.fn.glob(servers_path .. "/*.lua", false, true)

	for _, file in ipairs(server_files) do
		local server_name = vim.fn.fnamemodify(file, ":t:r")
		local config = require("config.lsp.servers." .. server_name)
		
		-- Merge base config with server-specific config
		local final_config = vim.tbl_deep_extend("force", {
			on_attach = M.on_attach,
			capabilities = M.get_capabilities(),
		}, config or {})

		vim.lsp.config(server_name, final_config)
	end
end

return M
