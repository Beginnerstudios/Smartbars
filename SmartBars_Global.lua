--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Global ={};
local Global=SmartBars.Global;
local Config
---Init-------------------------------------
function Global:Init()
    Config = SmartBars.Config    
end
-- Global functions-----------------------
function Global:GetSmartBarsPublicInfo()
    local smartBarsPublicVersion,smartBarsPublicBuild = Config:GetSmartBarsInfo() 
    return smartBarsPublicVersion,smartBarsPublicBuild 
end
-- Revision version v0.9.5 ---------------
