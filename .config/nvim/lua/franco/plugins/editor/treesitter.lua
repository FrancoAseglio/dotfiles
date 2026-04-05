return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { "windwp/nvim-ts-autotag" },
	config = function()
		vim.g.ts_extra_ensure_installed = {
			"c",
			"sql",
			"lua",
			"css",
			"html",
			"json",
			"java",
			"yaml",
			"bash",
			"python",
			"markdown",
			"gitignore",
			"dockerfile",
			"javascript",
			"typescript",
		}
		require("nvim-ts-autotag").setup()
	end,
}
