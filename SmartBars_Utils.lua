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
function Utils:IsTableEmpty(tableArg)
    if tableArg == nil then
        return true
    else
        return false
    end
end
function Utils:IsValueSame(value1, value2)
    if value1 == value2 then
        return true
    else
        return false
    end
end
function Utils:DebugActions(actionsTable,optionalString)
    if(optionalString) then
        print("START DEBUG----------"..optionalString.."---------------")
    else
        print("START DEBUG---------- NOT SPECIFIED---------------")
    end
    for key, value in pairs(actionsTable) do
        print("[KEY]Action ID - " .. key)
        print("Slot ID - " .. value.slotId)
        print("Spell ID - " .. value.spellId)
        print("Widget - " .. tostring(value.widget))
        print("Action Text - " .. value.actionText)
        print("Current Spec - " .. value.currentSpec)
        print("Tracked Frame - " .. value.trackedFrame)
        print("Is Boosted - " .. tostring(value.isBoosted))
        print("Show Only When Boosted - " .. tostring(value.showOnlyWhenBoosted))
        print("Action Type - " .. value.actionType)
        print("Is PvP Talent - " .. tostring(value.isPvpTalent))
        print("Priority - " .. tostring(value.priority))
        print("END DEBUG--------------------------")
    end
end
function Utils:JoinNumber(x, y)
    return tonumber(tostring(x) .. tostring(y))
end
function Utils:RoundNumber(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces) .. "f", num))
end
-- Revision BUILD 206(R)
