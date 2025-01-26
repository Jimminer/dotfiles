-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local configPath = string.format("%s/.config/awesome", os.getenv("HOME"))

-- Standard awesome library
-- local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
-- local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- local menubar = require("menubar")
-- local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- local lain = require("lain")
-- local markup = lain.util.markup
-- local freedesktop   = require("freedesktop")

-- local handy = require("includes/awesome-handy")

-- local customWidgets = require("customWidgets")

-- local customCommands = require("customCommands")

-- local runCommand = customCommands.runCommand
-- local printn = customCommands.printn

-- local dpi = beautiful.xresources.apply_dpi



-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "xresources/theme.lua")

local themes = {
    string.format("%s/themes/default/default", configPath),      -- 1
    string.format("%s/themes/default/gtk", configPath),          -- 2
    string.format("%s/themes/default/sky", configPath),          -- 3
    string.format("%s/themes/default/xresources", configPath),   -- 4
    string.format("%s/themes/default/zenburn", configPath),      -- 5
    string.format("%s/themes/blackburn", configPath),            -- 6
    string.format("%s/themes/copland", configPath),              -- 7
    string.format("%s/themes/multicolor", configPath),           -- 8
    string.format("%s/themes/powerarrow", configPath),           -- 9
    string.format("%s/themes/powerarrow-blue", configPath),      -- 10
}

-- Choose your theme here
local chosen_theme = themes[6]
beautiful.init(string.format("%s/theme.lua", chosen_theme))

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = "micro" -- os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

-- Super key (Bad OS key)
modkey = "Mod4"

-- Alt key
-- modkey = "Mod1"

require("config.keybindings")
require("config.signals")
require("config.bar")
require("config.startup")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}






-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)


-- kbdcfg = {}
-- kbdcfg.cmd = "xkb-switch"
-- kbdcfg.layout = { "us", "gr" }
-- kbdcfg.layouttitle = { "US", "GR" }
-- kbdcfg.current = 1  -- us is our default layout
-- kbdcfg.widget = wibox.widget.textbox()
-- kbdcfg.widget:set_markup(" <span color='#1EB9E8'>" .. kbdcfg.layouttitle[kbdcfg.current] .. "</span> ")
-- kbdcfg.switch = function ()
--     local oldkbd = kbdcfg.current
--     kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
--     local t = " " .. kbdcfg.layouttitle[kbdcfg.current] .. " "
--     kbdcfg.widget:set_markup(string.format("<span color='#1EB9E8'>%s</span>", t))
--     local cmdoptions = " -s " .. kbdcfg.layout[kbdcfg.current]
--     os.execute( kbdcfg.cmd .. cmdoptions )
-- end
-- kbdcfg.widget:buttons(awful.util.table.join(
--     awful.button({ }, 1, function () kbdcfg.switch() end)
-- ))

-- separators = lain.util.separators
-- arrl_dl = separators.arrow_left(beautiful.bg_focus, "#FFFFFF") 
-- arrl_ld = separators.arrow_left("alpha", beautiful.bg_focus) 





-- Custom Configuration

naughty.config.defaults.border_color = "#9245ff"
naughty.config.defaults.border_width = 1
naughty.config.defaults.max_width = 500
naughty.config.defaults.icon_size = 100

-- local confPath = "/etc/xdg/awesome/"
-- confPath = runCommand("dirname $(realpath " .. awesome.conffile .. ")")



-- function dump(o)
--     if type(o) == 'table' then
--        local s = '{ '
--        for k,v in pairs(o) do
--           if type(k) ~= 'number' then k = '"'..k..'"' end
--           s = s .. '['..k..'] = ' .. dump(v) .. ','
--        end
--        return s .. '} '
--     else
--        return tostring(o)
--     end
--  end

local previousTag = 1
 
local gaps_amount = 5
-- local gaps_state = false

beautiful.useless_gap = gaps_amount




-- Custom Rules

-- awful.rules.rules = gears.table.join(
--     awful.rules.rules,

--     {
--         rule = { class = "easyeffects" },
--         properties = { tag = screen[1].tags[5] }
--     }
-- )




-- To install:

--   Compositor: picom or picom-pijulius-git (AUR)
--   Network Manager: network-manager-applet
--   Power Manager: xfce4-power-manager
--   Bluetooth: blueberry
--   Policy Kit: polkit-gnome
--   Clipboard Manager: copyq
--   Language Switcher: xkb-switch (AUR)
--   Screenshot Program: flameshot
--   GTK Themes Manager: lxappearance
--   Others: rofi, thunar-archive-plugin, pamixer (AUR)

--   Fonts: Clear Sans, JetBrainsMono Nerd Font, Font Awesome

--   Alternatives: bat (cat), btop (htop), eza (ls), fd (find), ripgrep (grep)
