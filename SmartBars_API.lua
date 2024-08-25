-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.API = {}
local API = SmartBars.API
local Config
-- Init------------------------------------
function API:Init()
    Config = SmartBars.Config
end
-- DevStrings--------------------------
local item = "item"
local spell = "spell"
local target = "target"
local player = "player"
-- API:Functions-----------------------
function API:GetSpecialization()
    if Config:IsCurrentPatch() then
        GetSpecialization()
        return GetSpecialization()
    else
        return 0
    end
end
function API:IsInCinematic()
        return IsInCinematicScene()
end
function API:GetActionInfo(slotID)
    return GetActionInfo(slotID)
end
function API:GetActionTexture(slotID, actionType)
    if actionType == spell then
        return C_Spell.GetSpellTexture(slotID)
    elseif actionType == item then
        return C_Item.GetItemIconByID(slotID)
    else
        return "image.tga"
    end
end
function API:GetActionCooldown(spellID, actionType)
    local value = nil;
    if actionType == spell then
        local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID);
        if spellCooldownInfo then
            value = spellCooldownInfo.duration
        end
    elseif actionType == item then
        local startTimeSeconds, durationSeconds, enableCooldownTimer = C_Item.GetItemCooldown(spellID);
        if durationSeconds then
            value = durationSeconds
        end
    else
    end
    return value
end
function API:GetBuildInfo()
    return select(4, GetBuildInfo())
end
function API:IsUsableAction(action, actionType)
    if actionType == spell then
        local isUsable, notEnoughMana = C_Spell.IsSpellUsable(action)
        return isUsable, notEnoughMana
    elseif actionType == item then
        local isUsable, notEnoughMana = C_Item.IsUsableItem(action)
        return isUsable, notEnoughMana
    end
end
function API:GetPlayerAuraBySpellID(spellID, actionType)
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
    if spellID == 26573 then
        local consecration = C_UnitAuras.GetPlayerAuraBySpellID(188370)
        return consecration
    end
    if aura ~= nil then
        if aura.spellId == 192081 then
            return nil
        end
        if aura.spellId == 388193 then
            return nil
        end
    end


    return aura
end

function API:IsPVPTalent(spellID)
    if Config:IsCurrentPatch() then
        local talents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
        for _, pvptalent in pairs(talents) do
            local talentID = select(6, GetPvpTalentInfoByID(pvptalent))
            if talentID == spellID then
                return true
            end
        end
    else
        return false
    end

end
function API:isNotOnActionBars(actionId, actionType)
    local isPresent = true
    local slotCount = 120;
    for i = 1, slotCount do
        local type, actionID = API:GetActionInfo(i)
        if actionID ~= nil then
            if actionId == actionID then
                isPresent = false
            end
        end
    end
    return isPresent
end

function API:GetActionCharges(slotID, actionType)
    if actionType == item then
        local currentItemCharges = GetItemCount(slotID)
        if currentItemCharges == 0 or currentItemCharges == nil then
            return ""
        else
            return currentItemCharges
        end
    elseif actionType == spell then
        local chargeInfo = C_Spell.GetSpellCharges(slotID)
        -- Check if the chargeInfo is valid (not nil)
        if chargeInfo then
            -- Return the number of current charges
            return chargeInfo.currentCharges
        else
            -- Return nil if the spell is not found or is not charge-based
            return ""
        end
    end

end
function API:GetUserActions()
    local slotCount = 120
    local allSlotTable = {}
    for i = 1, slotCount do
        local actionType, actionID = API:GetActionInfo(i)
        if actionID ~= nil and strmatch(actionID, "%d") and actionType == spell or actionType == item then
            allSlotTable[actionID] = {i, actionID, nil, "", currentSpecialization, actionType} --- [1]slot id [2]spellID
        end
    end
    return allSlotTable
end
function API:IsResting()
    if (IsResting()) then
        return true
    end
    return false
end
function API:IsPvPing()
    if Config:IsCurrentPatch() then
        return C_PvP.IsWarModeDesired()
    else
        return false
    end
end
function API:IsActionInRange(spellID, actionType)
    local isInRange = nil
    if actionType == "spell" then
        isInRange = C_Spell.IsSpellInRange(spellID, "target")
    end
    -- Return true if isInRange is either true or nil
    return isInRange ~= false
end
function API:GetDisplayedActionInfo(id, actionType)
    if actionType == spell then
        local spellInfo = C_Spell.GetSpellInfo(id)

        -- Check if the spellInfo is valid (not nil)
        if spellInfo then
            -- Return the name of the spell
            return spellInfo.name
        else
            -- Return nil if the spell is not found
            return ""
        end
    end
    if actionType == item then
        local name = GetItemInfo(id)
        return name
    end
end
function API:GetFoundActionInfo(id)
    if (id == nill) then
        return
    end
    if C_Spell.GetSpellInfo(id) then
        return {C_Spell.GetSpellInfo(id), "spell"}
    elseif not C_Spell.GetSpellInfo(id) then
        return {GetItemInfo(id), "item"}
    end
end
-- Revision version v1.1.2 ----

