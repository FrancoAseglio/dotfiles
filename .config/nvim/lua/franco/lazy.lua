-- Set the path to install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Automatically clone lazy.nvim if it's not already installed
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- use the latest stable release
		lazypath,
	})
end

-- Prepend lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Set up lazy.nvim with plugin imports
require("lazy").setup({
	{ import = "franco.plugins" }, -- General plugins (UI, editing, etc.)
	{ import = "franco.plugins.lsp" }, -- LSP-related plugins
}, {
	-- Enable automatic update checking (disabled notifications)
	checker = {
		enabled = true,
		notify = false,
	},

	-- Disable notifications when changing config files
	change_detection = {
		notify = false,
	},
})
