return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = require("gitsigns")

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			map("n", "<leader>hn", gs.next_hunk, "Next Git Hunk")
			map("n", "<leader>hp", gs.prev_hunk, "Prev Git Hunk")
			map("n", "<leader>gd", gs.diffthis,  "Git Diff This")
		end,
	},
}
