return {
	"mistricky/codesnap.nvim",
	build = "make",
	version = "^1", -- pinned to old stable version

	config = function(_, opts)
		require("codesnap").setup(opts)
    vim.keymap.set("x", "<leader>cs", ":CodeSnapSave<cr>", { noremap = true, silent = true })
	end,

	opts = {
		mac_window_bar  = false,
		has_line_number = true,
		has_breadcrumbs = false,
		save_path       = "~/Screenshots/",
		watermark       = "",
		title           = "",
		bg_theme        = "default",
	},
}
