return {
	"mfussenegger/nvim-dap",
	dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text", "jay-babu/mason-nvim-dap.nvim" },
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		local key = vim.keymap.set

		dap.configurations.cpp = dap.configurations.c

		-- Setup integration between nvim-jdtls and nvim-dap  58j
		local jdtls_setup = function()
			local mason_registry = require("mason-registry") -- Make sure java debug extension is present

			-- Java Debug and Test dependencies
			local java_debug_path = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter"
			local java_test_path = vim.fn.stdpath("data") .. "/mason/packages/java-test"

			-- Ensure both packages are installed via Mason
			if not mason_registry.is_installed("java-debug-adapter") then
				vim.cmd("MasonInstall java-debug-adapter")
			end

			if not mason_registry.is_installed("java-test") then
				vim.cmd("MasonInstall java-test")
			end

			local bundles = {
				vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
			}

			-- Add Java test bundles
			vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n"))

			-- Set up Java LSP with debugging capability
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
				init_options = {
					bundles = bundles,
				},
			}

			require("jdtls").setup_dap({ hotcodereplace = "auto" }) -- Set up JAR files for debugging

			return config
		end

		-- Set up jdtls on java file open
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				local config = jdtls_setup()
				require("jdtls").start_or_attach(config)
			end,
		})
		---------- java debug setting 58k ----------

		-- DAP keymaps
		key("n", "<leader>ds", dap.continue, { desc = "Start aka Continue" })

		key("n", "<leader><Right>", require("dap").continue, { desc = "Continue" })
		key("n", "<leader><Up>", require("dap").step_over, { desc = "Step Over" })
		key("n", "<leader><Down>", require("dap").step_into, { desc = "Step Into" })
		key("n", "<leader><Left>", require("dap").step_out, { desc = "Step Out" })

		key("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })

		key("n", "<leader>dc", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Conditional Breakpoint" })

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

		-- Mason DAP languages
		require("mason-nvim-dap").setup({
			automatic_setup = true,
			automatic_installation = true,
			handlers = {},
			ensure_installed = { "codelldb", "java-debug-adapter" },
		})
	end,
}
