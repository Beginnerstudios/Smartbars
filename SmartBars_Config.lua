--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Config ={};
local Config = SmartBars.Config;
--Init------------------------------------
function Config:Init()
    UI = SmartBars.UI
    Core = SmartBars.Core
    Actions = SmartBars.Actions
    Global = SmartBars.Global
end
--Config:Functions------------------------
local isConfigMode = false
local currentSpecialization
--Config:Functions------------------------
function Config:CreateCommands()
    SLASH_BS1 = "/bs"
    SLASH_SB1 = "/sb"
    SlashCmdList["BS"] = function(msg)
    Config:ToggleConfigMode()
    end
    SlashCmdList["SB"] = function(msg)
    Config:ToggleConfigMode()
    end
end
function Config:ToggleConfigMode()
    local primaryFrame = UI:Get():PrimaryFrame()
    local usedActions = API:GetUserActions()

    if  isConfigMode==false then    
        Actions:Display(usedActions,primaryFrame,true);  
        primaryFrame:Show()                
        isConfigMode =true           
        UI:ToggleWidgets(true)            
    else
        primaryFrame:Hide()                                               
        UI:ToggleWidgets(false)
        Config:SaveConfig()
        isConfigMode =false 
end
UI:UpdateUI()
end
function Config:SaveConfig()
    TrackedSpellsFramePosition = UI:Get():ActionBarsPositions()
    TrackedActionsColumnCount = UI:Get():ColumnCount()
    TrackedActionsFrameScale = UI:Get():ActionBar(1):GetScale()
    TrackedSpellsCharacter = Actions:GetTracked()
    TrackedActionsFrameCount = UI:Get():ActionBarCount()
    TrackedActionsHideInRestZone =UI:Get():HideInSaveZone()
    TrackedActionsFrameAlpha = UI:Get():ActionBar(1):GetAlpha()
   
end
function Config:LoadConfig()
UI:SetSavedVariables(TrackedSpellsFramePosition,TrackedActionsColumnCount,TrackedActionsFrameScale,TrackedActionsFrameCount,TrackedActionsHideInRestZone,TrackedActionsFrameAlpha)    
Actions:SetSavedVariables(TrackedSpellsCharacter)
Config:SetSpec(API:GetSpecialization())
end
function Config:SetDefaults()
    if not IsCleared then
       IsCleared = false
    end
    if not TrackedSpellsCharacter then
        TrackedSpellsCharacter = {}      
    end
    if not TrackedActionsFrameCount then
        TrackedActionsFrameCount = 1     
    end
    if not TrackedSpellsFramePosition then
      TrackedSpellsFramePosition ={}         
    end
    if not TrackedActionsColumnCount then
      TrackedActionsColumnCount = 5       
    end   
    if not TrackedActionsHideInRestZone then
        TrackedActionsHideInRestZone = false
    end
    if not TrackedActionsFrameScale then
    TrackedActionsFrameScale = 1
    end
    if not TrackedActionsFrameAlpha then
        TrackedActionsFrameAlpha = 1     
    end   
end
function Config:IsCurrentPatch()
if API:GetBuildInfo() == "9.1.5" or API:GetBuildInfo() == "9.2.0" then
    return true
else
    return false
end
end
function Config:IsConfigMode()
 return isConfigMode
end
function Config:ResetAll()
    TrackedSpellsFramePosition = nill
    TrackedActionsColumnCount=nill
    TrackedActionsFrameScale=nill
    TrackedSpellsCharacter=nill
    TrackedActionsFrameCount=nill
    TrackedActionsHideInRestZone=nill
    ReloadUI()
end
--Getter&Setter----------------------------
function Config:GetSpec()
    return currentSpecialization   
end
function Config:GetResting()
    return API:IsResting()
end
function Config:SetSpec(currentSpec)
    currentSpecialization = currentSpec    
end
-- Utils-----------------------------------
function Config:GetTableCount(tableArg)
    local count = 0
    if tableArg ~=nill then
        for _ in pairs(tableArg) do count = count + 1 end    
    end
    return count      
end
function Config:IsValueSame(value1,value2)
    if value1 == value2 then
      return true
    else
      return false
    end
end
function Config:JoinNumber(x, y)
    local z = tostring(x) .. tostring(y);
    return tonumber(z);
end  
-- Revision version v0.8.6 -----
