return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
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
					i = { ["<C-q>"] = actions.send_selected_to_qflist },
				},
			},
		})
		telescope.load_extension("fzf")
		-- set keymaps
		vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Files in cwd" })
		vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    { desc = "Recent files" })
		vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",   { desc = "String in cwd" })
		vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "String under cursor in cwd" })
	end,
}
