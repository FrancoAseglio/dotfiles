return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { "windwp/nvim-ts-autotag" },

	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			sync_install = false,
			auto_install = true,
			ensure_installed = {
				"c",
				"sql",
				"lua",
	      "tsx",
	      "css",
	      "html",
	      "json",
				"java",
				"json",
				"yaml",
				"bash",
        "latex",
        "bibtex",
				"python",
				"markdown",
				"gitignore",
				"dockerfile",
        "javascript",
	      "typescript",
			},
			fold = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			highlight = { enable = true },
		})

	end,
}
