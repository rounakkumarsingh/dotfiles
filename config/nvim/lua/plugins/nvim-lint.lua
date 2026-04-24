local tool = require("utils.tool_check")

-- Build linters with fallback chains
local js_linters = tool.linter_fallback({ "oxlint", "biomejs", "eslint_d", "eslint" })
local json_linters = tool.linter_fallback({ "oxlint", "biomejs", "jsonlint" })
local css_linters = tool.linter_fallback({ "stylelint", "biomejs" })

-- Warn if preferred linters are missing
local notified = {}
local function warn_missing(preferred, available, ft)
	if not notified[ft] and #available == 0 then
		notified[ft] = true
		vim.notify(
			("No linter available for %s (tried: %s)"):format(ft, table.concat(preferred, ", ")),
			vim.log.levels.WARN
		)
	elseif not notified[ft] and available[1] ~= preferred[1] then
		notified[ft] = true
		vim.notify(
			("Using fallback linter '%s' for %s (preferred: %s)"):format(available[1], ft, preferred[1]),
			vim.log.levels.INFO
		)
	end
end

warn_missing({ "oxlint", "biomejs", "eslint_d", "eslint" }, js_linters, "javascript")
warn_missing({ "stylelint", "biomejs" }, css_linters, "css")

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile", "BufWritePost" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "ruff" },
			go = { "golangcilint" },
			javascript = js_linters,
			typescript = js_linters,
			javascriptreact = js_linters,
			typescriptreact = js_linters,
			json = json_linters,
			jsonc = json_linters,
			css = css_linters,
			scss = css_linters,
			less = css_linters,
		}

		-- Only lint if linters are actually available
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				local names = lint.linters_by_ft[vim.bo.filetype]
				if names and #names > 0 then
				-- Check if any linter is actually available
				local has_any = false
				for _, name in ipairs(names) do
					local linter = lint.linters[name]
					if linter then
						local cmd = linter.cmd or name
						-- cmd can be a function or table in some linter configs
						if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
							has_any = true
							break
						end
					end
				end

					if has_any then
						lint.try_lint()
					end
				end
			end,
		})

		-- Add command to check linter status
		vim.api.nvim_create_user_command("LintStatus", function()
			local ft = vim.bo.filetype
			local linters = lint.linters_by_ft[ft]

			print("Linters for " .. ft .. ":")
			if linters and #linters > 0 then
			for _, name in ipairs(linters) do
				local linter = lint.linters[name]
				local cmd = linter and linter.cmd or name
				if type(cmd) == "string" then
					local available = vim.fn.executable(cmd) == 1 and "✓" or "✗"
					print("  " .. available .. " " .. name .. " (" .. cmd .. ")")
				else
					print("  ? " .. name .. " (dynamic cmd)")
				end
			end
			else
				print("  None configured")
			end
		end, { desc = "Show linter status for current buffer" })

		-- Add command to clear tool cache and recheck
		vim.api.nvim_create_user_command("LintClearCache", function()
			tool.clear_cache()
			notified = {}
			vim.notify("Tool availability cache cleared", vim.log.levels.INFO)
		end, { desc = "Clear linter tool availability cache" })
	end,
}
