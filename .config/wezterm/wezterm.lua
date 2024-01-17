local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.font_size = 17.0
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false
config.use_dead_keys = true

config.window_close_confirmation = 'NeverPrompt'

local x_padding = 0
local y_padding = 0

config.window_padding = {
  left = x_padding,
  right = x_padding,
  top = y_padding,
  bottom = y_padding,
}


config.font = wezterm.font_with_fallback({
  { family = 'Fira Code' },
  'Apple Color Emoji',
})


config.font_rules = {
  {
    intensity = 'Bold',
    font = wezterm.font_with_fallback({
      { family = 'Fira Code', weight = 'Bold' },
      'Apple Color Emoji',
    })
  }
}

config.harfbuzz_features = { 'calt=0' }

config.colors = {
  foreground = '#d5d8da',
  background = '#1c1e26',
  cursor_bg = '#d5d8da',
  cursor_fg = '#1c1e26',
  cursor_border = '#d5d8da',
  selection_fg = '#1c1e26',
  selection_bg = '#d5d8da',
  scrollbar_thumb = '#1c1e26',
  split = '#1c1e26',
  ansi = {
    '#16161c',
    '#e95678',
    '#29d398',
    '#fab795',
    '#26bbd9',
    '#ee64ae',
    '#59e3e3',
    '#c7c7c7'
  },
  brights = {
    '#2e303e',
    '#ec6a88',
    '#3fdaa4',
    '#fbc3a7',
    '#3fc6de',
    '#f075b7',
    '#6be6e6',
    '#fffeff'
  },
}

local act = wezterm.action

-- disable this line and execute `wezterm show-keys --lua` to see default mappings
config.disable_default_key_bindings = true

config.keys = {
  { key = "l",     mods = 'SUPER', action = act.ShowDebugOverlay },
  { key = 'Enter', mods = 'ALT',   action = act.ToggleFullScreen },
  { key = '-',     mods = 'SUPER', action = act.DecreaseFontSize },
  { key = '=',     mods = 'SUPER', action = act.IncreaseFontSize },
  { key = 'c',     mods = 'SUPER', action = act.CopyTo 'Clipboard' },
  { key = 'n',     mods = 'SUPER', action = act.SpawnWindow },
  { key = 'q',     mods = 'SUPER', action = act.QuitApplication },
  { key = 'r',     mods = 'SUPER', action = act.ReloadConfiguration },
  { key = 'v',     mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
  { key = 'w',     mods = 'SUPER', action = act.CloseCurrentTab { confirm = true } },
}

return config
