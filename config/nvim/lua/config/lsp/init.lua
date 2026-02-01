-- lua/config/lsp/init.lua
-- This file provides shared helper functions for the LSP setup.
local M = {}

function M.get_default_lsp_caps()
	-- Use blink.cmp for capabilities
	local success, blink = pcall(require, "blink.cmp")
	if success then
		return blink.get_lsp_capabilities()
	end
	return vim.lsp.protocol.make_client_capabilities()
end

function M.on_attach(client, bufnr)
	-- Keymaps are now handled by the LspAttach autocommand in setup_keymaps()
end

function M.setup_keymaps()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			local bufnr = event.buf
			local client = vim.lsp.get_client_by_id(event.data.client_id)

			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

			local builtin = require("telescope.builtin")

			if client and client:supports_method("textDocument/definition") then
				map("gd", builtin.lsp_definitions, "Go to Definition")
			end

			if client and client:supports_method("textDocument/references") then
				map("gR", builtin.lsp_references, "Go to References")
			end

			if client and client:supports_method("textDocument/implementation") then
				map("gI", builtin.lsp_implementations, "Go to Implementation")
			end

			if client and client:supports_method("textDocument/typeDefinition") then
				map("gy", builtin.lsp_type_definitions, "Type Definition")
			end

			if client and client:supports_method("textDocument/documentSymbol") then
				map("gs", builtin.lsp_document_symbols, "Document Symbols")
			end

			if client and client:supports_method("workspace/symbol") then
				map("gS", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")
			end

			map("gC", vim.lsp.buf.incoming_calls, "Incoming Calls")
			map("gO", vim.lsp.buf.outgoing_calls, "Outgoing Calls")
			map("K", vim.lsp.buf.hover, "Hover Documentation")
			map("gK", vim.lsp.buf.signature_help, "Signature Help")

			map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
			map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

			-- Toggle Inlay Hints
			if client and client.server_capabilities.inlayHintProvider then
				map("<leader>ti", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
				end, "Toggle Inlay Hints")
			end
		end,
	})
end

function M.setup_diagnostics()
	vim.diagnostic.config({
		virtual_text = {
			prefix = "▎",
			spacing = 4,
			severity = { min = vim.diagnostic.severity.WARN },
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚",
				[vim.diagnostic.severity.WARN] = "󰀪",
				[vim.diagnostic.severity.HINT] = "󰌶",
				[vim.diagnostic.severity.INFO] = "󰋽",
			},
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "",
		},
	})
end

return M
