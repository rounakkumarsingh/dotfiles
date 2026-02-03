return {
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				-- Disable diagnostics that Ruff handles
				ignore = { "*" },
			},
		},
	},
	root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt", ".venv" },
	on_new_config = function(config, root_dir)
		local python_path = require("utils.project").get_executable(root_dir .. "/dummy", "python")
		config.settings.basedpyright.analysis.pythonPath = python_path
	end,
}
