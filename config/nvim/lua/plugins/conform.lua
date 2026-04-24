local tool = require("utils.tool_check")

-- Build formatters with fallback chains
local js_formatters = tool.formatter_fallback({ "oxfmt", "biome", "prettierd", "prettier" })
local json_formatters = tool.formatter_fallback({ "oxfmt", "biome", "prettierd", "prettier" })
local css_formatters = tool.formatter_fallback({ "oxfmt", "biome", "prettierd", "prettier" })

-- Warn if preferred formatters are missing
local notified = {}
local function warn_missing(preferred, available, ft)
	if not notified[ft] and #available == 0 then
		notified[ft] = true
		vim.notify(
			("No formatter available for %s (tried: %s)"):format(ft, table.concat(preferred, ", ")),
			vim.log.levels.WARN
		)
	elseif not notified[ft] and available[1] ~= preferred[1] then
		notified[ft] = true
		vim.notify(
			("Using fallback formatter '%s' for %s (preferred: %s)"):format(available[1], ft, preferred[1]),
			vim.log.levels.INFO
		)
	end
end

warn_missing({ "oxfmt", "biome", "prettierd", "prettier" }, js_formatters, "javascript")
warn_missing({ "oxfmt", "biome", "prettierd", "prettier" }, css_formatters, "css")

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format", "ruff_fix" },
			go = { "goimports-reviser", "gofumpt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			javascript = js_formatters,
			typescript = js_formatters,
			javascriptreact = js_formatters,
			typescriptreact = js_formatters,
			json = json_formatters,
			jsonc = json_formatters,
			css = css_formatters,
			scss = css_formatters,
			less = css_formatters,
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
		formatters = {
			["goimports-reviser"] = {
				prepend_args = { "-rm-unused", "-set-alias" },
			},
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)

		-- Add command to check formatter status
		vim.api.nvim_create_user_command("ConformStatus", function()
			local conform = require("conform")
			local ft = vim.bo.filetype
			local formatters = conform.list_formatters_for_buffer()

			print("Formatters for " .. ft .. ":")
			if formatters and #formatters > 0 then
				for _, fmt in ipairs(formatters) do
					local available = fmt.available and "✓" or "✗"
					print("  " .. available .. " " .. fmt.name)
				end
			else
				print("  None configured")
			end
		end, { desc = "Show formatter status for current buffer" })
	end,
}
