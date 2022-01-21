--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.Global ={}
local Global=SmartBars.Global

---Init-------------------------------------
-- Global functions-----------------------
function Global:GetSmartBarsInfo()
    local smartBarsPublicVersion,smartBarsPublicBuild = SmartBars.Config:GetSmartBarsInfo() 
    return SmartBars.Localization.AddonName(),smartBarsPublicVersion,smartBarsPublicBuild 
end
-- Revision version v1.1.0 ----------------

