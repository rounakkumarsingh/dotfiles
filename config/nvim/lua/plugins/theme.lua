-- This file exists ONLY to keep Lazy.nvim happy.
-- It disables the Omarchy theme spec as a plugin,
-- while still allowing us to read it manually.

local ok, spec = pcall(require, "plugins.theme_raw")

if not ok then
	-- Fallback when theme_raw.lua doesn't exist (non-Omarchy systems)
	-- Return empty spec, colorscheme will be set by available theme plugin
	return {}
end

-- Mark everything disabled so Lazy.nvim ignores it
for _, entry in ipairs(spec) do
	if entry[1] == "LazyVim/LazyVim" then
		entry.enabled = false
	end
end
spec.priority = 1100
return spec
