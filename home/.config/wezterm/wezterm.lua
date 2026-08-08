local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

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

-- Function to get memory usage based on OS
local function get_memory_usage()
  local cmd = ""
  
  if wezterm.target_triple:find("apple") then
    -- macOS command
    cmd = [[
    vm_stat | awk '
    /Pages free/ {free=$3}
    /Pages active/ {a=$3}
    /Pages inactive/ {i=$3}
    /Pages speculative/ {s=$3}
    /Pages wired down/ {w=$3}
    END {
      used=a+i+s+w;
      total=used+free;
      if (total==0) { print "N/A"; exit 1 }
      printf "%.1f%%", (used/total)*100
    }'
  ]]
  elseif wezterm.target_triple:find("windows") then
    -- Windows PowerShell command
    cmd = "powershell -NoProfile -Command \"(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory\""
  else
    -- Linux command
    cmd = "free -h | awk '/^Mem:/ {print $3 \"/\" $2}'"
  end

  local success, stdout, stderr = wezterm.run_child_process({ "sh", "-c", cmd })
  
  -- Fallback for Windows if sh isn't available natively
  if not success and wezterm.target_triple:find("windows") then
    success, stdout, stderr = wezterm.run_child_process({ "powershell.exe", "-NoProfile", "-Command", cmd })
  end

  if success then
    return stdout:gsub("%s+", "") -- Clean up whitespace/newlines
  end
  return "Mem: Unknown"
end

wezterm.on('update-status', function(window, pane)
  local mem = get_memory_usage()
  
  window:set_right_status(wezterm.format({
    { Background = { Color = '#1e1e2e' } },
    { Foreground = { Color = '#fab387' } },
    { Text = ' Mem: ' .. mem .. ' ' },
  }))
end)

return config
