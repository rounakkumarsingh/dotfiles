return {
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "standard",
				-- Disable diagnostics that Ruff or other tools handle better
				-- or that are too noisy in small test projects.
				diagnosticSeverityOverrides = {
					reportUnusedImport = "none",
					reportUnusedVariable = "none",
					reportImplicitRelativeImport = "none",
					reportMissingModuleSource = "warning", -- Keep as warning but not error
				},
			},
		},
	},
}
