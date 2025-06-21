return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
	vim.keymap.set("n", "<leader>fe", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
	vim.keymap.set("n", "<leader>sh", function()
		require("oil.actions").toggle_hidden.callback()
	end, { desc = "Toggle hidden files in Oil" }),
}
