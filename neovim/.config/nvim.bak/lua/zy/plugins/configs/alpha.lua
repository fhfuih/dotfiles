local theme = require('alpha.themes.dashboard')
local button = theme.button

theme.section.buttons.val = {
    button("e", "  New File", "<cmd>ene <CR>"),
    button("SPC f f", "  Find File"),
    button("SPC f p", "  Find Project"),
    button("SPC f h", "  Recently opened files"),
    button("SPC f w", "  Find word"),
    -- button("SPC f r", "  Frecency/MRU"),
    -- button("SPC f m", "  Jump to bookmarks"),
    -- button("SPC s l", "  Open last session"),
}

require('alpha').setup(theme.config)
