return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = {
		{ "echasnovski/mini.icons", opts = {} },
	},
	lazy = false,
	init = function()
		vim.keymap.set("n", "<leader>fe", "<CMD>Oil<CR>", { desc = "Open oil" })

		vim.keymap.set("n", "<leader>fh", function()
			local ok, oil = pcall(require, "oil.actions")
			if ok then
				oil.toggle_hidden.callback()
			end
		end, { desc = "Toggle hidden files" })
	end,
}
