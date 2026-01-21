local max_filesize = 100 * 1024 -- 100 KB

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"comment",
					"html",
					"xml",
					"c",
					"lua",
					"markdown",
					"markdown_inline",
					"java",
					"javascript",
					"typescript",
					"bash",
					"jsdoc",
					"go",
					"rust",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							vim.notify(
								"File larger than 100KB — treesitter disabled for performance",
								vim.log.levels.WARN,
								{ title = "Treesitter" }
							)
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
				-- Playground config is usually placed inside the main treesitter setup
				playground = {
					enable = true,
					disable = {},
					updatetime = 25,
					persist_queries = false,
					keybindings = {
						toggle_query_editor = "o",
						toggle_hl_groups = "i",
						toggle_injected_languages = "t",
						toggle_anonymous_nodes = "a",
						toggle_language_display = "I",
						focus_language = "f",
						unfocus_language = "F",
						update = "R",
						goto_node = "<cr>",
						show_help = "?",
					},
				},
			})
		end,
	},
}
