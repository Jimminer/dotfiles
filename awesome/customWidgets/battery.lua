local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local widgetContainer = wibox.widget.container

local batteryInfoWidget = wibox.widget {
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

widgetContainer = {
    {
        {
            {
                {
                    widget = batteryInfoWidget,
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

local function runCommand(command)
    local fd = io.popen(command)
    local output = fd:read("*all")
    fd:close()

    return (output and output or "")
end

local naughty = require("naughty")
function printn(text)
    naughty.notify({ text = text })
end


local function update_widget(widget)
    local percentage = runCommand("upower -i $(upower -e | grep 'BAT') | grep percentage | awk '{print $2}'")
    local charging = runCommand("upower -i $(upower -e | grep 'BAT') | grep state | awk '{print $2}'") == "charging\n"
    
    local timeLeft = ""
    if charging then
        timeLeft = runCommand("upower -i $(upower -e | grep 'BAT') | grep \"time to full\" | awk '{print $4 \" \" $5}'")
    else
        timeLeft = runCommand("upower -i $(upower -e | grep 'BAT') | grep \"time to empty\" | awk '{print $4 \" \" $5}'")
    end
    
    percentage = string.gsub(string.gsub(percentage, "%%", ""), "\n", "")
    percentage = tonumber(percentage)
    
    timeLeft = string.gsub(timeLeft, "\n", "")

    if timeLeft == "" then
        timeLeft = "-- hours"
    end
    
    
    usageColor = (percentage < 30 and "#e33a6e") or (percentage < 50 and "#ffc936") or "#48d624"
    usageEmoji = (charging and "") or (percentage < 15 and "") or (percentage < 30 and "") or (percentage < 50 and "") or ""


    iconText = "<span font='Font Awesome 6 Pro Solid 11' foreground='#7745ff'>  " .. usageEmoji .. " </span>"
    usageText = "<span font='Sans-Serif 11' foreground='" .. usageColor .. "'>" .. percentage .. "% " .. timeLeft .. "  </span>"

    widget:set_markup(iconText .. usageText)
end

update_widget(batteryInfoWidget)

local updateTimer = timer({ timeout = 2 })
updateTimer:connect_signal("timeout", function() update_widget(batteryInfoWidget) end)
updateTimer:start()

return widgetContainer