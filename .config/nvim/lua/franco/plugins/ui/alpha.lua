return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local function get_header_padding()
			local header_height = 16
			local win_height = vim.fn.winheight(0)
			local padding = math.max(0, math.floor((win_height - header_height) / 2) - 2)
			local pad_lines = {}

			for _ = 1, padding do
				table.insert(pad_lines, "")
			end

			return pad_lines
		end

		local header = {
			"                                NVRMND v09/11",
			"",
			"               Nvim Diesel is a mythological figure you can discover",
			"                            https://neovim.io/#chat",
			"",
			"    press SPC + q                 TO QUIT. We've all been through this",
			"",
			"    type  :help nvim<Enter>       if you are new, do not type <Enter> though",
			"    type  :checkhealth<Enter>     to optimize 'Fast & Furious' gaslighting",
			"    type  :help<Enter>            why would you even consider asking",
			"",
			"    type  :help news<Enter>       to try moving on from 09/11",
			"",
			"                          Help poor Francos at UniTo!",
			"                         email: ABGsWinItAll@yahoo.tnx",
		}

		-- Padding
		local function get_full_header()
			local padding = get_header_padding()
			local full_header = {}

			for _, line in ipairs(padding) do
				table.insert(full_header, line)
			end

			for _, line in ipairs(header) do
				table.insert(full_header, line)
			end

			return full_header
		end

		dashboard.section.header.val = get_full_header()
		dashboard.section.buttons.val = {}

		-- Setup
		alpha.setup(dashboard.opts)

		-- Window resize
		vim.api.nvim_create_autocmd("VimResized", {
			callback = function()
				if vim.bo.filetype == "alpha" then
					dashboard.section.header.val = get_full_header()
					alpha.redraw()
				end
			end,
		})
	end,

	keys = {
		{
			"<leader><leader>",
			function()
				local alpha_available, alpha = pcall(require, "alpha")

				if not alpha_available then
					return
				end

				if vim.bo.filetype == "alpha" then
					print("./")
				else
					alpha.start()
				end
			end,
			desc = "Toggle Alpha",
		},
	},
}
