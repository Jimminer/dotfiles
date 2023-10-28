function runCommand(command)
    local fd = io.popen(command)
    local output = fd:read("*all")
    fd:close()

    return (output and output or "")
end

return runCommand