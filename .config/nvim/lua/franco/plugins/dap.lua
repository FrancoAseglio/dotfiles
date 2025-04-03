return {
	"mfussenegger/nvim-dap",
	dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text", "jay-babu/mason-nvim-dap.nvim" },
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		local key = vim.keymap.set

		dap.configurations.cpp = dap.configurations.c

		key("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		key("n", "<leader>dc", dap.continue, { desc = "Continue" })
		key("n", "<leader>do", dap.step_over, { desc = "Step Over" })
		key("n", "<leader>di", dap.step_into, { desc = "Step Into" })
		key("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
		key("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
		key("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Conditional Breakpoint" })

		-- DAP UI setup
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
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

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

		require("mason-nvim-dap").setup({
			automatic_setup = true,
			automatic_installation = true,
			handlers = {},
			ensure_installed = { "codelldb" },
		})
	end,
}
