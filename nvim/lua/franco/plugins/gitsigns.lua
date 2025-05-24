return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			map("n", "nh", gs.next_hunk, "Next Hunk")
			map("n", "ph", gs.prev_hunk, "Prev Hunk")
			map("n", "<leader>dh", gs.diffthis, "Diff this")
		end,
	},
}
