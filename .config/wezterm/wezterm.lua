local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Rose Pine Moon'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 15.0
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true

return config
