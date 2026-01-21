return {
	{
		name = "omarchy-theme-hotreload",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			require("omarchy.theme-adapter").load()
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyReload",
				callback = function()
					package.loaded["plugins.theme_raw"] = nil
					package.loaded["omarchy.theme-adapter"] = nil

					vim.schedule(function()
						require("omarchy.theme-adapter").load()
						vim.cmd("redraw!")
					end)
				end,
			})
		end,
	},
}

