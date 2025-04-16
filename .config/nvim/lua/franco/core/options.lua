vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- turn off swapfile
opt.swapfile = false

-- system clipboard as default register
opt.clipboard:append("unnamedplus")

-- sql commenting
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	callback = function()
		vim.opt_local.commentstring = "-- %s"
	end,
})

-- DBUI message area colors
vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		vim.defer_fn(function()
			vim.api.nvim_set_hl(0, "MsgArea", { bg = "NONE", fg = "white" })
			vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
		end, 100)
	end,
})

-- BDUI output resize
vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		if vim.bo.filetype == "dbout" then
			vim.cmd("resize 25")
		end
	end,
})
