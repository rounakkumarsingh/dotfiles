-- lua/utils/project.lua
-- This module provides generic, project-aware utility functions.
local M = {}

---Finds the nearest ancestor directory that contains one of the given markers.
---@param start_path string The file path to start searching from.
---@param markers table A list of directory or file names to search for.
---@return string|nil The path of the ancestor directory, or nil if not found.
local function find_ancestor(start_path, markers)
	local path_sep = package.config:sub(1, 1)
	-- Start with the current path if it's a directory, otherwise its parent
	local current_path = vim.fn.isdirectory(start_path) == 1 and start_path or vim.fn.fnamemodify(start_path, ":h")

	-- Limit search depth to prevent infinite loops in weird filesystems
	for i = 1, 100 do
		for _, marker in ipairs(markers) do
			local marker_path = current_path .. path_sep .. marker
			if (vim.fn.isdirectory(marker_path) == 1) or (vim.fn.filereadable(marker_path) == 1) then
				return current_path
			end
		end

		local parent = vim.fn.fnamemodify(current_path, ":h")
		if parent == current_path then
			return nil -- Reached the filesystem root
		end
		current_path = parent
	end

	return nil
end

-- A cache to store the project root to avoid repeated searches.
local root_cache = {}

---Finds the project root for a given file.
---Looks for common project markers like .git.
---@param filename string The full path of a file within the project.
---@return string|nil The project root path.
function M.find_root(filename)
	if not filename or filename == "" then
		return nil
	end
	if root_cache[filename] then
		return root_cache[filename]
	end

	local root = find_ancestor(filename, {
		"bun.lockb",
		"bun.lock",
		".git",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		".venv",
		"venv",
		"env",
		"go.mod",
		"package.json",
		"Makefile",
	})
	root_cache[filename] = root
	return root
end

local executable_cache = {}

---Gets the path to a project-specific executable if it exists.
---@param filename string The file being edited.
---@param executable string The name of the executable (e.g., "ruff", "prettier").
---@return string The absolute path to the venv executable, or the global command name.
function M.get_executable(filename, executable)
	-- Normalize filename to absolute path
	filename = vim.fn.fnamemodify(filename, ":p")
	local root = M.find_root(filename)
	local cache_key = (root or vim.fn.fnamemodify(filename, ":h")) .. ":" .. executable

	if executable_cache[cache_key] then
		return executable_cache[cache_key]
	end

	local result = executable -- Default fallback

	-- 1. Try markers-based root
	if root then
		local venv_paths = {
			root .. "/.venv/bin/" .. executable,
			root .. "/venv/bin/" .. executable,
			root .. "/env/bin/" .. executable,
			root .. "/.env/bin/" .. executable,
		}

		for _, path in ipairs(venv_paths) do
			if vim.fn.executable(path) == 1 then
				result = path
				goto found
			end
		end
	end

	-- 2. Try searching upwards from the file itself (independent of find_root markers)
	do
		local path_sep = package.config:sub(1, 1)
		local current_path = vim.fn.fnamemodify(filename, ":h")
		for i = 1, 10 do -- Limit search depth
			local venv_markers = { ".venv", "venv", "env", ".env" }
			for _, marker in ipairs(venv_markers) do
				local exec_path = current_path .. path_sep .. marker .. path_sep .. "bin" .. path_sep .. executable
				if vim.fn.executable(exec_path) == 1 then
					result = exec_path
					goto found
				end
			end
			local parent = vim.fn.fnamemodify(current_path, ":h")
			if parent == current_path then break end
			current_path = parent
		end
	end

	-- 3. Conda environment check
	if vim.env.CONDA_PREFIX then
		local conda_executable = vim.env.CONDA_PREFIX .. "/bin/" .. executable
		if vim.fn.executable(conda_executable) == 1 then
			result = conda_executable
			goto found
		end
	end

	-- 4. Global fallback
	if vim.fn.executable(executable) == 1 then
		result = vim.fn.exepath(executable)
	end

	::found::
	executable_cache[cache_key] = result
	return result
end

---Gets a formatted string for the active python environment.
---@return string The formatted string for the statusline.
function M.get_active_python_env()
	if vim.bo.filetype ~= "python" then
		return ""
	end
	local filename = vim.api.nvim_buf_get_name(0)
	local python_path = M.get_executable(filename, "python")

	if python_path and (string.find(python_path, "/.venv/") or string.find(python_path, "/venv/")) then
		return "🐍 .venv"
	elseif vim.env.CONDA_PREFIX and python_path and string.find(python_path, vim.env.CONDA_PREFIX) then
		return "🐍 conda"
	else
		return "🐍 Global"
	end
end

return M
