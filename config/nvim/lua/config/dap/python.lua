local dap = require("dap")

dap.adapters.python = {
	type = "executable",
	command = "debugpy-adapter",
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Python: Current file",
		program = "${file}",
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
	},
	{
		type = "python",
		request = "launch",
		name = "Python: Module",
		module = function()
			return vim.fn.input("Module name: ")
		end,
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
	},
	{
		type = "python",
		request = "launch",
		name = "Python: Pytest current file",
		module = "pytest",
		args = { "${file}" },
		cwd = "${workspaceFolder}",
		justMyCode = false,
		console = "integratedTerminal",
	},
	{
		type = "python",
		request = "launch",
		name = "Python: With arguments",
		program = "${file}",
		args = function()
			local args = vim.fn.input("Args: ")
			return vim.split(args, " ")
		end,
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
	},
	{
		type = "python",
		request = "launch",
		name = "Python: Long-running service",
		program = "${file}",
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		justMyCode = false,
		console = "integratedTerminal",
	},
}
