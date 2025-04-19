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

-- Output Format
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dbout",
	callback = function()
		local ns = vim.api.nvim_create_namespace("dbout_full_lines")
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

		-- Define highlight groups with more transparent backgrounds
		vim.api.nvim_set_hl(0, "DBTableHeader", { fg = "#00ff87", bold = true }) -- table text in green
		vim.api.nvim_set_hl(0, "DBTableText", { fg = "#ffffff", italic = true }) -- table text in white
		vim.api.nvim_set_hl(0, "DBTableBorder", { fg = "#ffffff", bold = true }) -- borders and separators in bold white
		vim.api.nvim_set_hl(0, "DBRowEven", { bg = "#1b3550" }) -- even line background
		vim.api.nvim_set_hl(0, "DBRowOdd", { bg = "#14283c" }) -- odd line background
		vim.api.nvim_set_hl(0, "DBRowCount", { fg = "#87cefa", bold = true }) -- row count in light blue

		local total_lines = vim.api.nvim_buf_line_count(0)
		local row_count_line = nil

		-- Find the row count line (usually the line after the table)
		for i = 1, total_lines do
			local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
			if line:match("%(.*rows%)") then
				row_count_line = i
				break
			end
		end

		-- Apply background highlighting for rows (including row count line)
		for i = 1, total_lines do
			local bg_hl = (i % 2 == 0) and "DBRowEven" or "DBRowOdd"
			vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
				hl_group = bg_hl,
				end_line = i,
				hl_eol = true,
			})
		end

		-- Apply text highlighting per line
		for i = 1, total_lines do
			if i == row_count_line then
				-- Highlight the text of row count line (preserving the background)
				local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
				vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
					hl_group = "DBRowCount",
					end_col = #line,
					priority = 100,
				})
			else
				local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

				-- Process each character in the line
				local pos = 0
				while pos < #line do
					local start_pos = pos
					local char = line:sub(pos + 1, pos + 1)

					local hl_group
					if char == "|" or char == "-" or char == "+" then
						hl_group = "DBTableBorder" -- Border characters
					elseif i == 1 then
						hl_group = "DBTableHeader" -- Header text
					else
						hl_group = "DBTableText" -- Regular text
					end

					-- Apply highlight to the character
					if hl_group then
						vim.api.nvim_buf_set_extmark(0, ns, i - 1, start_pos, {
							hl_group = hl_group,
							end_col = start_pos + 1,
							priority = 100, -- Higher priority to override background
						})
					end

					pos = pos + 1
				end
			end
		end
	end,
})

-- Run autocommands when file is loaded
setup_autocommands()

return plugins
