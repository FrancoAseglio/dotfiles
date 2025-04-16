return {
	{
		"tpope/vim-dadbod",
		lazy = true,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = { "DBUI", "DBUIToggle", "DBUIFindBuffer", "DBUIRenameBuffer" },
		dependencies = {
			"tpope/vim-dadbod",
		},
		config = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_save_location = "~/.config/nvim/db_ui_queries"
		end,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		ft = { "sql", "mysql", "plsql" },
		dependencies = {
			"hrsh7th/nvim-cmp",
			"tpope/vim-dadbod",
		},
		config = function()
			require("cmp").setup.buffer({
				sources = {
					{ name = "vim-dadbod-completion" },
				},
			})
		end,
	},
}
