return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		local map = vim.keymap.set
		local harpoon = require("harpoon")

		harpoon:setup()

		map("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Add to Harpoon" })

		map("n", "<leader>o", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle menu" })

		-- Files Navigation
		for i = 1, 9 do
			map("n", "<leader>" .. i, function()
				harpoon:list():select(i)
			end, { desc = "Harpoon file " .. i })
		end

	end,
}
