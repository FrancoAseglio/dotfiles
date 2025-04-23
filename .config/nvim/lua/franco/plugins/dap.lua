return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"jay-babu/mason-nvim-dap.nvim",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		local key = vim.keymap.set

		---------- C/C++ debug configuration ----------
		dap.configurations.cpp = dap.configurations.c
		-- Additional C/C++ specific configuration would go here

		---------- Java debug configuration ----------
		-- Setup integration between nvim-jdtls and nvim-dap
		local mason_registry = require("mason-registry")

		-- Ensure Java debug extension is present
		if not mason_registry.is_installed("java-debug-adapter") then
			vim.cmd("MasonInstall java-debug-adapter")
		end
		if not mason_registry.is_installed("java-test") then
			vim.cmd("MasonInstall java-test")
		end

		-- Setup DAP for Java files
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				-- This just sets up the DAP part, assuming JDTLS is already running
				require("jdtls").setup_dap({ hotcodereplace = "auto" })
			end,
		})

		---------- General DAP Configuration ----------
		-- DAP keymaps
		key("n", "<leader>ds", require("dap").continue, { desc = "Continue" })
		key("n", "<leader>do", require("dap").step_over, { desc = "Step Over" })
		key("n", "<leader>di", require("dap").step_into, { desc = "Step Into" })
		key("n", "<leader>du", require("dap").step_out, { desc = "Step Out" })
		key("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		key("n", "<leader>dc", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Conditional Breakpoint" })

		-- Cleanup DAP windows when quitting debugging session
		key("n", "<leader>dq", function()
			require("dap").terminate()
			require("dapui").close()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local name = vim.api.nvim_buf_get_name(buf)
				if name:match("DAP") or name:match("REPL") then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end
		end, { desc = "Quit" })

		---------- DAP UI Configuration ----------
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸" },
			mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			layouts = {
				{
					elements = { { id = "scopes", size = 0.25 }, "breakpoints", "stacks", "watches" },
					size = 60,
					position = "left",
				},
				{
					elements = { "console" },
					size = 0.35,
					position = "bottom",
				},
			},
			floating = {
				max_height = nil,
				max_width = nil,
				border = "single",
				mappings = { close = { "q", "<Esc>" } },
			},
			windows = { indent = 1 },
		})

		-- DAP UI event listeners
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		---------- DAP Virtual Text Configuration ----------
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			only_first_definition = true,
			all_references = false,
			filter_references_pattern = "<module",
			virt_text_pos = "eol",
			all_frames = false,
			virt_lines = false,
			virt_text_win_col = nil,
		})

		---------- Mason DAP Integration ----------
		require("mason-nvim-dap").setup({
			automatic_setup = true,
			automatic_installation = true,
			handlers = {},
			ensure_installed = { "codelldb", "java-debug-adapter" },
		})
	end,
}
