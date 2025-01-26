local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

languageChange = {}

local languageLayout = "us,gr"
local languages = { "us", "gr" }
local languageTitles = { "US", "GR" }
local currentLanguage = 1

languageChange.widget = wibox.widget.container

local languageWidget = wibox.widget {
    align = "center",
    valign = "center",
    forced_width = 65,
    widget = wibox.widget.textbox
}

languageChange.widget = {
    {
        {
            {
                {
                    widget = languageWidget,
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
    local iconText = "<span font='Font Awesome 6 Free 11' foreground='#7745ff'> </span>"
    local languageText = "<span font='Clear Sans Regular 11' foreground='#a47dff'>" .. languageTitles[currentLanguage] .. "</span>"

    languageWidget:set_markup(iconText .. languageText)
end

languageChange.initialize = function ()
    awful.spawn("setxkbmap -layout " .. languageLayout)
end

languageChange.switch = function ()
    currentLanguage = currentLanguage % #(languages) + 1

    if runCommand("setxkbmap -query | grep layout | awk '{print $2}'") ~= languageLayout then
        awful.spawn("setxkbmap -layout " .. languageLayout)
    end


    awful.spawn("xkb-switch -s " .. languages[currentLanguage])

    display()
end

languageChange.widget.buttons = awful.util.table.join(
    awful.button({ }, 1, function () languageChange.switch() end)
)

display()

return languageChange