local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.enable_wayland = false

config.color_scheme = 'Atom (Gogh)'
config.font = wezterm.font 'Fira Code'

config.enable_tab_bar = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

return config
