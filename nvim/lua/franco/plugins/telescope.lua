return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions   = require("telescope.actions")

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
				mappings = {
					i = { ["<C-q>"] = actions.send_selected_to_qflist, },
				},
			},
		})

		pcall(telescope.load_extension, "fzf")
		local map  = vim.keymap.set
		local opts = { noremap = true, silent = true }

		map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  vim.tbl_extend("force", opts, { desc = "Files in cwd" }))
		map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    vim.tbl_extend("force", opts, { desc = "Recent files" }))
		map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",   vim.tbl_extend("force", opts, { desc = "String in cwd" }))
		map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", vim.tbl_extend("force", opts, { desc = "String under cursor in cwd" }))
	end,
}
