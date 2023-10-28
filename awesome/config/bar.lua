local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local lain = require("lain")
local markup = lain.util.markup
local dpi = beautiful.xresources.apply_dpi
local freedesktop   = require("freedesktop")
local customWidgets = require("customWidgets")
local customCommands = require("customCommands")
local runCommand = customCommands.runCommand


local wibarSeparator = wibox.widget.textbox()
wibarSeparator.text = "|"

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart awesome", awesome.restart },
    { "quit awesome", function() awesome.quit() end },
}

mysystemmenu = {
    { " ━━━━━━━━━━━━", nil },
    { "open terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
    { "log out", function() runCommand("rm /tmp/awesome-startup"); awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
    { "sleep", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
    { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
    { "shutdown", "systemctl poweroff", menubar.utils.lookup_icon("system-shutdown") },
}

mymainmenu = freedesktop.menu.build({
    before = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { " ━━━━━━━━━━━━", nil },
    },

    after = mysystemmenu,
})


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock(" %a %b %d/%m %_I:%M %p ")
lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Hack NF Regular 9",
        fg   = beautiful.fg_normal,
        bg   = beautiful.bg_normal
    }
})

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    local l = awful.layout.suit

    local multiDev = true
    local tagNames = {}
    local tagLayouts = {}

    if multiDev then
        tagNames = { "", "", "", "", "", "" }
        tagLayouts = { l.tile, l.tile, l.tile, l.tile, l.floating, l.tile }
    else
        tagNames = { "", "", "", "", "" }
        tagLayouts = { l.tile, l.tile, l.tile, l.floating, l.tile }
    end

    awful.tag(tagNames, s, tagLayouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        style   = { shape = gears.shape.rounded_rect },
        layout  = { spacing = 10, layout  = wibox.layout.flex.horizontal},
        buttons = tasklist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 3,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        type = "dock",
        position = "top",
        screen = s,
        opacity = 0.8,
        shape = gears.shape.rounded_rect,
        width = s.geometry.width - dpi(20),
    })


    local wiboxRightWidgets = {layout = wibox.layout.fixed.horizontal,}

    table.insert(wiboxRightWidgets, wibox.widget.systray())

    -- table.insert(wiboxRightWidgets, wibox.widget.textbox("<span font='Font Awesome 6 Free 19' foreground='#7745ff'>  </span>"))
    
    -- table.insert(wiboxRightWidgets, arrl_dl)

    -- table.insert(wiboxRightWidgets, arrl_ld)
    
    -- table.insert(wiboxRightWidgets, volume_widget{widget_type = "icon_and_text"})

    table.insert(wiboxRightWidgets, customWidgets.cpuInfo)
    
    table.insert(wiboxRightWidgets, customWidgets.gpuInfo)
    
    table.insert(wiboxRightWidgets, customWidgets.memoryInfo)

    table.insert(wiboxRightWidgets, customWidgets.volume.widget)

    table.insert(wiboxRightWidgets, customWidgets.languageChange.widget)

    -- table.insert(wiboxRightWidgets, lain.widget.cpu({
    --     settings = function()
    --         widget:set_markup(markup.fontfg(beautiful.font, ((cpu_now.usage < 40 and "#87af5f") or (cpu_now.usage < 80 and "#f1af5f") or "#e33a6e"), " CPU: " .. cpu_now.usage .. "% "))
    --     end
    -- }).widget)

    -- table.insert(wiboxRightWidgets, lain.widget.mem({
    --     settings = function()
    --         local total = string.format("%.1f", (mem_now.total + mem_now.cache)/1024)
    --         local used = string.format("%.1f", mem_now.used/1024)
    --         widget:set_markup(markup.fontfg(beautiful.font, ((tonumber(used)/tonumber(total) < 0.4 and "#87af5f") or (tonumber(used)/tonumber(total) < 0.8 and "#f1af5f") or "#e33a6e"), " RAM: " .. math.floor(tonumber(used)/tonumber(total)*100) .. "% "))
    --     end
    -- }).widget)

    local showBat = true
    table.insert(wiboxRightWidgets, lain.widget.bat({
        settings = function()
            showBat = bat_now.status ~= "N/A"
            widget:set_markup(markup.fontfg(beautiful.font, ((bat_now.capacity < 15 and "#e33a6e") or (bat_now.capacity < 70 and "#f1af5f") or "#87af5f"), " BAT: " .. bat_now.capacity .. "% "))
        end
    }).widget)
    if not showBat then
        table.remove(wiboxRightWidgets, #wiboxRightWidgets)
    end
    
    -- table.insert(wiboxRightWidgets, customWidgets.volume.volume_widget)
    
    -- table.insert(wiboxRightWidgets, batteryarc_widget({show_current_level = true,}))

    -- table.insert(wiboxRightWidgets, wibox.widget.textbox("<span font='Hack Nerd Font Mono 18' foreground='#FFC830'></span>"))

    -- table.insert(wiboxRightWidgets, customWidgets.nowPlaying)
    
    -- table.insert(wiboxRightWidgets, mykeyboardlayout)

    -- table.insert(wiboxRightWidgets, kbdcfg.widget)

    table.insert(wiboxRightWidgets, mytextclock)


    table.insert(wiboxRightWidgets, s.mylayoutbox)

    -- local i = 0
    -- for _ in pairs(wiboxRightWidgets) do
    --     i = i + 1
    -- end

    -- for j=i-1, 1, -1 do
    --     table.insert(wiboxRightWidgets, j, wibarSeparator)
    --     -- wiboxRightWidgets[2*j-1] = wiboxRightWidgets[j]
    --     -- if j ~= i-1 then
    --     --     wiboxRightWidgets[2*j] = wibarSeparator
    --     -- end
    -- end

    -- Add widgets to the wibox

    s.mywibox:setup {
        {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                wibarSeparator,
                s.mytaglist,
                s.mypromptbox,
                wibarSeparator,
            },
            s.mytasklist, -- Middle widget
            wiboxRightWidgets, -- Right widgets
        },
        top = 0,
        left = dpi(15),
        right = dpi(15),
        widget = wibox.container.margin,
    }
end)
-- }}}