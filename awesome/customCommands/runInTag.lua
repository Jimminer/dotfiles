local awful = require("awful")

local function runInTag(program, tag)
    awful.tag.viewonly(tag)
    awful.spawn.with_shell(program)
    -- if not checkExists then
        -- awful.spawn.with_shell(program)
    --     return
    -- end

    -- local rule = { class = class }
    -- local c = awful.spawn.raise_or_spawn(program, rule)
    -- for _, c in ipairs(client.get()) do
    --     if awful.rules.match(c, rule) then
    --         naughty.notify({ text = "exists" })
    --         client.focus = c
    --         c:move_to_tag(tag)
    --         return
    --     end
    -- end

end