local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local customWidgets = require("customWidgets")
local naughty = require("naughty")
local handy = require("includes/awesome-handy")
local savedNotifs = {}
local dotfilesPath = string.format("%s/Programming/Repos (GitHub)/dotfiles", os.getenv("HOME"))

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end)
-- awful.button({ }, 4, awful.tag.viewnext),
-- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    awful.key({ modkey, }, "s",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),

    awful.key({ modkey, }, "Left",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),

    awful.key({ modkey, }, "Right",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),

    awful.key({ "Mod1" }, "Tab",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),

    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    
    awful.key({ modkey, }, "w",
        function()
            mymainmenu:show()
        end,
        { description = "show main menu", group = "awesome" }
    ),



    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j",
        function()
            awful.client.swap.byidx(1)
        end,
        { description = "swap with next client by index", group = "client" }
    ),

    awful.key({ modkey, "Shift" }, "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        { description = "swap with previous client by index", group = "client" }
    ),

    awful.key({ modkey, "Control" }, "j",
        function()
            awful.screen.focus_relative(1)
        end,
        { description = "focus the next screen", group = "screen" }
    ),

    awful.key({ modkey, "Control" }, "k",
        function()
            awful.screen.focus_relative(-1)
        end,
        { description = "focus the previous screen", group = "screen" }
    ),

    awful.key({ modkey, }, "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),

    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),



    -- Standard program
    awful.key({ modkey, }, "Return",
        function()
            awful.spawn(terminal)
        end,
        { description = "open a terminal", group = "applications" }
    ),

    awful.key({ modkey, "Control" }, "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),

    awful.key({ modkey, "Shift" }, "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),

    awful.key({ modkey, }, "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        { description = "increase master width factor", group = "layout" }
    ),

    awful.key({ modkey, }, "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        { description = "decrease master width factor", group = "layout" }
    ),

    awful.key({ modkey, "Shift" }, "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        { description = "increase the number of master clients", group = "layout" }
    ),

    awful.key({ modkey, "Shift" }, "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        { description = "decrease the number of master clients", group = "layout" }
    ),

    awful.key({ modkey, "Control" }, "h",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        { description = "increase the number of columns", group = "layout" }
    ),

    awful.key({ modkey, "Control" }, "l",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        { description = "decrease the number of columns", group = "layout" }
    ),

    awful.key({ modkey, }, "space",
        function()
            awful.layout.inc(1)
        end,
        { description = "select next", group = "layout" }
    ),

    awful.key({ modkey, "Shift" }, "space",
        function()
            awful.layout.inc(-1)
        end,
        { description = "select previous", group = "layout" }
    ),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }
    ),

    -- Prompt
    -- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }
    )
-- Menubar
-- awful.key({ modkey }, "p", function() menubar.show() end,
--           {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),

    awful.key({ modkey, "Shift" }, "c",
        function(c)
            c:kill()
        end,
        { description = "close", group = "client" }
    ),

    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),

    awful.key({ modkey, "Control" }, "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        { description = "move to master", group = "client" }
    ),

    awful.key({ modkey, }, "o",
        function(c)
            c:move_to_screen()
        end,
        { description = "move to screen", group = "client" }
    ),

    awful.key({ modkey, }, "t",
        function(c)
            c.ontop = not c.ontop
        end,
        { description = "toggle keep on top", group = "client" }
    ),

    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }
    ),

    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }
    ),

    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }
    ),

    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" }
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }
        ),

        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }
        ),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }
        ),

        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" }
        )
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end
    ),

    awful.button({ modkey }, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end
    ),

    awful.button({ modkey }, 3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end
    )
)






customKeys = gears.table.join(
    -- awful.key(
    -- 	{ modkey, "Shift" }, "g",

    -- 	function ()
    -- 		gaps_state = not gaps_state
    -- 		if gaps_state then
    -- 			beautiful.useless_gap = gaps_amount
    -- 		else
    -- 			beautiful.useless_gap = 0
    -- 		end

    -- 		awful.screen.connect_for_each_screen(function(s)
    -- 			awful.layout.arrange(s)
    -- 		end)
    -- 	end,

    -- 	{description = "toggle window gaps", group = "layout"}
    -- ),

    awful.key(
        { modkey, "Shift", "Control" }, "e",

        function()
            awful.spawn("vscodium '" .. dotfilesPath .. "'")
        end,

        { description = "edit dotfiles config (vscodium)", group = "awesome" }
    ),

    awful.key(
        { modkey, "Shift" }, "b",

        function()
            awful.spawn("brave")
        end,

        { description = "launch brave", group = "applications" }
    ),

    awful.key(
        { modkey, "Shift" }, "f",

        function()
            awful.spawn("thunar")
        end,

        { description = "launch thunar", group = "applications" }
    ),

    awful.key(
        { modkey }, "r",
        function()
            awful.spawn("rofi -show drun")
        end,

        { description = "open rofi", group = "applications" }
    ),

    awful.key(
        { modkey, "Shift" }, "p",

        function()
            handy("pavucontrol", awful.placement.centered, 0.5, 0.6)
        end,

        { description = "launch pavucontrol", group = "applications" }
    ),

    awful.key(
        { modkey, "Shift" }, "m",

        function()
            awful.spawn(
            "alacritty -o window.dimensions.columns=130 window.dimensions.lines=45 font.size=12 -e ncmpcpp")
        end,

        { description = "launch ncmpcpp", group = "applications" }
    ),

    awful.key(
        { modkey, "Shift" }, "t",

        function()
            awful.spawn(
            "alacritty -o window.dimensions.columns=100 window.dimensions.lines=40 font.size=12 -e sh -c '/home/mitsos/.local/bin/listo'")
        end,

        { description = "launch listo", group = "applications" }
    ),

    awful.key(
        { modkey, "Shift" }, "e",

        function()
            awful.spawn("vscodium")
        end,

        { description = "launch vscodium", group = "applications" }
    ),

    awful.key(
        { modkey }, "Escape",

        function()
            awful.spawn("alacritty -e btop")
        end,

        { description = "launch btop", group = "applications" }
    ),

    awful.key({}, "XF86AudioRaiseVolume",
        function()
            local volume = customWidgets.volume.volume + 5
            if volume > 100 then
                volume = 100
            end
            volume = math.floor(volume)

            local text = "<span size='11pt'>Volume: " ..
            volume .. "%" .. (customWidgets.volume.muted and " (Muted)" or "") .. "</span>"

            if naughty.getById(savedNotifs.volume) then
                naughty.reset_timeout(naughty.getById(savedNotifs.volume), naughty.config.defaults.timeout)
                naughty.replace_text(naughty.getById(savedNotifs.volume), false, text)
            else
                savedNotifs.volume = naughty.notify({ text = text, width = 180, opacity = 0.9 }).id
            end
            -- awful.spawn("amixer -D pulse sset Master 5%+", false)
            customWidgets.volume.increment(5)
        end
    ),

    awful.key({}, "XF86AudioLowerVolume",
        function()
            local volume = customWidgets.volume.volume - 5
            if volume < 0 then
                volume = 0
            end
            volume = math.floor(volume)

            local text = "<span size='11pt'>Volume: " ..
            volume .. "%" .. (customWidgets.volume.muted and " (Muted)" or "") .. "</span>"

            if naughty.getById(savedNotifs.volume) then
                naughty.reset_timeout(naughty.getById(savedNotifs.volume), naughty.config.defaults.timeout)
                naughty.replace_text(naughty.getById(savedNotifs.volume), false, text)
            else
                savedNotifs.volume = naughty.notify({ text = text, width = 180, opacity = 0.9 }).id
            end
            -- awful.spawn("amixer -D pulse sset Master 5%-", false)
            customWidgets.volume.decrement(5)
        end
    ),

    awful.key({}, "XF86AudioMute",
        function()
            local text = "<span size='11pt'>Sound " .. (customWidgets.volume.muted and "Unmuted" or "Muted") .. "</span>"

            if naughty.getById(savedNotifs.volume) then
                naughty.reset_timeout(naughty.getById(savedNotifs.volume), naughty.config.defaults.timeout)
                naughty.replace_text(naughty.getById(savedNotifs.volume), false, text)
            else
                savedNotifs.volume = naughty.notify({ text = text, width = 180, opacity = 0.9 }).id
            end
            -- awful.spawn("amixer -D pulse sset Master toggle", false)
            customWidgets.volume.toggle()
        end
    ),

    awful.key({}, "XF86AudioNext",
        function()
            awful.spawn("playerctl next")
        end
    ),

    awful.key({}, "XF86AudioPrev",
        function()
            awful.spawn("playerctl previous")
        end
    ),

    awful.key({}, "XF86AudioPlay",
        function()
            awful.spawn("playerctl play-pause")
        end
    ),

    awful.key({}, "XF86AudioStop",
        function()
            awful.spawn("playerctl stop")
        end
    ),

    awful.key({}, "XF86MonBrightnessUp",
        function()
            awful.spawn("xbacklight -inc 5")
        end
    ),

    awful.key({}, "XF86MonBrightnessDown",
        function()
            awful.spawn("xbacklight -dec 5")
        end
    ),

    awful.key({}, "XF86Calculator",
        function()
            awful.spawn("alacritty -e python")
        end,

        { description = "launch a python interpreter", group = "applications" }
    ),

    awful.key({}, "Print",
        function()
            awful.spawn("flameshot gui")
        end,

        { description = "capture a screenshot (selection)", group = "utility" }
    ),

    awful.key({ "Control" }, "Print",
        function()
            awful.spawn("flameshot launcher")
        end,

        { description = "capture a screenshot (launcher)", group = "utility" }
    ),

    awful.key({ modkey }, "v",
        function()
            awful.spawn("copyq toggle")
        end,

        { description = "open/close the clipboard manager (copyq)", group = "utility" }
    ),

    awful.key({ "Mod1" }, "Shift_L",
        function()
            customWidgets.languageChange.switch()
        end,

        { description = "change keyboard layout", group = "utility" }
    ),

    awful.key({ "Shift" }, "Alt_L",
        function()
            customWidgets.languageChange.switch()
        end,

        { description = "change keyboard layout", group = "utility" }
    ),


    awful.key({ modkey, "Shift" }, "s",
        function()
            awful.spawn("qutebrowser --target private-window '/home/mitsos/Downloads/vim cheatsheet/Vim Cheat Sheet.html'")
        end,

        { description = "show vim cheat sheet", group = "utility" }
    )
)





globalkeys = gears.table.join(
    globalkeys,
    customKeys
)

root.keys(globalkeys)




-- Set keys
-- root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = 0,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Zenity",
                "Yad",
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                -- "Steam",
                "Pavucontrol",
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "file-roller"
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
                "Friends List",
                "Figure", -- Octave/Matlab plots
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",  -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}
