local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.native_macos_fullscreen_mode = true -- this means you lose the pretty opacity
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

config.colors = {
  selection_bg = "#ea9a97",
  selection_fg = "#232136",
  copy_mode_active_highlight_bg = { Color = "#ea9a97" },
  copy_mode_active_highlight_fg = { Color = "#232136" },
  copy_mode_inactive_highlight_bg = { Color = "#3e8fb0" },
  copy_mode_inactive_highlight_fg = { Color = "#e0def4" },
}

return config
