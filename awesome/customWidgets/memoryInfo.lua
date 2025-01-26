local wibox = require("wibox")
local gears = require("gears")
local customCommands = require("customCommands")
local readFile = customCommands.readFile

local total = 0
local free = 0
local usage = 0

local widgetContainer = wibox.widget.container

local memoryInfoWidget = wibox.widget {
    align = "center",
    valign = "center",
    forced_width = 85,
    widget = wibox.widget.textbox
}

widgetContainer = {
    {
        {
            {
                {
                    widget = memoryInfoWidget,
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
    local data = readFile.readRowsColumns("/proc/meminfo") or {}

    total = data[1][2] or 0
    free = data[3][2] or 0

    usage = (total-free)/total*100

    local usageColor = (usage < 40 and "#48d624") or (usage < 80 and "#ffc936") or "#e33a6e"

    local iconText = "<span font='Font Awesome 6 Free 11' foreground='#7745ff'>  </span>"
    local usageText = "<span font='Clear Sans Regular 11' foreground='" .. usageColor .. "'>" .. math.floor(usage) .. "%  </span>"

    widget:set_markup(iconText .. usageText)
end

update_widget(memoryInfoWidget)

local updateTimer = gears.timer({ timeout = 2 })
updateTimer:connect_signal("timeout", function() update_widget(memoryInfoWidget) end)
updateTimer:start()

return widgetContainer