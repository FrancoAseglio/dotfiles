-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- tabs management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew <CR>", { desc = "Open current buffer in new tab" })

-- exit remap
keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
