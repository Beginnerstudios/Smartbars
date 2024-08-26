-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Utils = {}
local Utils = SmartBars.Utils
-- Utils-----------------------------------
function Utils:GetTableCount(tableArg)
    local count = 0
    if tableArg ~= nil then
        for _ in pairs(tableArg) do
            count = count + 1
        end
    end
    return count
end
function Utils:IsValueSame(value1, value2)
    if value1 == value2 then
        return true
    else
        return false
    end
end
function Utils:JoinNumber(x, y)
    local z = tostring(x) .. tostring(y)
    return tonumber(z)
end
function Utils:RoundNumber(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces) .. "f", num))
end
-- Revision version v 1.1.1 ---------------
