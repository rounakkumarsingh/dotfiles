local M = {}

local function extract_colorscheme(spec)
    for _, entry in ipairs(spec) do
        if entry.opts and entry.opts.colorscheme then
            return entry.opts.colorscheme
        end
    end
end

function M.load()
    local ok, spec = pcall(require, "plugins.theme_raw")
    if not ok then
        return
    end

    local colorscheme = extract_colorscheme(spec)
    if not colorscheme then
        return
    end

    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end

    vim.o.background = "dark"
    pcall(vim.cmd.colorscheme, colorscheme)

    pcall(
        dofile,
        vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"
    )

    vim.cmd("redraw!")
end

return M
