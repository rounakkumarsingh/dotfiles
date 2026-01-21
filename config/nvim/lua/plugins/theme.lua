-- This file exists ONLY to keep Lazy.nvim happy.
-- It disables the Omarchy theme spec as a plugin,
-- while still allowing us to read it manually.

local spec = require("plugins.theme_raw")

-- Mark everything disabled so Lazy.nvim ignores it
for _, entry in ipairs(spec) do
    if entry[1] == "LazyVim/LazyVim" then
        entry.enabled = false
    end
end

return spec

