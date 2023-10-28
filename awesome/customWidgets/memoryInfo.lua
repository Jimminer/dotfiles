local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

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

local runCommand = require("customCommands.runCommand")
local printn = require("customCommands.printn")

-- if runCommand("playerctl status"):gsub("\n[^\n]*(\n?)$", "%1") == "Playing" then
--     local memoryInfoWidget = wibox.widget.textbox()
--     memoryInfoWidget:set_markup(markup.fontfg(beautiful.font, "#87af5f", runCommand("playerctl metadata title")))
--     table.insert(wiboxRightWidgets, memoryInfoWidget)
-- end

local function update_widget(widget)
    local total = runCommand("cat /proc/meminfo | grep MemTotal | awk '{print $2}'")
    local free = runCommand("cat /proc/meminfo | grep MemAvailable | awk '{print $2}'")
    -- local cached = runCommand("cat /proc/meminfo | grep Cached | head -n 1 | awk '{print $2}'")

    usage = (total-free)/total*100
    -- printn("total: " .. total .. " | free: " .. free .. " | cached: " .. cached .. " | usage: " .. usage)

    usageColor = (usage < 40 and "#48d624") or (usage < 80 and "#ffc936") or "#e33a6e"

    iconText = "<span font='Font Awesome 6 Free 11' foreground='#7745ff'>  </span>"
    usageText = "<span font='Clear Sans Regular 11' foreground='" .. usageColor .. "'>" .. math.floor(usage) .. "%  </span>"

    widget:set_markup(iconText .. usageText)
end

update_widget(memoryInfoWidget)

local updateTimer = timer({ timeout = 2 })
updateTimer:connect_signal("timeout", function() update_widget(memoryInfoWidget) end)
updateTimer:start()

return widgetContainer
