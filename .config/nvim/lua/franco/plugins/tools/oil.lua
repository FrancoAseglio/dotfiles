return {
	"stevearc/oil.nvim",
	opts = {
		experimental_watch_for_changes = false,
  },
	dependencies = {
		{ "echasnovski/mini.icons", opts = {} },
	},
	lazy = false,

  init = function()
		vim.keymap.set("n", "<leader>fe", "<CMD>Oil<CR>", { desc = "Open oil" })

		vim.keymap.set("n", "<leader>hf", function()
			local ok, oil = pcall(require, "oil.actions")

      if ok then
				oil.toggle_hidden.callback()
			end
		end, { desc = "Toggle hidden files" })

	end,
}
