return function(default)
  default.layout[4].val = {
    astronvim.alpha_button("LDR f f", "  Find File  "),
    astronvim.alpha_button("LDR f o", "  Recents  "),
    astronvim.alpha_button("LDR f n", "  New File  "),
    astronvim.alpha_button("LDR f m", "  Bookmarks  "),
    astronvim.alpha_button("LDR f s", "  Find Session  "),
    astronvim.alpha_button("LDR S l", "  Last Session  "),
  }
  return default
end
