return {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
			gofumpt = true,
			codelenses = {
				generate = true,
				gc_details = false,
				test = true,
				tidy = true,
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
			semanticTokens = true,
		},
	},
	root_markers = { "go.work", "go.mod", ".git" },
}
