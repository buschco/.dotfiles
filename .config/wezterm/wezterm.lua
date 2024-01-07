local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.font_size = 17.0

config.window_close_confirmation = 'NeverPrompt'

local x_padding = 0
local y_padding = 0

config.window_padding = {
  left = x_padding,
  right = x_padding,
  top = y_padding,
  bottom = y_padding,
}

config.font = wezterm.font( { family = 'Fira Code' } )

config.font_rules = {
  {
    intensity = 'Bold',
    font = wezterm.font {
      family = 'Fira Code',
      weight = 'Bold'
    },
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

return config

