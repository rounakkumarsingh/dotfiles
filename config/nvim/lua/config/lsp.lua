vim.diagnostic.config({
    virtual_text = {
        prefix = "▎",
        spacing = 4,
        severity = { min = vim.diagnostic.severity.WARN },
    },
    signs = {
        active = { "󰅚", "󰀪", "󰌶", "󰋽" }, -- Error, Warn, Hint, Info
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

local blink = require("blink.cmp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = blink.get_lsp_capabilities(capabilities)

local on_attach = function(client, bufnr)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
        buffer = bufnr,
        desc = "Show diagnostics at cursor",
    })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition , { buffer = bufnr })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration , { buffer = bufnr })
    vim.keymap.set("n", "gr", vim.lsp.buf.references , { buffer = bufnr })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
end


vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    on_attach = on_attach,
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most
                    -- likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Tell the language server how to find Lua modules same way as Neovim
                    -- (see `:h lua-module-load`)
                    path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                    },
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                        -- Depending on the usage, you might want to add additional paths
                        -- here.
                        -- '${3rd}/luv/library'
                        -- '${3rd}/busted/library'
                    }
                    -- Or pull in all of 'runtimepath'.
                    -- NOTE: this is a lot slower and will cause issues when working on
                    -- your own configuration.
                    -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                    -- library = {
                        --   vim.api.nvim_get_runtime_file('', true),
                        -- }
                    }
                })
            end,
            settings = {
                Lua = {}
            }
        })

vim.lsp.enable('lua_ls')

