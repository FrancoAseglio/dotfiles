return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = {
		focus = true,
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open workspace diagnostics" },
		{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open document diagnostics" },
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open location list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
	},
}
