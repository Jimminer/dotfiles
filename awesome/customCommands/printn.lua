local naughty = require("naughty")

function printn(text)
    naughty.notify({ text = text })
end

return printn