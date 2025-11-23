return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local function harpoon_component()
			local ok, harpoon = pcall(require, "harpoon")

			if not ok then
				return ""
			end

			local current_file = vim.loop.fs_realpath(vim.fn.expand("%:p"))
			local list = harpoon:list()
			local items = list.items or {}
			local current_index = nil

			for i, item in ipairs(items) do
				local item_path = vim.loop.fs_realpath(item.value)

				if item_path == current_file then
					current_index = i
					break
				end
			end

			if current_index then
				return string.format("󰛢 %d/%d", current_index, #items)
			elseif #items > 0 then
				return string.format("󰛢 -/%d", #items)
			else
				return ""
			end
		end

		require("lualine").setup({
			options = {
				theme = "catppuccin",
			},
			sections = {
				lualine_x = {
					{
						function()
							return require("lazy.status").updates()
						end,

						cond = function()
							return require("lazy.status").has_updates()
						end,

						color = { fg = "#ff9e64" },
					},
					harpoon_component,
					"encoding",
				},
			},
		})

	end,
}
