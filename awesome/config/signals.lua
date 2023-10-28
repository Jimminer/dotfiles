local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local customCommands = require("customCommands")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if c.class == "easyeffects" then
        awful.spawn.easy_async("sleep 0.001", function() awful.tag.viewonly(screen[1].tags[1]) end)
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)


-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
    -- c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

-- local focusedWindow = nil

-- client.connect_signal("focus", 
--     function(c)
--         focusedWindow = c

        -- customCommands.printn(tostring(client.focus.class))
        -- if not c.maximized and not c.fullscreen then
        --     awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 1", false)
        -- else
        --     awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
        -- end

        -- c.border_color = beautiful.border_focus
        -- c.border_width = beautiful.border_width
--     end
-- )


-- client.connect_signal("unfocus", 
--     function(c)
        -- awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
        -- c.border_color = beautiful.border_normal
        -- c.border_width = beautiful.border_width
--     end
-- )

-- client.connect_signal("property::minimized", 
--     function(c)
--         awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
--         c.border_color = beautiful.border_normal
--         c.border_width = 0
--     end
-- )


local function updateBorder(c)
    local s = awful.screen.focused()
    local clients = awful.client.visible(s)

    if #clients == 1 or layout == "max" then
        awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
    elseif client.focus == c and not c.maximized and not c.fullscreen then
        awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 1", false)
    else
        awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
    end
end


client.connect_signal("property::size", updateBorder)
client.connect_signal("property::minimized", updateBorder)
client.connect_signal("property::border_width", updateBorder)
client.connect_signal("focus", updateBorder)
client.connect_signal("unfocus", updateBorder)

-- for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
--     local clients = awful.client.visible(s)
--     local layout  = awful.layout.getname(awful.layout.get(s))
--     local foundFocused = false

--     if #clients > 0 then -- Fine grained borders and floaters control
--         for _, c in pairs(clients) do -- Floaters always have borders
--             -- customCommands.printn(c.name .. ": [" .. "Maximized: " .. tostring(c.maximized) .. ", Fullscreen: " .. tostring(c.fullscreen) .. ", Focused: " .. "false" .. "]")
--             -- if awful.client.floating.get(c) or layout == "floating" then
--             --     c.border_width = beautiful.border_width

--             -- No borders with only one visible client
            
--             if #clients == 1 or layout == "max" then
--                 awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
--                 c.border_width = 0
--             elseif c == focusedWindow and not c.maximized and not c.fullscreen then
--                 foundFocused = true
--                 awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 1", false)
--                 c.border_width = beautiful.border_width
--             else
--                 awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0", false)
--                 -- c.border_width = 0
--             end
--         end
--         if not foundFocused and #clients > 1 then
--             customCommands.printn("nigga")
--             -- awful.client.focus.history.get(awful.screen.focused(), 1)
--             client.focus:emit_signal("request::activate", "", {raise = true})
--         end
--     end

--   end)
-- end

-- }}}