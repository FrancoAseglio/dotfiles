local M = {}

local function get_poetry_venv()
	local handle = io.popen("poetry env info --path 2>/dev/null")
	if handle then
		local result = handle:read("*a"):gsub("\n", "")
		handle:close()
		if result and result ~= "" then
			return result .. "/bin/python3"
		end
	end
	return nil
end

function M.setup(dap)
	-- 1) Define the adapter
	dap.adapters.python = {
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python3",
		args = { "-m", "debugpy.adapter" },
	}

	-- 2) Define the configurations
	dap.configurations.python = {
		{
			name = "Launch file (Poetry)",
			type = "python",
			request = "launch",
			program = "${file}",
			pythonPath = get_poetry_venv,
			console = "integratedTerminal",
			cwd = "${workspaceFolder}",
			args = function()
				local input = vim.fn.input("Program arguments: ")
				if input == "" then
					return {}
				end
				return vim.split(input, " ", { trimempty = true })
			end,
		},
		{
			name = "Debug pytest (Poetry)",
			type = "python",
			request = "launch",
			module = "pytest",
			pythonPath = get_poetry_venv,
			console = "integratedTerminal",
			cwd = "${workspaceFolder}",
			args = function()
				local input = vim.fn.input("Test arguments: ", "${file}")
				if input == "" then
					return { "${file}" }
				end
				return vim.split(input, " ", { trimempty = true })
			end,
		},
	}
end

return M
