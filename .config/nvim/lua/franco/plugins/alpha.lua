return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set colors from starship palette
		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#FFCC80" }) -- Light orange for header
		vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#80DEEA" }) -- Cyan for buttons and icons
		vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#80DEEA" }) -- Cyan for shortcuts

		-- Keep your existing header
		dashboard.section.header.val = {
			"██╗████████╗ █╗ ███████╗          ██╗ █████╗ ██╗   ██╗      ██╗       █████╗ ",
			"██║╚══██╔══╝ ╚╝ ██╔════╝          ██║██╔══██╗██║   ██║      ██║      ██╔══██╗",
			"██║   ██║       ███████╗          ██║███████║██║   ██║   ████████╗   ███████║",
			"██║   ██║       ╚════██║     ██   ██║██╔══██║╚██╗ ██╔╝      ██╔══╝   ██╔══██║",
			"██║   ██║       ███████║     ╚█████╔╝██║  ██║ ╚████╔╝       ██║      ██║  ██║",
			"╚═╝   ╚═╝       ╚══════╝      ╚════╝ ╚═╝  ╚═╝  ╚═══╝        ╚═╝      ╚═╝  ╚═╝",
			"                                                                            ",
			"                        ⣐⢕⢕⢕⢕⢕⢕⢕⢕⠅⢗⢕⢕⢕⢕⢕⢕⢕⠕⠕⢕⢕⢕⢕⢕⢕⢕⢕  ",
			"                       ⢐⢕⢕⢕⢕⢕⣕⢕⢕⠕⠁⢕⢕⢕⢕⢕⢕⢕⢕⠅⡄⢕⢕⢕⢕⢕⢕⢕⢕⢕ ",
			"                       ⢕⢕⢕⢕⠅⢗⢕⠕⣠⠄⣗⢕⢕⠕⢕⢕⢕⠕⢠⣿⠐⢕⢕⢕⠑⢕⢕⠵⢕  ",
			"                      ⢐⢕⢕⢕⢕⠁⢜⠕⢁⣴⣿⡇⢓⢕⢵⢐⢕⢕⠕⢁⣾⢿⣧⠑⢕⢕⠄⢑⢕⠅⢕ ",
			"                      ⣘⢕⢕⠵⢁⠔⢁⣤⣤⣶⣶⣶⡐⣕⢽⠐⢕⠕⣡⣾⣶⣶⣶⣤⡁⢓⢕⠄⢑⢅⢑ ",
			"                      ⢕⠍⣧⠄⣶⣾⣿⣿⣿⣿⣿⣿⣷⣔⢕⢄⢡⣾⣿⣿⣿⣿⣿⣿⣿⣦⡑⢕⢤⠱⢐ ",
			"                      ⢕⢠⢕⠅⣾⣿⠋⢿⣿⣿⣿⠉⣿⣿⣷⣦⣶⣽⣿⣿⠈⣿⣿⣿⣿⠏⢹⣷⣷⡅⢐ ",
			"                      ⢕⣔⢕⢥⢻⣿⡀⠈⠛⠛⠁⢠⣿⣿⣿⣿⣿⣿⣿⣿⡀⠈⠛⠛⠁ ⣼⣿⣿⡇⢔ ",
			"                      ⢕⢕⢕⢽⢸⢟⢟⢖⢖⢤⣶⡟⢻⣿⡿⠻⣿⣿⡟⢀⣿⣦⢤⢤⢔⢞⢿⢿⣿⠁⢕ ",
			"                      ⢕⢕⢕⠅⣐⢕⢕⢕⢕⢕⣿⣿⡄⠛⢀⣦⠈⠛⢁⣼⣿⢗⢕⢕⢕⢕⢕⢕⡏⣘⢕ ",
			"                      ⢕⢕⢕⠅⢓⣕⣕⣕⣕⣵⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣷⣕⢕⢕⢕⢕⡵⢀⢕⢕ ",
			"                      ⢕⢑⢕⠃⡈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢃⢕⢕⢕ ",
			"                      ⢕⣆⢕⠄⢱⣄⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢁⢕⢕⠕⢁  ",
			"                      ⢕⣿⣦⡀⣿⣿⣷⣶⣬⣍⣛⣛⣛⡛⠿⠿⠿⠛⠛⢛⣛⣉⣭⣤⣂⢜⠕⢑⣡⣴⣿ ",
		}

		dashboard.section.header.opts.hl = "AlphaHeader"

		-- Function to get the config directory path reliably
		local function get_config_path()
			-- Try to get the path in a cross-platform way
			local config_path = vim.fn.stdpath("config")
			if config_path then
				return config_path
			else
				-- Fallback to the common path
				return "~/.config/nvim"
			end
		end

		-- Get the config path
		local nvim_config_path = get_config_path()

		-- Custom function for buttons that directly executes commands

		local function create_button(sc, txt, keybind)
			local opts = {
				position = "center",
				text = txt,
				shortcut = sc,
				cursor = 3,
				width = 50,
				align_shortcut = "right",
				hl = "AlphaButtons",
				hl_shortcut = "AlphaShortcut",
			}

			return {
				type = "button",
				val = txt,
				on_press = function()
					local key = vim.api.nvim_replace_termcodes(keybind, true, false, true)
					vim.api.nvim_feedkeys(key, "normal", false)
				end,
				opts = opts,
			}
		end

		-- Set menu with direct command execution
		dashboard.section.buttons.val = {
			create_button("SPC + ee", "  > File Explorer", "<cmd>NvimTreeToggle<CR>"),
			create_button("SPC + ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
			create_button("SPC + fs", "  > Live Grep", "<cmd>Telescope live_grep<CR>"),
			create_button("SPC + wr", "󰁯  > Restore Session", "<cmd>SessionRestore<CR>"),
			create_button("SPC + cc", "  > Config/nvim", ""),
			create_button("SPC + ll", "󰒲  > Lazy Package Manager", "Lazy"),
		}
		dashboard.section.buttons.opts.hl = "AlphaButtons"

		-- Configure the layout without system info and quotes
		local layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
		}

		-- Set up the config
		dashboard.config = {
			layout = layout,
			opts = {
				margin = 5,
			},
		}

		-- Define keymaps for when alpha is loaded
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.keymap.set("n", "cc", function()
					vim.cmd("cd " .. nvim_config_path)
					vim.cmd("NvimTreeToggle")
				end, { buffer = true, silent = true })

				vim.keymap.set("n", "l", ":Lazy<CR>", { buffer = true, silent = true })
			end,
		})

		vim.defer_fn(function()
			alpha.setup(dashboard.config)
		end, 0)

		alpha.setup(dashboard.config)
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}

-- header at:  https://texteditor.com/multiline-text-art/

--    "          ▀████▀▄▄              ▄█ ",
--    "            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ",
--    "    ▄        █          ▀▀▀▀▄  ▄▀  ",
--    "   ▄▀ ▀▄      ▀▄              ▀▄▀  ",
--    "  ▄▀    █     █▀   ▄█▀▄      ▄█    ",
--    "  ▀▄     ▀▄  █     ▀██▀     ██▄█   ",
--    "   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ",
--    "    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ",
--    "   █   █  █      ▄▄           ▄▀   ",

-- " ███████╗███████╗ ██████╗ ███╗   ███╗███████╗███╗   ██╗████████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗",
-- " ██╔════╝██╔════╝██╔════╝ ████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║",
-- " ███████╗█████╗  ██║  ███╗██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████║   ██║   ██║██║   ██║██╔██╗ ██║",
-- " ╚════██║██╔══╝  ██║   ██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║",
-- " ███████║███████╗╚██████╔╝██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║",
-- " ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝",
-- "											                                                                                  ",
-- "            ██╗   ██╗ ██████╗ ██╗   ██╗██████╗      ███████╗ █████╗ ██╗   ██╗██╗  ████████╗            ",
-- "            ╚██╗ ██╔╝██╔═══██╗██║   ██║██╔══██╗     ██╔════╝██╔══██╗██║   ██║██║  ╚══██╔══╝            ",
-- "             ╚████╔╝ ██║   ██║██║   ██║██████╔╝     █████╗  ███████║██║   ██║██║     ██║               ",
-- "              ╚██╔╝  ██║   ██║██║   ██║██╔══██╗     ██╔══╝  ██╔══██║██║   ██║██║     ██║               ",
-- "               ██║   ╚██████╔╝╚██████╔╝██║  ██║     ██║     ██║  ██║╚██████╔╝███████╗██║               ",
-- "               ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝     ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝               ",
