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
			vim.g.db_ui_save_location = "~/db" -- reference dir as for datasets
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

-- Output Format
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dbout",
	callback = function()
		local ns = vim.api.nvim_create_namespace("dbout_full_lines")
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

		vim.api.nvim_set_hl(0, "DBError", { fg = "#ff8a8a" })
		vim.api.nvim_set_hl(0, "DBTableHeader", { fg = "#00ff87", bold = true })
		vim.api.nvim_set_hl(0, "DBTableText", { fg = "#ffffff", italic = true })
		vim.api.nvim_set_hl(0, "DBTableBorder", { fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "DBRowEven", { bg = "#1b3550" })
		vim.api.nvim_set_hl(0, "DBRowOdd", { bg = "#14283c" })
		vim.api.nvim_set_hl(0, "DBRowCount", { fg = "#87cefa", bold = true })

		local total_lines = vim.api.nvim_buf_line_count(0)
		local row_count_line = nil
		local error_lines = {}

		-- First pass: find row count line and identify error lines
		for i = 1, total_lines do
			local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
			if line:match("%(.*rows%)") then
				row_count_line = i
			end

			-- Mark error lines
			if line:match("ERROR:") then
				error_lines[i] = true
				vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
					hl_group = "DBError",
					end_line = i,
					hl_eol = true,
					priority = 200,
				})
			end
		end

		-- Apply background highlighting for rows
		for i = 1, total_lines do
			if not error_lines[i] then
				local bg_hl = (i % 2 == 0) and "DBRowEven" or "DBRowOdd"
				vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
					hl_group = bg_hl,
					end_line = i,
					hl_eol = true,
				})
			end
		end

		-- Apply text highlighting per line
		for i = 1, total_lines do
			if error_lines[i] then
				goto continue
			end

			if i == row_count_line then
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
							priority = 100,
						})
					end

					pos = pos + 1
				end
			end

			::continue::
		end
	end,
})

-- Run autocommands when file is loaded
setup_autocommands()

return plugins
