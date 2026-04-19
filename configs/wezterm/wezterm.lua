local wezterm = require("wezterm")

return {
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font_with_fallback({
    "FiraCode Nerd Font",
    "JetBrainsMono Nerd Font",
    "GoMono Nerd Font",
    "Menlo",
    "DejaVu Sans Mono",
    "Liberation Mono",
    "Ubuntu Mono",
  }),
  font_size = 13.0,
  enable_tab_bar = false,
  window_decorations = "TITLE | RESIZE",
  keys = {
    {
      key = "Tab",
      mods = "CTRL",
      action = wezterm.action.SendKey({ key = "Tab", mods = "CTRL" }),
    },
    {
      key = "Tab",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SendKey({ key = "Tab", mods = "CTRL|SHIFT" }),
    },
    {
      key = "PageDown",
      mods = "CTRL",
      action = wezterm.action.SendKey({ key = "PageDown", mods = "CTRL" }),
    },
    {
      key = "PageUp",
      mods = "CTRL",
      action = wezterm.action.SendKey({ key = "PageUp", mods = "CTRL" }),
    },
  },
}
