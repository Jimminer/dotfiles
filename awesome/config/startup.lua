local awful = require("awful")

local customWidgets = require("customWidgets")
local customCommands = require("customCommands")
-- local runCommand = customCommands.runCommand
-- local runInTag = customCommands.runInTag

-- Save a file in /tmp to indicate that awesome has initialized so that programs don't run again when awesome restarts
local file = io.open("/tmp/awesome-startup", "r")
if file then
    file:close()
    return
end

-- Create the /tmp file
io.open("/tmp/awesome-startup", "w"):close()

-- Symlink rofi cache from ~/.config to ~/.cache
os.execute("mkdir -p ~/.cache && ln -s ~/.config/rofi/rofi3.druncache ~/.cache/rofi3.druncache")

-- Start programs
awful.spawn.easy_async("true", function ()
    awful.spawn("xrandr -s 2560x1440 -r 165")                                           -- set screen to 1440p 165Hz
    awful.spawn("xset -dpms")                                                           -- disable dpms | see https://wiki.archlinux.org/title/Display_Power_Management_Signaling
    awful.spawn("xset s off")                                                           -- disable screen saver
    awful.spawn("nm-applet")                                                            -- network manager
    awful.spawn("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")            -- policy kit
    awful.spawn("thunar --daemon")
    awful.spawn("copyq")                                                                -- copyq (clipboard manager)
    awful.spawn("flameshot")                                                            -- flameshot (screenshot utility)
    awful.spawn("corectrl --minimize-systray")                                          -- corectrl (cpu, gpu controller)
    awful.spawn("openrgb --startminimized --profile main")
    awful.spawn.with_shell("picom -b --config $HOME/.config/picom/picom.conf")          -- picom compositor
    awful.spawn.with_shell("echo -e '\n\n'$(date) | tee -a ~/.logs/sunshine.log ~/.logs/sunshine_errors.log && sunshine 1>> ~/.logs/sunshine.log 2>> ~/.logs/sunshine_errors.log") -- remote desktop server
    awful.spawn("xmodmap " .. os.getenv("HOME") .. "/.config/xmodmap/disable-caps-lock.xmodmap")
    awful.spawn("xmodmap " .. os.getenv("HOME") .. "/.config/xmodmap/right-alt-to-left-super.xmodmap")
end)

-- Start programs after a delay
awful.spawn.easy_async_with_shell("sleep 5", function ()
    customWidgets.languageChange.initialize()
    -- awful.spawn("setxkbmap -option caps:none")
end)

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
