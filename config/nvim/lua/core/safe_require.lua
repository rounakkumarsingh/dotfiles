local M = {}

---Safe require wrapper with fallback notifications
---@param module string Module path
---@param opts? {silent?: boolean, fallback?: function, message?: string}
---@return table|nil Loaded module or nil
function M.require(module, opts)
	opts = opts or {}
	local ok, result = pcall(require, module)

	if ok then
		return result
	end

	if not opts.silent then
		vim.notify(
			opts.message or ("Optional module '%s' not available: %s"):format(module, result),
			vim.log.levels.DEBUG
		)
	end

	if opts.fallback then
		return opts.fallback()
	end

	return nil
end

---Check if executable exists in PATH
---@param cmd string|table Command name(s)
---@return boolean
function M.has_executable(cmd)
	if type(cmd) == "table" then
		for _, c in ipairs(cmd) do
			if vim.fn.executable(c) == 1 then
				return true
			end
		end
		return false
	end
	return vim.fn.executable(cmd) == 1
end

---Check if any LSP server binary exists
---@param servers table List of server names to check
---@return table List of available server names
function M.available_lsp_servers(servers)
	local cmd_map = {
		basedpyright = "basedpyright",
		gopls = "gopls",
		clangd = "clangd",
		vtsls = "vtsls",
		["rust-analyzer"] = "rust-analyzer",
		cssls = "vscode-css-language-server",
		jsonls = "vscode-json-language-server",
		tailwindcss = "tailwindcss-language-server",
	}

	local available = {}
	for _, server in ipairs(servers) do
		local binary = cmd_map[server] or server
		if vim.fn.executable(binary) == 1 then
			table.insert(available, server)
		end
	end
	return available
end

return M
