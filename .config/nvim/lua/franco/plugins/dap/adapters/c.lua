local M = {}

function M.setup(dap)
	-- 1) define the adapter
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
			args = { "--port", "${port}" },
		},
	}

	-- 2) define the configurations
	dap.configurations.c = {
		{
			name = "Launch executable",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = function()
				local input = vim.fn.input("Program arguments: ")
				return vim.split(input, " ", { trimempty = true })
			end,
		},
	}
end

return M
