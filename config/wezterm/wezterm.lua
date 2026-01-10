local wezterm = require("wezterm")
local rose_pine_dark = require("lua.themes.rose-pine").main
local rose_pine_dawn = require("lua.themes.rose-pine").dawn
local config = wezterm.config_builder()

config.default_domain = "WSL:Ubuntu"

-- 1. Helper Functions
local function get_scheme(appearance)
	if appearance:find("Dark") then
		return {
			colors = rose_pine_dark.colors(),
			window_frame = rose_pine_dark.window_frame(),
			name = "dark",
		}
	else
		return {
			colors = rose_pine_dawn.colors(),
			window_frame = rose_pine_dawn.window_frame(),
			name = "light",
		}
	end
end

local function write_theme_state_to_wsl(theme_name)
	-- Write the theme state to a file inside WSL so Fish can see it
	wezterm.run_child_process({
		"wsl.exe",
		"-d",
		"Ubuntu",
		"bash",
		"-c",
		"mkdir -p ~/.cache && echo " .. theme_name .. " > ~/.cache/theme_mode",
	})
end

-- 2. Event Listener for Dynamic Updates
wezterm.on("update-status", function(window, pane)
	local appearance = wezterm.gui.get_appearance()
	local scheme = get_scheme(appearance)
	local overrides = window:get_config_overrides() or {}

	-- Only update if the theme actually changed
	if not overrides.colors or overrides.colors.background ~= scheme.colors.background then
		window:set_config_overrides({
			colors = scheme.colors,
			window_frame = scheme.window_frame,
		})
		
		-- Broadcast the change to WSL
		write_theme_state_to_wsl(scheme.name)
		wezterm.log_info("Switched theme to " .. scheme.name)
	end
end)

-- 3. Initial Configuration
local appearance = wezterm.gui.get_appearance()
local scheme = get_scheme(appearance)

config.colors = scheme.colors
config.window_frame = scheme.window_frame

-- Set initial environment for new shells
config.set_environment_variables = {
	THEME_MODE = scheme.name,
	WSLENV = "THEME_MODE/u",
}

-- Ensure state is consistent on startup
write_theme_state_to_wsl(scheme.name)

-- 4. General Settings
config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "CaskaydiaCove Nerd Font" })
config.font_size = 12.0
config.line_height = 1.1
config.harfbuzz_features = { "calt=1", "liga=1", "clig=1" }
config.hide_tab_bar_if_only_one_tab = true

return config