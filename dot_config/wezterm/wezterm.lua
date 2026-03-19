local wezterm = require("wezterm")
local utils = require("utils")
local config = wezterm.config_builder()

local os = package.config:sub(1, 1) == "\\" and "win" or "unix"
print(os)
if os == "win" then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	-- set default prog to WSL
	local wsl_domains = wezterm.default_wsl_domains()
	local default_domain = wsl_domains[1]
	if default_domain ~= nil then
		config.default_domain = default_domain.name
	end
end

local color_schemes = {
	"Bamboo",
	"Guezwhoz",
	"Glacier"
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
