local wibox = require("wibox")
local gears = require("gears")
local customCommands = require("customCommands")
local readFile = customCommands.readFile

local prevUsage = 0
local prevIdle = 0
local usage = 0
local idle = 0
local temp = 0

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


local function update_widget(widget)
    local columns = readFile.readLineColumns("/proc/stat", "l") or {}
    
    usage = (columns[2] + columns[3] + columns[4] + columns[5] + columns[6] + columns[7] + columns[8] + columns[9] + columns[10]) or 0
    idle = columns[5] or 0

    temp = tonumber(readFile.read("/sys/class/hwmon/hwmon1/temp1_input", "l"):sub(0, -4)) or 0
    
    local current = ( 1000 * ((usage-prevUsage) - (idle - prevIdle)) / (usage - prevUsage) + 5) / 10

    local usageColor = (current < 40 and "#48d624") or (current < 80 and "#ffc936") or "#e33a6e"
    local tempColor = (temp < 60 and "#48d624") or (temp < 80 and "#ffc936") or "#e33a6e"


    local iconText = "<span font='Font Awesome 6 Free 11' foreground='#7745ff'>  </span>"
    local usageText = "<span font='Clear Sans Regular 11' foreground='" .. usageColor .. "'>" .. math.floor(current) .. "%</span>"
    local tempText = "<span font='Clear Sans Regular 11' foreground='" .. tempColor .. "'>" .. math.floor(temp) .. "°C  </span>"
    
    prevUsage = usage
    prevIdle = idle

    widget:set_markup(iconText .. usageText .. "<span font='Clear Sans Regular 11' foreground='#7745ff'> | </span>" .. tempText)
end

update_widget(cpuInfoWidget)

local updateTimer = gears.timer({ timeout = 2 })
updateTimer:connect_signal("timeout", function() update_widget(cpuInfoWidget) end)
updateTimer:start()

return widgetContainer