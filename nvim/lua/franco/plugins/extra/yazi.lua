return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = { "folke/snacks.nvim" },
	keys = {
		{
			"<leader>y",
			function()
				require("yazi").yazi(nil, vim.fn.expand("~"))
			end,
			desc = "Open yazi in home dir",
		},
		{ "<leader>cd", "<cmd>Yazi cwd<cr>", desc = "Open yazi in cwd" },
	},
}
