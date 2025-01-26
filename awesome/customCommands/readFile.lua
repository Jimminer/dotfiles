readFile = {}

readFile.read = function (file, mode)
    local f = io.open(file, "r")

    if f == nil then
        return nil
    end

    local content = f:read(mode or "*a")

    io.close(f)

    return content
end

readFile.readLineColumns = function (file, mode)
    local f = io.open(file, "r")

    if f == nil then
        return nil
    end

    local content = f:read(mode or "*a")

    local columns = {}
    for column in content:gmatch("%S+") do
        table.insert(columns, column)
    end

    io.close(f)

    return columns
end

readFile.readRowsColumns = function (file)
    local f = io.open(file, "r")

    if f == nil then
        return nil
    end

    local rows = {}

    for content in f:lines() do
        local columns = {}

        for column in content:gmatch("%S+") do
            table.insert(columns, column)
        end

        table.insert(rows, columns)
    end

    io.close(f)

    return rows
end

return readFile