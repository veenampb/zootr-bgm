local FILE = {}

local EXTENSION_TXT = '.txt'

function FILE.isTxt(filePath)
    local pathLength = string.len(filePath)
    local startIndex = pathLength - string.len(EXTENSION_TXT) + 1
    local pathExtension = string.sub(filePath, startIndex)

    return pathExtension == EXTENSION_TXT
end

function FILE.generateTableFromFileContents(file)
    if (file) then
        local fileSettingsTable = {}

        if (not(isExistingFile(file))) then
            return fileSettingsTable
        end

        for line in io.lines(file) do
            local key = getKeyFromFileLine(line)
            local value = getValueFromFileLine(line)

            if (key and value) then
                fileSettingsTable[key] = value
            end
        end

        return fileSettingsTable
    end
end

function getKeyFromFileLine(line)
    local key = ''
    local getMatches = string.gmatch(line, '[A-Z_]+')

    for text in getMatches do
        key = key .. text
    end

    return key
end

function getValueFromFileLine(line)
    local value = ''
    local getMatches = string.gmatch(line, '%d+')

    for text in getMatches do
        value = value .. text
    end

    return tonumber(value)
end

function isExistingFile(filePath)
    local file = nil

    file = assert(io.open(filePath))

    if (file) then
        file:close()
        return true
    end

    FORM.printOutput('[Error] File does not exist: ' .. filePath)
    return false
end

function FILE.writeSettingsTableToFile(filePath, settingsTable)
    local fileContent = ''

    for key, value in pairs(settingsTable) do
        fileContent = fileContent .. key
        fileContent = fileContent .. '='
        fileContent = fileContent .. tostring(value)
        fileContent = fileContent .. '\n'
    end

    file = io.open(filePath, 'w')
    file:write(fileContent)
    file:close()
end

return FILE