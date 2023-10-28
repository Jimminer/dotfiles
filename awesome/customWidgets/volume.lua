-- https://web.archive.org/web/20130928001745/http://awesome.naquadah.org/wiki/Volume_control_and_display
-- https://github.com/esn89/volumetextwidget/blob/master/textvolume.lua

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local runCommand = require("customCommands.runCommand")

volume = {}

volume.widget = wibox.widget.container

local volumeWidget = wibox.widget {
    align = "center",
    valign = "center",
    forced_width = 70,
    widget = wibox.widget.textbox
}

volume.widget = {
    {
        {
            {
                {
                    widget = volumeWidget,
                },
                
                left   = 0,
                right  = 0,
                top    = 0,
                bottom = 0,
                widget = wibox.container.margin
                
            },
            
            shape        = gears.shape.rounded_rect,
            bg           = "#212121",
            widget       = wibox.container.background
        },
        left   = 4,
        right  = 4,
        top    = 3,
        bottom = 3,
        widget = wibox.container.margin
    },
    
    layout  = wibox.layout.fixed.horizontal,
}

volume.muted = false
volume.volume = 0


-- volume.widget:set_align("right")
volumeWidget:buttons(
    awful.util.table.join(
        awful.button({}, 4, function() volume.increment(5) end),
        awful.button({}, 5, function() volume.decrement(5) end),
        awful.button({}, 2, function() volume.mixer() end),
        awful.button({}, 1, function() volume.toggle() end)
    )
)


local function update_volume()
    local value = runCommand("pamixer --get-volume")
    local muted = runCommand("pamixer --get-mute")

    value = value:sub(0, -2)
    muted = muted:sub(0, -2)

    value = tonumber(value)
    
    if (value == nil) then value = 0 end
    if (muted == nil) then muted = "false" end
    

    if muted == "false" then
        volume.muted = false
        volume.volume = value
        volumeColor = "#a47dff"
    else
        volume.muted = true
        volume.volume = value
        volumeColor = "#e33a6e"
    end


    icon = (muted == "true" and "") or (value == 0 and "") or (value < 30 and "") or (value < 70 and "") or ""
    iconText = "<span font='Font Awesome 6 Pro Solid 11' foreground='#7745ff'> " .. icon .. " </span>"
    volumeText = "<span font='Clear Sans Regular 11' foreground='" .. volumeColor .. "'> " .. value .. "  </span>"

    volumeWidget:set_markup(iconText .. volumeText)
end


volume.increment = function (value)
    runCommand("pamixer -i " .. value)
    update_volume()
end

volume.decrement = function (value)
    runCommand("pamixer -d " .. value)
    update_volume()
end

volume.mixer = function ()
    awful.util.spawn("pavucontrol -t 3")
    update_volume()
end

volume.toggle = function ()
    runCommand("pamixer -t")
    update_volume()
end


update_volume()

local mytimer = timer({ timeout = 2 })
mytimer:connect_signal("timeout", function() update_volume() end)
mytimer:start()

return volume
