local wibox = require("wibox")
local awful = require("awful")

nowPlayingWidget = wibox.widget.textbox()

local runCommand = require("customCommands.runCommand")
local printn = require("customCommands.printn")

-- if runCommand("playerctl status"):gsub("\n[^\n]*(\n?)$", "%1") == "Playing" then
--     local nowPlayingWidget = wibox.widget.textbox()
--     nowPlayingWidget:set_markup(markup.fontfg(beautiful.font, "#87af5f", runCommand("playerctl metadata title")))
--     table.insert(wiboxRightWidgets, nowPlayingWidget)
-- end

local function update_widget(widget)
    if runCommand("playerctl status") ~= "Playing\n" then
        widget:set_markup("<span font='Clear Sans Regular 9' foreground='#FFC830'> Nothing Playing </span>")
        return
    end

    local title = runCommand("playerctl metadata title")
    widget:set_markup("<span font='Clear Sans Regular 9' foreground='#FFC830'> " .. title .. " </span>")
end

update_widget(nowPlayingWidget)

local updateTimer = timer({ timeout = 0.3 })
updateTimer:connect_signal("timeout", function() update_widget(nowPlayingWidget) end)
updateTimer:start()

return nowPlayingWidget