-- lua/plugins/lsp.lua
return {
	-- First, mason.nvim, which is the package manager for LSPs.
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = { "basedpyright", "gopls", "goimports-reviser", "gofumpt", "golangci-lint" },
		},
	},

	-- Second, mason-lspconfig.nvim, which connects mason and lspconfig.
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "basedpyright", "gopls" },
			-- This is the single, unified handler that will be called for every server.
			handlers = {
				function(server_name)
					local base_opts = {
						capabilities = require("config.lsp.init").get_default_lsp_caps(),
					}

					local server_configs = {
						basedpyright = {
							settings = require("config.lsp.settings.basedpyright").settings,
							root_dir = function(fname)
								return require("utils.project").find_root(fname) or vim.uv.cwd()
							end,
							on_new_config = function(config, root_dir)
								local python_path = require("utils.project").get_executable(root_dir, "python")
								local venv_path = vim.fn.fnamemodify(python_path, ":h:h:h")
								local venv_name = vim.fn.fnamemodify(python_path, ":h:h:t")

								config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
									python = {
										pythonPath = python_path,
										venvPath = venv_path,
										venv = venv_name,
									},
									basedpyright = {
										analysis = {
											pythonPath = python_path,
											venvPath = venv_path,
											venv = venv_name,
										},
									},
								})
							end,
						},
						gopls = {
							settings = require("config.lsp.settings.gopls").settings,
							root_dir = function(fname)
								return require("utils.project").find_root(fname) or vim.uv.cwd()
							end,
						},
					}

					local server_specific_opts = server_configs[server_name] or {}
					local final_opts = vim.tbl_deep_extend("force", base_opts, server_specific_opts)
					require("lspconfig")[server_name].setup(final_opts)
				end,
			},
		},
	},

	-- Finally, the core LSP client.
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("config.lsp.init").setup_diagnostics()
			require("config.lsp.init").setup_keymaps()
		end,
	},
}
