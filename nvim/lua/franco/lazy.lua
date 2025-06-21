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
	-- franco/plugins/extra/ won't be loaded
	{ import = "franco.plugins" },
	{ import = "franco.plugins.lsp" },
	{ import = "franco.plugins.dap" },
}, {
	checker = {
		enabled = true,
		notify  = false,
	},
	change_detection = {
		notify = false,
	},
	ui = {
		border = "rounded",
		title_pos = "center",
	},
})
