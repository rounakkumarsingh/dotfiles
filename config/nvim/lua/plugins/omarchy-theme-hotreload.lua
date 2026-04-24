return {
	{
		name = "omarchy-theme-hotreload",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			-- Only set up hot-reload if omarchy adapter exists
			local ok, adapter = pcall(require, "omarchy.theme-adapter")
			if not ok then
				-- Silently skip on non-Omarchy systems
				return
			end

			adapter.load()

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyReload",
				callback = function()
					package.loaded["plugins.theme_raw"] = nil
					package.loaded["omarchy.theme-adapter"] = nil

					vim.schedule(function()
						local ok2, reloaded = pcall(require, "omarchy.theme-adapter")
						if ok2 then
							reloaded.load()
							vim.cmd("redraw!")
						end
					end)
				end,
			})
		end,
	},
}
