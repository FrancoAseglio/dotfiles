return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { "windwp/nvim-ts-autotag", },
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			sync_install = false,
			auto_install = true,

			ensure_installed = {
				"json", "javascript", "typescript", "tsx", "yaml", "html",
        "css", "prisma", "markdown", "markdown_inline", "svelte",
        "graphql", "bash", "lua", "vim", "dockerfile", "gitignore",
        "query", "vimdoc", "c", "sql", "java", "python",
			},

			highlight = { enable = true },
			indent    = { enable = true },
			autotag   = { enable = true },
			fold      = { enable = true },

			incremental_selection = {
				enable  = true,
				keymaps = {
					init_selection    = "<C-space>",
					node_incremental  = "<C-space>",
					scope_incremental = false,
					node_decremental  = "<bs>",
				},
			},
		})
	end,
}
