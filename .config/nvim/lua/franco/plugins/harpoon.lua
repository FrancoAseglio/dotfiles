return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		local list = harpoon:list()
		local ui = harpoon.ui

		-- Initialize harpoon
		harpoon:setup()

		-- for concisensess
		local keymap = vim.keymap.set

		keymap("n", "<leader>a", function()
			list:add()
		end, { desc = "Add to Harpoon" })
		keymap("n", "<leader>o", function()
			ui:toggle_quick_menu(list)
		end, { desc = "Toggle menu" })

		-- Navigate to specific file slots
		for i = 1, 4 do
			keymap("n", "<leader>" .. i, function()
				list:select(i)
			end, { desc = "Harpoon file " .. i })
		end
	end,
}
