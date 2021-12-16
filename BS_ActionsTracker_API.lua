--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.API ={};
local API = BS_ActionsTracker.API;
--Init------------------------------------
function API:Init()
   Config = BS_ActionsTracker.Config
end
--Variables--------------------------------
local trackedActions = {}
local currentSpecialization =0
--API:Functions-----------------------
function API:GetSpecialization()
    local version,build,date = GetBuildInfo()
    if version == "9.1.5" then
    return GetSpecialization()
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
    return notEnoughMana
end
function API:GetPlayerAuraBySpellID(spellID)
    local version,build,date = GetBuildInfo()
    if version == "9.1.5" then
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


