-- Configuration Obj
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Disable Confirmation Prompt
config.window_close_confirmation = "NeverPrompt"

-- Font Settings
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

-- Window Appearance
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95

-- Alt Key Behavior
config.send_composed_key_when_left_alt_is_pressed  = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Keybindings
config.keys = {
	{ key = "5", mods = "ALT", action = wezterm.action.SendString("~") },
}

-- Color Scheme
config.color_scheme = "Catppuccin Mocha"

-- Cursor Appearance (SteadyBar - SteadyUnderline - SteadyBlock)
config.default_cursor_style = "SteadyBar"

return config
