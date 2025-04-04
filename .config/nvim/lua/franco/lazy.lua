local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{ import = "franco.plugins" },
	{ import = "franco.plugins.lsp" },
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"jay-babu/mason-nvim-dap.nvim",
			"nvim-neotest/nvim-nio",
		},
	},
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
