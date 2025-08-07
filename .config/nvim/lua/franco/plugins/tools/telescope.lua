return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "stevearc/dressing.nvim", event = "VeryLazy" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values

		local function find_projects()
			local projects = {}
			local cmd = "find ~ -maxdepth 3 -type d -name '.git' 2>/dev/null | sed 's/\\.git$//' | sort"
			local handle = io.popen(cmd)
			
			if handle then
				for line in handle:lines() do
					local project_name = line:match(".*/(.+)$") or line
					table.insert(projects, {
						name = project_name,
						path = line,
						display = project_name .. " (" .. line .. ")"
					})
				end
				handle:close()
			end

			pickers.new({}, {
				prompt_title = "Projects",
				finder = finders.new_table({
					results = projects,
					entry_maker = function(entry)
						return {
							value = entry,
							display = entry.display,
							ordinal = entry.name .. " " .. entry.path,
							path = entry.path,
						}
					end,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						if selection then
							vim.cmd("cd " .. selection.path)
							print("Changed to: " .. selection.path)
							vim.defer_fn(function() vim.cmd("Telescope find_files") end, 100)
						end
					end)
					return true
				end,
			}):find()
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						width  = 0.90,
						height = 0.80,
						preview_width = 0.6,
						results_width = 0.3,
						prompt_position = "bottom",
					},
				},
				mappings = {i = {["<C-q>"] = actions.send_selected_to_qflist,},},
			},
		})

		pcall(telescope.load_extension, "fzf")

		local map = vim.keymap.set
		local opts = { noremap = true, silent = true }
		
		map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  vim.tbl_extend("force", opts, { desc = "Files in cwd" }))
		map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    vim.tbl_extend("force", opts, { desc = "Recent files" }))
		map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",   vim.tbl_extend("force", opts, { desc = "String in cwd" }))
		map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", vim.tbl_extend("force", opts, { desc = "String under cursor in cwd" }))
		map("n", "<leader>fp", find_projects, vim.tbl_extend("force", opts, { desc = "Find projects" }))
	end,
}
