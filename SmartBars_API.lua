-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.API = {}
local API = SmartBars.API
local Config
local Utils
-- Init------------------------------------
function API:Init()
    Config = SmartBars.Config
    Utils = SmartBars.Utils
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
function API:GetSpecializatonNameFromIndex(specIndex)
return select(2, GetSpecializationInfo(specIndex))
end
function API:IsInCinematic()
        return IsInCinematicScene() or InCinematic()
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
    if spellID == 224572 then
            local rite = C_UnitAuras.GetPlayerAuraBySpellID(453250)
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
    local currentSpec = Config:GetSpec()
    local allSlotTable = {}
    for i = 1, slotCount do
        local actionType, spellId = API:GetActionInfo(i)
        if spellId ~= nil and strmatch(spellId, "%d") and actionType == spell or actionType == item then
            local actionId =Utils:JoinNumber(tonumber(spellId),tonumber(currentSpec));
            allSlotTable[actionId] = {}
            allSlotTable[actionId].slotId = i
            allSlotTable[actionId].spellId = tonumber(spellId)
            allSlotTable[actionId].widget = nil
            allSlotTable[actionId].actionText = emptyString
            allSlotTable[actionId].currentSpec = currentSpec
            allSlotTable[actionId].trackedFrame = nil
            allSlotTable[actionId].isBoosted = false
            allSlotTable[actionId].showOnlyWhenBoosted = false
            allSlotTable[actionId].priority = 5
            allSlotTable[actionId].actionType = actionType
            allSlotTable[actionId].isPvpTalent = API:IsPVPTalent(spellId)
        end
    end
    return allSlotTable
end
function API:isSpellKnown(spellID,actionType)
    if(actionType==spell) then
        return IsSpellKnownOrOverridesKnown(spellID, false)
    else
        return true
    end
end
function API:isGliding()
    return C_PlayerInfo.GetGlidingInfo()
end
function API:isPlayerMounted()
    return IsMounted()
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
-- Revision BUILD 206(R)

