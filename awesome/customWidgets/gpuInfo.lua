local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local widgetContainer = wibox.widget.container

local gpuInfoWidget = wibox.widget {
    align = "center",
    valign = "center",
    forced_width = 140,
    widget = wibox.widget.textbox
}

widgetContainer = {
    {
        {
            {
                {
                    widget = gpuInfoWidget,
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

local runCommand = require("customCommands.runCommand")
local printn = require("customCommands.printn")

-- if runCommand("playerctl status"):gsub("\n[^\n]*(\n?)$", "%1") == "Playing" then
--     local gpuInfoWidget = wibox.widget.textbox()
--     gpuInfoWidget:set_markup(markup.fontfg(beautiful.font, "#87af5f", runCommand("playerctl metadata title")))
--     table.insert(wiboxRightWidgets, gpuInfoWidget)
-- end

local function update_widget(widget)
    usage = runCommand("cat /sys/class/drm/card1/device/gpu_busy_percent")
    temp = runCommand("sensors | grep edge | awk '{print $2}'")


    usage = tonumber(usage) or 0
    temp = tonumber(string.sub(temp, 2, -5)) or 0


    usageColor = (usage < 40 and "#48d624") or (usage < 80 and "#ffcf4d") or "#e33a6e"
    tempColor = (temp < 60 and "#48d624") or (temp < 80 and "#ffcf4d") or "#e33a6e"


    iconText = "<span font='Font Awesome 6 Free 11' foreground='#7745ff'>  </span>"
    usageText = "<span font='Clear Sans Regular 11' foreground='" .. usageColor .. "'>" .. math.floor(usage) .. "%</span>"
    tempText = "<span font='Clear Sans Regular 11' foreground='" .. tempColor .. "'>" .. math.floor(temp) .. "°C  </span>"


    widget:set_markup(iconText .. usageText .. "<span font='Clear Sans Regular 11' foreground='#7745ff'> | </span>" .. tempText)
end

update_widget(gpuInfoWidget)

local updateTimer = timer({ timeout = 2 })
updateTimer:connect_signal("timeout", function() if (~update_widget(gpuInfoWidget)) then end end)
updateTimer:start()

return widgetContainer
