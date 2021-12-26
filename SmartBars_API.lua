--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.API ={};
local API = SmartBars.API;
--Init------------------------------------
function API:Init()
   Config = SmartBars.Config
end
--API:Functions-----------------------
function API:GetSpecialization()
    local version,build,date = GetBuildInfo()
    if version == "9.1.5" or version == "9.2.0" then
     GetSpecialization()    
    return  GetSpecialization()  
    else   
    return 0 
    end
end
function API:GetActionInfo(slotID)   
    return GetActionInfo(slotID)    
end
function API:GetActionTexture(slotID)   
    return GetActionTexture(slotID)    
end
function API:GetActionCooldown(spellID)
    return GetActionCooldown(spellID)
end
function API:GetBuildInfo()
    local version,build,date = GetBuildInfo()
    return version  
end
function API:IsUsableAction(action)
    local isUsable, notEnoughMana = IsUsableAction(action) 
    return isUsable,notEnoughMana
end
function API:GetPlayerAuraBySpellID(spellID)   
    if Config:IsCurrentPatch() then
        if GetPlayerAuraBySpellID(spellID) == nill then
        return false
        else 
        return true
        end
    else   
        local buffIndex
       for buffIndex=1,32 do
        local   name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, 
        buffID, canApply = UnitBuff("player", buffIndex)     
        if buffID ~=nill then 
            if buffID ==spellID then       
                return true
            end               
        end      
    end
end
   
      
end
function API:GetActionCharges(slotID)
 if Config:IsCurrentPatch() then
  local currentCharges, maxCharges, cooldownStart, cooldownDuration, chargeModRate = GetActionCharges(slotID)
  if currentCharges == 0 then
      return ""
  else
    return currentCharges
  end
 else
    return ""
 end
end
function API:GetUserActions()                                                           
    local slotCount = 120
    local allSlotTable = {}
        for i=1,slotCount do
            local actionType,actionID,subType = API:GetActionInfo(i)
                 if actionID ~=nil and strmatch(actionID,"%d")  then
                    allSlotTable[actionID] = {i,actionID,nil,"",currentSpecialization}           --- [1]slot id [2]spellID
                end
        end     
    return allSlotTable
end
function API:IsResting()
    return IsResting()
end
function API:IsActionInRange(slotID)
    return IsActionInRange(slotID)
end
-- Revision version v0.8.8 ---

