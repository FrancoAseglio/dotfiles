return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"jay-babu/mason-nvim-dap.nvim",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local key = vim.keymap.set

		---------- Debug Adapter Protocol (DAP) Keymaps ----------
		key("n", "<leader>ds", dap.continue, { desc = "Continue" })
		key("n", "<leader>do", dap.step_over, { desc = "Step Over" })
		key("n", "<leader>di", dap.step_into, { desc = "Step Into" })
		key("n", "<leader>du", dap.step_out, { desc = "Step Out" })
		key("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		key("n", "<leader>dc", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Conditional Breakpoint" })
		key("n", "<leader>dq", function()
			dap.terminate()
			dapui.close()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local name = vim.api.nvim_buf_get_name(buf)
				if name:match("DAP") or name:match("REPL") then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end
		end, { desc = "Quit" })

		---------- C/C++ Debug Configuration ----------
		dap.configurations.cpp = dap.configurations.c

		---------- Java DAP Setup with JDTLS ----------
		local jdtls_setup = function()
			local mason_registry = require("mason-registry")
			local java_debug_path = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter"
			local java_test_path = vim.fn.stdpath("data") .. "/mason/packages/java-test"

			-- Ensure debug and test extensions are installed
			if not mason_registry.is_installed("java-debug-adapter") then
				vim.cmd("MasonInstall java-debug-adapter")
			end
			if not mason_registry.is_installed("java-test") then
				vim.cmd("MasonInstall java-test")
			end

			-- Gather bundles for debugger and tests
			local bundles = {
				vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
			}
			vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n"))

			-- Setup JDTLS with DAP support
			local config = {
				cmd = { "jdtls" },
				root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
				settings = {
					java = {
						configuration = {
							runtimes = {
								{
									name = "JavaSE-17",
									path = "/Library/Java/JavaVirtualMachines/jdk-24.jdk/Contents/Home",
								},
							},
						},
					},
				},
				init_options = { bundles = bundles },
			}

			require("jdtls").setup_dap({ hotcodereplace = "auto" })

			return config
		end

		-- Automatically start or attach jdtls on Java file open
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				local config = jdtls_setup()
				require("jdtls").start_or_attach(config)
			end,
		})

		---------- DAP UI Setup ----------
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
					elements = {
						{ id = "scopes", size = 0.25 },
						"breakpoints",
						"stacks",
						"watches",
					},
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

		-- Auto-open/close DAP UI on events
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		---------- DAP Virtual Text Setup ----------
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

		---------- Mason DAP Setup ----------
		require("mason-nvim-dap").setup({
			automatic_setup = true,
			automatic_installation = true,
			handlers = {},
			ensure_installed = { "codelldb", "java-debug-adapter" },
		})
	end,
}
