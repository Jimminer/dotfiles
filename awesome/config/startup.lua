local awful = require("awful")

local customCommands = require("customCommands")
local runCommand = customCommands.runCommand
local runInTag = customCommands.runInTag


-- Save a file in /tmp to indicate that awesome has initialized so that programs don't run again when awesome restarts
if (runCommand("test -f /tmp/awesome-startup && echo 1 || echo 0"):sub(0, -2) == "1") then
    return
else
    runCommand("touch /tmp/awesome-startup")
end


awful.spawn.with_shell("xrandr -s 2560x1440 -r 165")                                    -- set screen to 1440p 165Hz
awful.spawn.with_shell("xset -dpms")                                                    -- disable dpms | see https://wiki.archlinux.org/title/Display_Power_Management_Signaling
awful.spawn.with_shell("xset s off")                                                    -- disable screen saver
awful.spawn.with_shell("picom -b --config $HOME/.config/picom/picom.conf")              -- start picom compositor
awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")     -- start policy kit
awful.spawn.with_shell("copyq")                                                         -- start copyq (clipboard manager)
awful.spawn.with_shell("flameshot")                                                     -- start flameshot (screenshot utility)
awful.spawn.with_shell("sunshine")                                                      -- remote desktop control (through moonlight)
awful.spawn.with_shell("corectrl --minimize-systray")                                   -- start corectrl (cpu, gpu controller)
awful.spawn.with_shell("nm-applet")                                                     -- start network manager


-- awful.spawn.with_shell("xfce4-power-manager")
-- awful.spawn.with_shell("blueberry-tray")
-- awful.spawn.with_shell("mpd")


-- if runCommand("pgrep -f " .. "openrgb") == "" then
--     awful.spawn.with_shell("openrgb --startminimized --profile main")
-- end


-- if screen[1].tags[6] then
--     if runCommand("pgrep -f " .. "easyeffects") == "" then
--         runInTag("easyeffects", screen[1].tags[6])
--     end
-- else
--     if runCommand("pgrep -f " .. "easyeffects") == "" then
--         runInTag("easyeffects", screen[1].tags[5])
--     end
-- end
