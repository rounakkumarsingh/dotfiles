local wezterm = require("wezterm")
local rose_pine_dark = require("lua.themes.rose-pine").main
local rose_pine_dawn = require("lua.themes.rose-pine").dawn
local config = wezterm.config_builder()

config.default_domain = "WSL:Ubuntu"
wezterm.log_info(wezterm.default_wsl_domains())

config.set_environment_variables = {
	WSLENV = "THEME_MODE/u",
}

local THEME_SCRIPT = "/home/rounakkumarsingh/dotfiles/scripts/get-system-theme.fish"

local ok, theme, stderr = wezterm.run_child_process({
	"wsl.exe",
	"-d",
	"Ubuntu",
	"-e",
	"fish",
	"-c",
	THEME_SCRIPT,
})

if ok and theme then
	theme = theme:gsub("%s+", "")

	if theme ~= "" then
		config.set_environment_variables.THEME_MODE = theme
		wezterm.log_info("THEME_MODE =", theme)
	else
		wezterm.log_warn("get-system-theme returned empty output")
	end
else
	wezterm.log_warn("get-system-theme failed:", stderr)
end

local colors = nil
local window_frame = nil

if theme == "light" then
	colors = rose_pine_dawn.colors()
	window_frame = rose_pine_dawn.window_frame()
else
	colors = rose_pine_dark.colors()
	window_frame = rose_pine_dark.window_frame()
end

config.colors = colors
config.window_frame = window_frame

config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "CaskaydiaCove Nerd Font" })
config.font_size = 12.0
config.line_height = 1.1
config.harfbuzz_features = { "calt=1", "liga=1", "clig=1" }
config.hide_tab_bar_if_only_one_tab = true
return config
