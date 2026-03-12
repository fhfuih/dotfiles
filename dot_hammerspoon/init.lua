local Windows = require("windows")

for _, value in ipairs({ "left", "right", "up", "down" }) do
    hs.hotkey.bind({ "cmd", "alt", "ctrl" }, value, function()
        Windows.moveToScreen(value)
    end)
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "return", Windows.toggleFullScreen)
