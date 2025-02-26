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
		vim.api.nvim_set_hl(0, "AlphaSystem", { fg = "#B0BEC5" }) -- Gray for system info
		vim.api.nvim_set_hl(0, "AlphaQuote", { fg = "#A5D6A7" }) -- Light green for quote

		-- Safe command execution function
		local function capture(cmd)
			local handle = io.popen(cmd)
			if not handle then
				return "N/A"
			end
			local result = handle:read("*a")
			handle:close()
			return result:gsub("\n$", "")
		end

		-- System Informations Function
		local function get_system_info()
			local os_name = capture("sw_vers -productName")
			local os_version = capture("sw_vers -productVersion")
			local cpu = capture("sysctl -n machdep.cpu.brand_string"):gsub("%(R%)", ""):gsub("%(TM%)", "")
			local memory = capture("system_profiler SPHardwareDataType | grep Memory | awk '{print $2, $3}'")
			local storage = capture('df -h / | awk \'NR==2 {print $3"/"$2" ("$5")"}\'')
			local hostname = capture("hostname")
			local uptime = capture("uptime | awk '{print $3, $4}'"):gsub(",", "")
			local shell = os.getenv("SHELL") or "unknown"
			local brew_packages = capture("brew list | wc -l | tr -d ' '")

			return {
				"╭────────────── System Infos ────────────╮",
				"  Hostname:  " .. hostname,
				"  OS:        " .. os_name .. " " .. os_version,
				"  Uptime:    " .. uptime,
				"  CPU:       " .. cpu,
				"  Memory:    " .. memory,
				"  Storage:   " .. storage,
				"  Shell:     " .. shell:gsub("/usr/local/bin/", ""),
				"  Packages:  " .. brew_packages .. " (Homebrew)",
				"╰────────────────────────────────────────╯",
			}
		end

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

		-- System info section
		dashboard.section.sys_info = {
			type = "text",
			val = get_system_info(),
			opts = {
				position = "center",
				hl = "AlphaSystem",
			},
		}

		-- Modified button function to use same color for icon and text
		local function custom_button(sc, txt, keybind)
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

		-- Set menu
		dashboard.section.buttons.val = {
			custom_button("SPC + ee", "  > File Explorer", "<cmd>NvimTreeToggle<CR>"),
			custom_button("SPC + ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
			custom_button("SPC + fs", "  > Live Grep", "<cmd>Telescope live_grep<CR>"),
			custom_button("SPC + wr", "󰁯  > Restore Session", "<cmd>SessionRestore<CR>"),
		}
		dashboard.section.buttons.opts.hl = "AlphaButtons"

		-- Create quote section
		dashboard.section.quote = {
			type = "text",
			val = {
				-- "❝ 우리가 바라는 모든 것이 사실이 아닐 수도 있지만 모든 것은 소원에서 시작해야 됩니다❝ ",
			},
			opts = {
				position = "center",
				hl = "AlphaQuote",
			},
		}

		-- Configure the layout
		local layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.sys_info,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 2 },
			dashboard.section.quote,
		}

		-- Set up the config
		dashboard.config = {
			layout = layout,
			opts = {
				margin = 5,
			},
		}

		alpha.setup(dashboard.config)
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}

-- header at:  https://texteditor.com/multiline-text-art/

--  "⣐⢕⢕⢕⢕⢕⢕⢕⢕⠅⢗⢕⢕⢕⢕⢕⢕⢕⠕⠕⢕⢕⢕⢕⢕⢕⢕⢕⢕",
--  "⢐⢕⢕⢕⢕⢕⣕⢕⢕⠕⠁⢕⢕⢕⢕⢕⢕⢕⢕⠅⡄⢕⢕⢕⢕⢕⢕⢕⢕⢕",
--  "⢕⢕⢕⢕⢕⠅⢗⢕⠕⣠⠄⣗⢕⢕⠕⢕⢕⢕⠕⢠⣿⠐⢕⢕⢕⠑⢕⢕⠵⢕",
--  "⢕⢕⢕⢕⠁⢜⠕⢁⣴⣿⡇⢓⢕⢵⢐⢕⢕⠕⢁⣾⢿⣧⠑⢕⢕⠄⢑⢕⠅⢕",
--  "⢕⢕⠵⢁⠔⢁⣤⣤⣶⣶⣶⡐⣕⢽⠐⢕⠕⣡⣾⣶⣶⣶⣤⡁⢓⢕⠄⢑⢅⢑",
--  "⠍⣧⠄⣶⣾⣿⣿⣿⣿⣿⣿⣷⣔⢕⢄⢡⣾⣿⣿⣿⣿⣿⣿⣿⣦⡑⢕⢤⠱⢐",
--  "⢠⢕⠅⣾⣿⠋⢿⣿⣿⣿⠉⣿⣿⣷⣦⣶⣽⣿⣿⠈⣿⣿⣿⣿⠏⢹⣷⣷⡅⢐",
--  "⣔⢕⢥⢻⣿⡀⠈⠛⠛⠁⢠⣿⣿⣿⣿⣿⣿⣿⣿⡀⠈⠛⠛⠁⠄⣼⣿⣿⡇⢔",
--  "⢕⢕⢽⢸⢟⢟⢖⢖⢤⣶⡟⢻⣿⡿⠻⣿⣿⡟⢀⣿⣦⢤⢤⢔⢞⢿⢿⣿⠁⢕",
--  "⢕⢕⠅⣐⢕⢕⢕⢕⢕⣿⣿⡄⠛⢀⣦⠈⠛⢁⣼⣿⢗⢕⢕⢕⢕⢕⢕⡏⣘⢕",
--  "⢕⢕⠅⢓⣕⣕⣕⣕⣵⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣷⣕⢕⢕⢕⢕⡵⢀⢕⢕",
--  "⢑⢕⠃⡈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢃⢕⢕⢕",
--  "⣆⢕⠄⢱⣄⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢁⢕⢕⠕⢁",
--  "⣿⣦⡀⣿⣿⣷⣶⣬⣍⣛⣛⣛⡛⠿⠿⠿⠛⠛⢛⣛⣉⣭⣤⣂⢜⠕⢑⣡⣴⣿",

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

--      "██╗████████╗ █╗ ███████╗     █████╗          ██╗ █████╗ ██╗   ██╗",
-- 			"██║╚══██╔══╝ ╚╝ ██╔════╝    ██╔══██╗         ██║██╔══██╗██║   ██║",
-- 			"██║   ██║       ███████╗    ███████║         ██║███████║██║   ██║",
-- 			"██║   ██║       ╚════██║    ██╔══██║    ██   ██║██╔══██║╚██╗ ██╔╝",
-- 			"██║   ██║       ███████║    ██║  ██║    ╚█████╔╝██║  ██║ ╚████╔╝ ",
-- 			"╚═╝   ╚═╝       ╚══════╝    ╚═╝  ╚═╝     ╚════╝ ╚═╝  ╚═╝  ╚═══╝  ",
-- 			"                                                                 ",
-- 			"                         ██╗       █████╗ ",
-- 			"                         ██║      ██╔══██╗",
-- 			"                      ████████╗   ███████║",
-- 			"                         ██╔══╝   ██╔══██║",
-- 			"                         ██║      ██║  ██║",
-- 			"                         ╚═╝      ╚═╝  ╚═╝",
