vim.g.mapleader = " " --set leader key to 'space'

-- Default
vim.keymap.set("n", "<leader>w", ":w<CR>",  { desc = "Save current file" })
vim.keymap.set("n", "<leader>q", ":q<CR>",  { desc = "Quit Neovim" })
vim.keymap.set("n", "<leader>k", ":q!<CR>", { desc = "Quit no saving" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Windows
vim.keymap.set("n", "wh", "<C-w>h", { desc = "Move to left  window" })
vim.keymap.set("n", "wl", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "wj", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "wk", "<C-w>k", { desc = "Move to upper window" })

-- Dir navigation
vim.keymap.set("n", "<leader>gc", ":lua vim.cmd('cd ~/.config/nvim'); print(vim.fn.getcwd())<CR>")
vim.keymap.set("n", "gh", ":lua vim.cmd('cd'); print(vim.fn.getcwd())<CR>")
vim.keymap.set("n", "gl", ":lua vim.cmd('cd ~/Downloads/'); print(vim.fn.getcwd())<CR>")
vim.keymap.set("n", "gd", ":lua vim.cmd('cd ~/Desktop/'); print(vim.fn.getcwd())<CR>")

-- Utils
vim.keymap.set("n", "<leader>sb", ":source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader>zc", ":set foldmethod=expr<CR>", { desc = "Enable expr fold" })
vim.keymap.set("n", "<leader>mm", "@m", { desc = "Toggles @m macro" })
vim.keymap.set("n", "<leader>hc", ":noh<CR>", { desc = "Clean buffer result" })
vim.keymap.set("n", "<leader>la", ":Lazy<CR>", { desc = "Toggle Lazy" })
vim.keymap.set("n", "<leader>ma", ":Mason<CR>", { desc = "Toggle Mason" })
vim.keymap.set("n", "<leader>nf", function()
	local ok, filename = pcall(vim.fn.input, "New file: ")

  if not ok or filename == "" then
		return
	end

  vim.cmd("edit " .. filename)
end, { desc = "Edit new file in cwd" })

-- Quickfix List
vim.keymap.set("n", "<leader>fl", function()

  for _, win in pairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			return vim.cmd("cclose")
		end
	end

  vim.cmd("copen")
end, { desc = "Toggle quickfix" })

vim.keymap.set("n", "fd", function()
	if vim.bo.filetype ~= "qf" then
		return print("Not in quickfix window")
	end

	local current_line = vim.fn.line(".")
	local qflist = vim.fn.getqflist()

	if current_line <= #qflist then
		table.remove(qflist, current_line)
		vim.fn.setqflist(qflist)
		vim.fn.cursor(math.min(current_line, #qflist), 1)
	end
end, { desc = "Remove quickfix entry under cursor" })

vim.keymap.set("n", "fj", "<cmd>:cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "fk", "<cmd>:cprev<CR>", { desc = "Prev quickfix item" })

-- Terminal
local state = { buf = -1, win = -1 }
local function floating_terminal()
  local width  = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines   * 0.8)
  local col = math.floor((vim.o.columns - width)  / 2)
  local row = math.floor((vim.o.lines   - height) / 2)

	-- If window is open, close it
	if state.win > 0 and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = -1
		return
	end

	-- Create or reuse buffer
	if state.buf <= 0 or not vim.api.nvim_buf_is_valid(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true)
	end

  -- Open floating window
	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width  = width,
		height = height,
		col = col,
		row = row,
    border = "rounded",
	})

	-- Start terminal if not already
	if vim.bo[state.buf].buftype ~= "terminal" then
		vim.cmd.terminal()
	end

	vim.cmd.startinsert()
end

vim.keymap.set({ "n", "t" }, "<leader>tt", floating_terminal)
