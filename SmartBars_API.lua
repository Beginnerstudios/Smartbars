--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.API ={}
local API = SmartBars.API
local Config
--Init------------------------------------
function API:Init()
Config = SmartBars.Config
end
--DevStrings--------------------------
local item = "item"
local spell = "spell"
local target = "target"
local player = "player"
--API:Functions-----------------------
function API:GetSpecialization()
    if Config:IsCurrentPatch() then
     GetSpecialization()    
    return  GetSpecialization()  
    else   
    return 0 
    end
end
function API:GetActionInfo(slotID)   
    return GetActionInfo(slotID)    
end
function API:GetActionTexture(slotID,actionType) 
    if actionType == spell then
    return GetSpellTexture(slotID) 
    elseif actionType ==item then
    return GetItemIcon(slotID) 
    end  
end
function API:GetActionCooldown(spellID,actionType)
    if  actionType==spell then
    return GetSpellCooldown(spellID)
    elseif actionType==item then
    return GetItemCooldown(spellID) 
    end

    
   
end
function API:GetBuildInfo()
    local iterface = select(4, GetBuildInfo(pvptalent))
    return iterface  
end
function API:IsUsableAction(action,actionType)
if actionType ==spell then
    local isUsable, notEnoughMana = IsUsableSpell(action)    
    return isUsable,notEnoughMana
    elseif actionType ==item then
    local  isUsable, notEnoughMana = IsUsableItem(action)   
    return isUsable,notEnoughMana   
    end   
end
function API:GetPlayerAuraBySpellID(spellID)   
    if Config:IsCurrentPatch() then
        if GetPlayerAuraBySpellID(spellID) == nil then
        return false
        else 
        return true
        end
    else   
       -- local buffIndex
       for buffIndex=1,32 do
        local buffID = select(10, UnitBuff(player, buffIndex))   
        if buffID ~=nil then 
            if buffID ==spellID then       
                return true
            end               
        end      
    end
end
   
      
end
function API:IsPVPTalent(spellID)
    if Config:IsCurrentPatch() then       
        local talents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
        for _,pvptalent in pairs(talents) do
            local talentID = select(6, GetPvpTalentInfoByID(pvptalent))
            if talentID == spellID then
                return true
            end
        end 
    else
      return false
    end

end
function API:GetActionCharges(slotID,actionType)  
 
 if actionType==item then
    local currentItemCharges = GetItemCount(slotID)
  
    if currentItemCharges == 0 or currentItemCharges==nil  then 
        return ""
    else 
      return currentItemCharges
    end
 elseif actionType ==spell then
    local currentSpellCharges = GetSpellCharges(slotID)
  
    if currentSpellCharges == 0 or currentSpellCharges==nil  then 
        return ""
    else 
      return currentSpellCharges
 end

  
    
 end
 
end
function API:GetUserActions()                                                           
    local slotCount = 120
    local allSlotTable = {}
        for i=1,slotCount do
            local actionType,actionID = API:GetActionInfo(i)
                 if actionID ~=nil and strmatch(actionID,"%d") and actionType==spell or actionType ==item then
                    allSlotTable[actionID] = {i,actionID,nil,"",currentSpecialization,actionType}           --- [1]slot id [2]spellID
                end
        end     
    return allSlotTable
end
function API:IsResting()
    return IsResting()
end
function API:IsPvPing()
    if Config:IsCurrentPatch() then
    return C_PvP.IsWarModeDesired()
    else
        return false
    end
end
function API:IsActionInRange(slotID,actionType) 
    if actionType ==spell then
        local spellName= GetSpellInfo(slotID)      
        if IsSpellInRange(spellName,target) == 1 or IsSpellInRange(spellName,target) ==nil then
            return true
        else
            return false
        end                
    end   
end
function API:GetDisplayedActionInfo(id,actionType)
    if actionType ==spell then
        local name = GetSpellInfo(id)
        return name
    end
    if actionType == item then
        local name = GetItemInfo(id)
        return name
    end
end
function API:GetFoundActionInfo(id)  
        if GetSpellInfo(id) then
            return {GetSpellInfo(id),"spell"}
        elseif not GetSpellInfo(id) then 
            return {GetItemInfo(id),"item"}
        end  
end
-- Revision version v1.0.9 ----

