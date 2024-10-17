local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.enable_wayland = false

config.color_scheme = "nord"
config.font = wezterm.font("GeistMono Nerd Font Mono")

config.enable_tab_bar = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "CTRL", action = wezterm.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "CTRL", action = wezterm.action({ SendString = "\x1bf" }) },
	{ key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },
}

return config
