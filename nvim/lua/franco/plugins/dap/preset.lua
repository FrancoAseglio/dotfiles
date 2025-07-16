return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio", -- dap UI requires nvim-nio
			"rcarriga/nvim-dap-ui", -- the actual UI plugin
			"theHamsta/nvim-dap-virtual-text", -- virtual-text for inline debug hints
			"williamboman/mason.nvim", -- mason integration for auto-installing adapters
			"jayp0521/mason-nvim-dap.nvim",
			"rcarriga/cmp-dap", -- completion for dap
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local vt = require("nvim-dap-virtual-text")

			-- 1) Mason-DAP
			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb", "debugpy" },
				automatic_installation = true,
			})

			-- 2) Load adapters and their configurations
			require("franco.plugins.dap.adapters.c").setup(dap)
			require("franco.plugins.dap.adapters.python").setup(dap)

			-- 3) Set up dap-ui
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open   = "o",
					remove = "d",
					edit   = "e",
					repl   = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.40 },
							{ id = "breakpoints", size = 0.20 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.15 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.60 },
							{ id = "console", size = 0.40 },
						},
						size = 10,
						position = "bottom",
					},
				},
				controls = { enabled = true, element = "repl" },
				floating = {
					max_height = nil,
					max_width  = nil,
					border = "single",
					mappings = { close = { "q", "<Esc>" } },
				},
			})

			-- 4) Virtual text
			vt.setup({
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

			-- 5) Auto-open/close dap-ui
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open()  end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

			-- 6) Keymaps
			vim.keymap.set("n", "<leader><Right>", dap.continue,  { desc = "Start/Continue" })
			vim.keymap.set("n", "<leader><Down>",  dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<leader><Up>",    dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<leader><Left>",  dap.step_out,  { desc = "Step Out" })

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dc", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set Breakpoint with Condition" })

			vim.keymap.set("n", "<leader>di", function()
				if dap.session() then
					dap.terminate()
					dapui.close()
				else
					dap.continue()
				end
			end, { desc = "Toggle Debug Session" })
		end,
	},
}
