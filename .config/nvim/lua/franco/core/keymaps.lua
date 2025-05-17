vim.g.mapleader = " " --set leader key to space

-- Default
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit Neovim" })
vim.keymap.set("n", "<leader>k", ":q!<CR>", { desc = "Quit no saving" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Windows
vim.keymap.set("n", "wh", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "wl", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "wj", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "wk", "<C-w>k", { desc = "Move to upper window" })

-- Tabs
vim.keymap.set("n", "to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- Utils
vim.keymap.set("n", "<leader>ss", ":source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader>zc", ":set foldmethod=expr<CR>", { desc = "Enable expr fold" })
vim.keymap.set("n", "<leader>mm", "@m", { desc = "Toggles @m macro" })
vim.keymap.set("n", "<leader>hs", "/", { desc = "Toggles search" })
vim.keymap.set("n", "<leader>hc", ":noh<CR>", { desc = "Cleans buffer search" })
vim.keymap.set("n", "<leader>la", ":Lazy<CR>", { desc = "Toggle Lazy" })
vim.keymap.set("n", "<leader>ma", ":Mason<CR>", { desc = "Toggle Mason" })
vim.keymap.set("n", "<leader>dd", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })
vim.keymap.set("n", "<leader>gc", ":lua vim.cmd('cd ~/.config/nvim'); print(vim.fn.getcwd())<CR>")
vim.keymap.set("n", "<leader>gh", ":lua vim.cmd('cd'); print(vim.fn.getcwd())<CR>")
