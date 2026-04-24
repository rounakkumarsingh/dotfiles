return {
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "standard",
				-- Disable diagnostics that Ruff handles
				ignore = { "*" },
				diagnosticSeverityOverrides = {
					reportUnusedImport = "none",
					reportUnusedVariable = "none",
					reportImplicitRelativeImport = "none",
					reportMissingModuleSource = "warning",
				},
			},
		},
	},
	root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt", ".venv" },
	on_new_config = function(config, root_dir)
		local ok, project = pcall(require, "utils.project")
		if ok and project then
			local python_path = project.get_executable(root_dir .. "/dummy", "python")
			config.settings.basedpyright.analysis.pythonPath = python_path
		end
	end,
}
