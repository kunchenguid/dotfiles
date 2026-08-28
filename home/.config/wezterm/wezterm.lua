local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

-- Simpler, layout-independent pane splits (iTerm2-style) alongside the stock defaults.
config.keys = {
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{
		key = "O",
		mods = "CMD|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			-- Explicit --pane-id because the background process doesn't inherit
			-- the WEZTERM_PANE env var that the CLI would otherwise rely on.
			wezterm.background_child_process({
				"wezterm",
				"cli",
				"move-pane-to-new-tab",
				"--pane-id",
				tostring(pane:pane_id()),
			})
		end),
	},
	-- Merge the tab to the left of the active one into the active pane as a split,
	-- e.g. with 6 and 7 open and 7 active, pulls 6 in to make one tab with two panes.
	{
		key = "M",
		mods = "CMD|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			local mux_window = window:mux_window()
			local tabs = mux_window:tabs_with_info()

			local active_index
			for i, t in ipairs(tabs) do
				if t.is_active then
					active_index = i
					break
				end
			end

			local prev_tab = tabs[active_index - 1]
			if not prev_tab then
				window:toast_notification("WezTerm", "No previous tab to merge with", nil, 2000)
				return
			end

			local other_pane_id
			for _, info in ipairs(prev_tab.tab:panes_with_info()) do
				if info.is_active then
					other_pane_id = info.pane:pane_id()
				end
			end

			-- Same --pane-id workaround as the move-pane-to-new-tab binding above:
			-- background_child_process doesn't inherit WEZTERM_PANE.
			wezterm.background_child_process({
				"wezterm",
				"cli",
				"split-pane",
				"--pane-id",
				tostring(pane:pane_id()),
				"--move-pane-id",
				tostring(other_pane_id),
				"--horizontal",
			})
		end),
	},
	-- Reorder the active tab one position left/right, e.g. to pull tab 7 to position 1.
	{ key = "LeftArrow", mods = "CMD|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "CMD|SHIFT", action = wezterm.action.MoveTabRelative(1) },
	-- Resize the active pane. ALT is the Option key on macOS.
	{ key = "LeftArrow", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
	{ key = "UpArrow", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
	-- One-shot copy of the entire scrollback (not just the current viewport) to the clipboard,
	-- so there's no need to manually drive Copy Mode's g / Shift+V / Shift+G / y sequence.
	{
		key = "C",
		mods = "CMD|SHIFT",
		action = wezterm.action.Multiple({
			wezterm.action.ActivateCopyMode,
			wezterm.action.CopyMode("MoveToScrollbackTop"),
			wezterm.action.CopyMode({ SetSelectionMode = "Line" }),
			wezterm.action.CopyMode("MoveToScrollbackBottom"),
			wezterm.action.CopyTo("Clipboard"),
			wezterm.action.CopyMode("Close"),
		}),
	},
}

-- Dim unfocused windows so the focused one is obvious at a glance.
local UNFOCUSED_FOREGROUND_TEXT_HSB = { hue = 1.0, saturation = 0.25, brightness = 0.45 }
local UNFOCUSED_WINDOW_BACKGROUND_OPACITY = 0.62

-- get_config_overrides() hands back a copy, so the current value is never the
-- same table we last stored; compare the fields instead of the identity.
local function same_text_hsb(actual, expected)
	if actual == nil or expected == nil then
		return actual == expected
	end
	return actual.hue == expected.hue
		and actual.saturation == expected.saturation
		and actual.brightness == expected.brightness
end

wezterm.on("window-focus-changed", function(window)
	local overrides = window:get_config_overrides() or {}
	local text_hsb, opacity
	if not window:is_focused() then
		text_hsb = UNFOCUSED_FOREGROUND_TEXT_HSB
		opacity = UNFOCUSED_WINDOW_BACKGROUND_OPACITY
	end

	-- Only write when one of the two values we own actually changes; a redundant
	-- set_config_overrides() call would trigger another config reload.
	if same_text_hsb(overrides.foreground_text_hsb, text_hsb) and overrides.window_background_opacity == opacity then
		return
	end

	overrides.foreground_text_hsb = text_hsb
	overrides.window_background_opacity = opacity
	window:set_config_overrides(overrides)
end)

return config
