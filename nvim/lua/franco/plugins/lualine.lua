return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- Harpoon component
		local function harpoon_component()
			local harpoon = require("harpoon")
			local current_file = vim.fn.expand("%:p")

			-- Get list
			local list = harpoon:list()
			local items = list.items or {}

			-- Current file in list
			local current_index = nil
			for i, item in ipairs(items) do
				if item.value and vim.fn.fnamemodify(item.value, ":p") == current_file then
					current_index = i
					break
				end
			end

			-- Return indicator
			if current_index then
				return string.format("󰛢 %d/%d", current_index, #items)
			elseif #items > 0 then
				return string.format("󰛢 -/%d", #items)
			else
				return ""
			end
		end

		local colors = {
			blue = "#65D1FF",
			green = "#3EFFDC",
			violet = "#FF61EF",
			yellow = "#FFDA7B",
			red = "#FF4A4A",
			fg = "#c3ccdc",
			bg = "#112638",
			inactive_bg = "#2c3043",
		}
		local my_lualine_theme = {
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}
		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
			},
			sections = {
        lualine_c = {
					{
						"filename",
						path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						symbols = {
							modified = " ",
							readonly = " ",
							unnamed = "[No Name]",
						},
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					harpoon_component,
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
