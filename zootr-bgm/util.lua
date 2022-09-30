--[[
    Utility functions

    Common functions used to interpret and handle values and data in Lua.
]]--

local UTIL = {}

local OR, XOR, AND = 1, 3, 4

local OPER = {
    ['OR'] = OR,
    ['XOR'] = XOR,
    ['AND'] = AND,
}

function UTIL.bitoper(a, b, oper)
    local oper_int = OPER[oper] or AND

    local r, m, s = 0, 2^31

    repeat
        s,a,b = a+b+m, a%m, b%m
        r,m = r + m*oper_int%(s-a-b), m/2
    until m < 1

    return r
end

function UTIL.tableHasValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function UTIL.valueToHexString(value)
    local bgm_hex = string.format('%x', value) -- "1E"
    bgm_hex = string.upper(bgm_hex)

    if string.len(bgm_hex) < 2 then
        bgm_hex = '0' .. bgm_hex
    end

    bgm_string = '0x' .. bgm_hex

    return bgm_string
end

function UTIL.sortTableByProp(tab, prop)
    local newTable = {}
    local newTableKeyMap = {}

    for k in pairs(tab) do
        local d = tab[k]
        local p = d[prop]
        table.insert(newTable, p)
        newTableKeyMap['' .. p] = k
    end

    table.sort(newTable)

    local i = 0

    local iter = function()
        i = i + 1

        if (newTable[i] == nil) then
            return nil
        else
            local key = newTableKeyMap['' .. i]
            return key, tab[key]
        end
    end

    return iter
end

function UTIL.getTableSize(tab)
    local count = 0

    for key in pairs(tab) do
        count = count + 1
    end

    return count
end

-- Filters out any table entries that do not match the keys of the passed in table
function UTIL.filterTableByMatchingKeys(tableToMatch, tableToFilter)
    local filteredTable = {}

    for key in pairs(tableToFilter) do
        if (tableToMatch[key]) then
            filteredTable[key] = tableToFilter[key]
        end
    end

    return filteredTable
end

-- Filters out any table entries that do not contain props matching the keys of the passed in table
function UTIL.filterTableByMatchingProps(propsToMatch, tableToFilter)
    local filteredTable = {}

    for key in pairs(tableToFilter) do
        local item = tableToFilter[key]
        local hasMatch = false

        for propKey, prop in pairs(propsToMatch) do
            if (item[prop]) then
                hasMatch = true
            end
        end

        if (hasMatch) then
            filteredTable[key] = tableToFilter[key]
        end
    end

    return filteredTable
end

return UTIL
