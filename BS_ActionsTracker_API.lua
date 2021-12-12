--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.API ={};
local API = BS_ActionsTracker.API;
--Init------------------------------------
function API:Init()
   -- UI = BS_ActionsTracker.UI
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

