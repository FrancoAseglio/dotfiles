vim.g.mapleader = " " --set leader key to 'space'
local map = vim.keymap.set

-- Terminal
local state = { buf = -1, win = -1 }
local function float_term()
	local width  = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines   * 0.8)
	local col = math.floor((vim.o.columns - width)  / 2)
	local row = math.floor((vim.o.lines   - height) / 2)

	-- If window is open, close it
	if state.win > 0 and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = -1
		return
	end

	-- Create/reuse buffer
	if state.buf <= 0 or not vim.api.nvim_buf_is_valid(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true)
	end

	-- Open floating window
	state.win = vim.api.nvim_open_win(state.buf, true, {
		col      = col,
		row      = row,
		width    = width,
		height   = height,
		border   = "rounded",
		relative = "editor",
	})

	-- Start terminal if not already
	if vim.bo[state.buf].buftype ~= "terminal" then
	  vim.cmd.terminal()
  end

  vim.cmd.startinsert()
end

-- HTML trigger
local function html_open()
	local filepath = vim.api.nvim_buf_get_name(0)
	if vim.fn.fnamemodify(filepath, ":e") == "html" then
		vim.fn.system(string.format("open %s", filepath))
	else
		print("Current file is not an HTML file.")
	end
end

-- Default
map("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit Neovim" })
map("n", "<leader>k", ":q!<CR>", { desc = "Quit no saving" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Utils
map("n", "<leader>gc", ":lua vim.cmd('cd ~/.config/nvim'); print(vim.fn.getcwd())<CR>")
map("n", "<leader>sb", ":source %<CR>", { desc = "Source current file" })
map("n", "<leader>zc", ":set foldmethod=expr<CR>")
map("n", "<leader>mm", "@m", { desc = "Toggles @m macro" })
map("n", "<leader>hc", ":noh<CR>", { desc = "Clean buffer search result" })
map({ "n", "t" }, "<leader>tt", function() float_term() end)
map("n", "<leader>hh", function() html_open() end)
