return {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
				unusedwrite = true,
				useany = true,
			},
			staticcheck = true,
			gofumpt = true,
			completeUnimported = true,
			usePlaceholders = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			codelenses = {
				generate = true,
				gc_details = false,
				test = true,
				tidy = true,
				vendor = true,
				upgrade = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			["ui.semanticTokens"] = true,
		},
	},
	root_markers = { "go.work", "go.mod", ".git" },
}
