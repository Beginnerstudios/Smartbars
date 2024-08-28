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
local emptyString =""
-- API:Functions-----------------------
function API:GetSpecialization()
    return GetSpecialization()
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
        return emptyString
    end
end
function API:GetActionCooldown(spellID, actionType)
    local value
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
function API:GetPlayerAuraBySpellID(spellID)
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
    if spellID == 26573 then
        local consecration = C_UnitAuras.GetPlayerAuraBySpellID(188370)
        return consecration
    end
    if spellID == 433568 then
        local rite = C_UnitAuras.GetPlayerAuraBySpellID(433550)
        return rite
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
        local talents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
        for _, pvptalent in pairs(talents) do
            local talentID = select(6, GetPvpTalentInfoByID(pvptalent))
            if talentID == spellID then
                return true
            else
                return false
            end
        end
end
function API:GetActionCharges(actionId, actionType)
    if actionType == item then
        local currentItemCharges = GetItemCount(actionId)
        return (currentItemCharges and currentItemCharges > 0) and currentItemCharges or emptyString
    elseif actionType == spell then
        local chargeInfo = C_Spell.GetSpellCharges(actionId)
        return chargeInfo and chargeInfo.currentCharges or emptyString
    end
end
function API:GetUserActions()
    local slotCount = 120
    local allSlotTable = {}
    for i = 1, slotCount do
        local actionType, actionID = API:GetActionInfo(i)
        if actionID ~= nil and strmatch(actionID, "%d") and actionType == spell or actionType == item then
            allSlotTable[actionID] = {i, actionID, nil, emptyString, Config:GetSpec(), actionType} --- [1]slot id [2]spellID
        end
    end
    return allSlotTable
end
function API:IsResting()
    return IsResting()
end
function API:IsPVP()
        return C_PvP.IsWarModeDesired()
end
function API:IsActionInRange(spellID, actionType)
    local isInRange
    if actionType == spell then
        isInRange = C_Spell.IsSpellInRange(spellID, target)
    end
    return isInRange ~= false
end
function API:GetActionName(actionId, actionType)
    if actionType == spell then
        return C_Spell.GetSpellInfo(actionId).name
    end
    if actionType == item then
        return GetItemInfo(actionId)
    end
end
-- Revision version v11.0.2 ----

