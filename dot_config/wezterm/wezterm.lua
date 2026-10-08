local wezterm = require("wezterm")
local utils = require("utils")
local config = wezterm.config_builder()

config.term = "wezterm"

local os = package.config:sub(1, 1) == "\\" and "win" or "unix"
if os == "win" then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	-- set default prog to WSL
	-- local wsl_domains = wezterm.default_wsl_domains()
	-- local default_domain = wsl_domains[1]
	-- if default_domain ~= nil then
	-- 	config.default_domain = default_domain.name
	-- end
end

config.ssh_domains = wezterm.default_ssh_domains()
for _, dom in ipairs(config.ssh_domains) do
	-- dom.name = "󰢩 " .. dom.name
	dom.assume_shell = "Posix"
	dom.ssh_option = {
		ServerAliveInterval = "120",
		ServerAliveCountMax = "3",
	}
end

config.wsl_domains = wezterm.default_wsl_domains()
for _, dom in ipairs(config.wsl_domains) do
	-- dom.name = "  "
end

local color_schemes = {
	"Bamboo",
	"Guezwhoz",
	"Glacier",
	"Operator Mono Dark",
	"Orangish (terminal.sexy)",
	"Oxocarbon Dark (Gogh)",
}

local font_families = {
	"IosevkaTermSlab Nerd Font",
	"RecMonoDuotone Nerd Font",
	"Maple Mono NF CN",
}

config.use_fancy_tab_bar = false
config.enable_scroll_bar = true

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

config.font = wezterm.font(utils.today_choice(font_families))

config.color_scheme = utils.today_choice(color_schemes)

return config
