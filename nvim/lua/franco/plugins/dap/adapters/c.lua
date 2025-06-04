local M = {}

--- @param dap table  -- require("dap")
function M.setup(dap)
	local install_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = install_path,
			args = { "--port", "${port}" },
		},
	}
end

return M
