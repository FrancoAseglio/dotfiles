local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "franco.plugins.editor" },
	{ import = "franco.plugins.ui" },
	{ import = "franco.plugins.lsp" },
	{ import = "franco.plugins.tools" },
	{ import = "franco.plugins.lang" },
	-- { import = "franco.plugins.extra" },
	-- { import = "franco.plugins.dap" },
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	ui = {
		border = "rounded",
		title_pos = "center",
	},
})

vim.keymap.set("n", "<leader>la", "<cmd>Lazy<CR>", { desc = "Toggle Lazy" })
