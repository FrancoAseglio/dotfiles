--set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit Neovim" })
keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Save and quit" })
keymap.set("n", "<leader>fk", ":q!<CR>", { desc = "Force quit without saving" })

-- Exit Insert
keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

-- Splits Management
keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to right window" })
keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to lower window" })
keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to upper window" })

-- Tabs Management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- Lazy
keymap.set("n", "<leader>ll", function()
	vim.cmd("Lazy")
end, { desc = "Open Lazy plugin manager" })

-- Mason
keymap.set("n", "<leader>mm", ":Mason<CR>", { desc = "Open Mason", silent = true })

-- DBUI
keymap.set("n", "<leader>du", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })

-- .config/nvim
keymap.set("n", "<leader>cc", function()
	vim.cmd("cd ~/.config/nvim")
	vim.cmd("NvimTreeToggle")
end, { desc = "Navigate to Neovim config directory" })
