vim.g.mapleader = " " --set leader key to space
local keymap = vim.keymap -- for conciseness

-- Default Remap
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit Neovim" })
keymap.set("n", "<leader>k", ":q!<CR>", { desc = "Quit without saving" })
keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Windows Management
keymap.set("n", "wh", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "wl", "<C-w>l", { desc = "Move to right window" })
keymap.set("n", "wj", "<C-w>j", { desc = "Move to lower window" })
keymap.set("n", "wk", "<C-w>k", { desc = "Move to upper window" })

-- Tabs Management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- Utils
keymap.set("n", "<leader>ss", ":source %<CR>", { desc = "Source current file" })
keymap.set("n", "<leader>zc", ":set foldmethod=expr<CR>", { desc = "Enable expr fold" })
keymap.set("n", "mm", "@m", { desc = "Toggles @m macro" })
keymap.set("n", "<leader>ll", ":Lazy<CR>", { desc = "Toggle Lazy" })
keymap.set("n", "<leader>mm", ":Mason<CR>", { desc = "Toggle Mason" })
keymap.set("n", "<leader>du", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })
keymap.set("n", "<leader>gc", ":lua vim.cmd('cd ~/.config/nvim'); print(vim.fn.getcwd())<CR>")
keymap.set("n", "<leader>gh", ":lua vim.cmd('cd'); print(vim.fn.getcwd())<CR>")
