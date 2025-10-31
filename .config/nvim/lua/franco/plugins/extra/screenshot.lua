return {
	"mistricky/codesnap.nvim",
	build = "make",
	opts = {
		mac_window_bar = false,
		save_path = "~/CodeSnap/",
		has_breadcrumbs = false,
		bg_theme = "bamboo",
		has_line_number = true,
		title = "",
		watermark = "",
	},
	vim.keymap.set("v", "<leader>cs", ":CodeSnapSave<CR>", { noremap = true, silent = true }),
}
