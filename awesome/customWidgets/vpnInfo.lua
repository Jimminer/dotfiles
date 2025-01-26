local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

vpnInfo = {}

local vpnCountry = "GR"
local vpnConnectCommand = "nordvpn c " .. vpnCountry
local vpnDisconnectCommand = "nordvpn d"
local vpnWidgetEmoji = ""
local vpnWidgetText = "No VPN"
local vpnWidgetColor = "#ffcf4d"

vpnInfo.widget = wibox.widget.container

local vpnInfoWidget = wibox.widget {
    align = "center",
    valign = "center",
    forced_width = 100,
    widget = wibox.widget.textbox
}

vpnInfo.widget = {
    {
        {
            {
                {
                    widget = vpnInfoWidget,
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

local function display()
    local iconText = "<span font='Font Awesome 6 Free 11' foreground='#7745ff'>" .. vpnWidgetEmoji .. " </span>"
    local vpnText = "<span font='Clear Sans Regular 11' foreground='" .. vpnWidgetColor .. "'>" .. vpnWidgetText .. "</span>"

    vpnInfoWidget:set_markup(iconText .. vpnText)
end

local function initialize()
    awful.spawn.easy_async_with_shell("nordvpn status | grep Server | awk '{print $3}'", function (server)
        if server == "" then
            vpnWidgetEmoji = ""
            vpnWidgetText = "No VPN"
            vpnWidgetColor = "#ffcf4d"
        else
            vpnWidgetEmoji = ""
            vpnWidgetText = vpnCountry .. " " .. server
            vpnWidgetColor = "#48d624"
        end

        display()
    end)
end

vpnInfo.connect = function ()
    awful.spawn.easy_async_with_shell(vpnConnectCommand .. " | grep connected | awk '{print $6}'", function (server)
        if server == "" then
            return
        end

        vpnWidgetEmoji = ""
        vpnWidgetText = vpnCountry .. " " .. server
        vpnWidgetColor = "#48d624"

        display()
    end)
end

vpnInfo.disconnect = function ()
    awful.spawn(vpnDisconnectCommand)

    vpnWidgetEmoji = ""
    vpnWidgetText = "No VPN"
    vpnWidgetColor = "#ffcf4d"

    display()
end

vpnInfo.widget.buttons = awful.util.table.join(
    awful.button({ }, 1, function () vpnInfo.connect() end),
    awful.button({ }, 3, function () vpnInfo.disconnect() end)
)

initialize()

return vpnInfo