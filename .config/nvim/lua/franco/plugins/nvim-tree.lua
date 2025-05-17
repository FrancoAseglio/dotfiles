return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
			},
			filters = {
				dotfiles = true,
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
		})

		vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
	end,
}
