local wezterm = require("wezterm")

-- Create configuration object
local config = wezterm.config_builder()

-- Disable Confirmation Prompt
config.window_close_confirmation = "NeverPrompt"

-- Font settings
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

-- Window appearance
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.70
config.macos_window_background_blur = 5
-- config.window_background_image = ""

-- Alt key behavior
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Key bindings
config.keys = {
	{ key = "5", mods = "ALT", action = wezterm.action.SendString("~") },
}

-- Color scheme
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

-- Cursor appearance SteadyBar" / "SteadyUnderline" / "SteadyBlock" --
config.default_cursor_style = "SteadyBar"
return config
