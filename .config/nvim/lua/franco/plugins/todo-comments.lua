return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo_comments = require("todo-comments")

		-- TODO, WARNING, BUG examples
		-- remember to comment UPPERCASE_WITH_:
		-- TODO: sample 1
		-- WARN: sample 2
		-- FIX:  sample 3
		-- NOTE: sample 4
		-- PERF: sample 5

		-- set keymaps for navigation
		local keymap = vim.keymap -- for conciseness

		-- Open TODO list with Telescope
		keymap.set("n", "<leader>tt", ":TodoTelescope<CR>", { desc = "Search TODO comments with Telescope" })

		todo_comments.setup()
	end,
}
