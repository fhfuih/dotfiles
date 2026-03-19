local wezterm = require("wezterm")
local utils = require("utils")
local config = wezterm.config_builder()

local os = package.config:sub(1, 1) == "\\" and "win" or "unix"
print(os)
if os == "win" then
	-- set default prog to WSL
	config.default_domain = "WSL:Ubuntu-25.10"
	-- local default_wsl = nil
	-- local handle = io.popen("wsl -l -q")
	-- if handle ~= nil then
	-- 	local wsl_list = handle:read("*a")
	-- 	default_wsl = string.match(wsl_list, "^(.-)\n")
	-- end
	-- if default_wsl ~= nil then
	-- 	config.default_domain = "WSL:" .. default_wsl
	-- else
	-- 	config.default_prog = { "pwsh.exe", "-NoLogo" }
	-- end
end

local color_schemes = {
	"Bamboo",
	"Guezwhoz",
	"Glacier",
	"GruvboxDarkHard",
}

local font_families = {
	"Rec Mono Duotone",
	"Maple Mono NF CN",
}

config.use_fancy_tab_bar = false
config.enable_scroll_bar = true

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

config.font = wezterm.font_with_fallback({
	utils.today_choice(font_families),
	"Menlo",
	"Cascadia Code",
	"monospace",
	"Segoe UI Emoji",
})

config.color_scheme = utils.today_choice(color_schemes)

return config
