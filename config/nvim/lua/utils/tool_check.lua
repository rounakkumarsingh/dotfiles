local M = {}

local cache = {}

---Check if tool is available via Mason or system
---@param tool string Tool name
---@return boolean
function M.is_available(tool)
	if cache[tool] ~= nil then
		return cache[tool]
	end

	-- Check Mason's bin directory first
	local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/" .. tool
	if vim.fn.executable(mason_bin) == 1 then
		cache[tool] = true
		return true
	end

	-- Fall back to system PATH
	local result = vim.fn.executable(tool) == 1
	cache[tool] = result
	return result
end

---Clear the tool availability cache
function M.clear_cache()
	cache = {}
end

---Get full path to tool (Mason preferred)
---@param tool string Tool name
---@return string|nil Full path or nil
function M.get_path(tool)
	local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/" .. tool
	if vim.fn.executable(mason_bin) == 1 then
		return mason_bin
	end
	if vim.fn.executable(tool) == 1 then
		return vim.fn.exepath(tool)
	end
	return nil
end

---Check if any executable in a list is available
---@param tools table List of tool names
---@return string|nil First available tool name
function M.first_available(tools)
	for _, tool in ipairs(tools) do
		if M.is_available(tool) then
			return tool
		end
	end
	return nil
end

---Build formatter list with fallback chain
---@param preferred table Ordered list of preferred formatters
---@return table List of available formatters (may be empty)
function M.formatter_fallback(preferred)
	local available = {}
	for _, tool in ipairs(preferred) do
		if M.is_available(tool) then
			table.insert(available, tool)
		end
	end
	return available
end

---Build linter list with fallback chain
---@param preferred table Ordered list of preferred linters
---@return table List of available linters (may be empty)
function M.linter_fallback(preferred)
	local available = {}
	for _, tool in ipairs(preferred) do
		if M.is_available(tool) then
			table.insert(available, tool)
		end
	end
	return available
end

return M
