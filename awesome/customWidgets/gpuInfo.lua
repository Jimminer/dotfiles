local wibox = require("wibox")
local gears = require("gears")
local customCommands = require("customCommands")
local readFile = customCommands.readFile

local usage = 0
local totalMem = 0
local usedMem = 0
local temp = 0
local mem = 0

local widgetContainer = wibox.widget.container

local gpuInfoWidget = wibox.widget {
    align = "center",
    valign = "center",
    forced_width = 195,
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

local function update_widget(widget)
    usage = tonumber(readFile.read("/sys/class/drm/card1/device/gpu_busy_percent", "l")) or 0
    totalMem = tonumber(readFile.read("/sys/class/drm/card1/device/mem_info_vram_total", "l")) or 0
    usedMem = tonumber(readFile.read("/sys/class/drm/card1/device/mem_info_vram_used")) or 0
    temp = tonumber(readFile.read("/sys/class/hwmon/hwmon0/temp1_input"):sub(0, -5)) or 0

    mem = usedMem / totalMem * 100 or 0

    local usageColor = (usage < 40 and "#48d624") or (usage < 80 and "#ffcf4d") or "#e33a6e"
    local memColor = (mem < 40 and "#48d624") or (mem < 80 and "#ffcf4d") or "#e33a6e"
    local tempColor = (temp < 60 and "#48d624") or (temp < 80 and "#ffcf4d") or "#e33a6e"


    local iconText = "<span font='Font Awesome 6 Free 11' foreground='#7745ff'>  </span>"
    local usageText = "<span font='Clear Sans Regular 11' foreground='" .. usageColor .. "'>" .. math.floor(usage) .. "%</span>"
    local memText = "<span font='Clear Sans Regular 11' foreground='" .. memColor .. "'>" .. math.floor(mem) .. "%</span>"
    local tempText = "<span font='Clear Sans Regular 11' foreground='" .. tempColor .. "'>" .. math.floor(temp) .. "°C  </span>"


    widget:set_markup(iconText .. usageText .. "<span font='Clear Sans Regular 11' foreground='#7745ff'> | </span>" .. memText .. "<span font='Clear Sans Regular 11' foreground='#7745ff'> | </span>" .. tempText)
end

update_widget(gpuInfoWidget)

local updateTimer = gears.timer({ timeout = 2 })
updateTimer:connect_signal("timeout", function() update_widget(gpuInfoWidget) end)
updateTimer:start()

return widgetContainer