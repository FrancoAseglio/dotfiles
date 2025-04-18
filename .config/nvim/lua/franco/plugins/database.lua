-- Autocommands for UI and DBUI functionality
local function setup_autocommands()
	-- Message Area Colors
	vim.api.nvim_create_autocmd("UIEnter", {
		once = true,
		callback = function()
			vim.defer_fn(function()
				vim.api.nvim_set_hl(0, "MsgArea", { bg = "NONE" })
				vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
			end, 100)
		end,
	})

	-- DBUI Output Resize
	vim.api.nvim_create_autocmd("BufWinEnter", {
		callback = function()
			if vim.bo.filetype == "dbout" then
				vim.cmd("resize 30")
			end
		end,
	})
end

-- Plugin Specifications
local plugins = {
	{
		"tpope/vim-dadbod",
		lazy = true,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = { "DBUI", "DBUIToggle", "DBUIFindBuffer", "DBUIRenameBuffer" },
		dependencies = { "tpope/vim-dadbod" },
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

-- Run autocommands when file is loaded
setup_autocommands()

return plugins
