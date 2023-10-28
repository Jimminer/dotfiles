local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local widgetContainer = wibox.widget.container

local cpuInfoWidget = wibox.widget {
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
                    widget = cpuInfoWidget,
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

local prevUsage = 0
local prevIdle = 0
local runCommand = require("customCommands.runCommand")
local printn = require("customCommands.printn")

-- if runCommand("playerctl status"):gsub("\n[^\n]*(\n?)$", "%1") == "Playing" then
--     local cpuInfoWidget = wibox.widget.textbox()
--     cpuInfoWidget:set_markup(markup.fontfg(beautiful.font, "#87af5f", runCommand("playerctl metadata title")))
--     table.insert(wiboxRightWidgets, cpuInfoWidget)
-- end

local function update_widget(widget)
    idle = runCommand("cat /proc/stat | grep cpu | head -n 1 | awk '{print $5}'")
    usage = runCommand("cat /proc/stat | grep cpu | head -n 1 | awk '{print ($2+$3+$4+$5+$6+$7+$8+$9+$10)}'")

    temp = runCommand("sensors | grep Tctl | awk '{print $2}'")


    current = ( 1000 * ((usage-prevUsage) - (idle - prevIdle)) / (usage - prevUsage) + 5) / 10
    temp = tonumber(string.sub(temp, 2, -5))


    usageColor = (current < 40 and "#48d624") or (current < 80 and "#ffc936") or "#e33a6e"
    tempColor = (temp < 60 and "#48d624") or (temp < 80 and "#ffc936") or "#e33a6e"


    iconText = "<span font='Font Awesome 6 Free 11' foreground='#7745ff'>  </span>"
    usageText = "<span font='Clear Sans Regular 11' foreground='" .. usageColor .. "'>" .. math.floor(current) .. "%</span>"
    tempText = "<span font='Clear Sans Regular 11' foreground='" .. tempColor .. "'>" .. math.floor(temp) .. "°C  </span>"


    widget:set_markup(iconText .. usageText .. "<span font='Clear Sans Regular 11' foreground='#7745ff'> | </span>" .. tempText)


    prevUsage = usage
    prevIdle = idle
end

update_widget(cpuInfoWidget)

local updateTimer = timer({ timeout = 2 })
updateTimer:connect_signal("timeout", function() update_widget(cpuInfoWidget) end)
updateTimer:start()

return widgetContainer
