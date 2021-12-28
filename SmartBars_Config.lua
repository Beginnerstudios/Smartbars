--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Config ={};
local Config = SmartBars.Config;
local UI
local Core
local Actions
local Global
--Init------------------------------------
function Config:Init()
    UI = SmartBars.UI
    Core = SmartBars.Core
    Actions = SmartBars.Actions
    Global = SmartBars.Global
    API = SmartBars.API
end
--Config:Functions------------------------
local isConfigMode = false
local currentSpecialization
local isCleared
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
    TrackedSpellsCharacter = Actions:GetTracked()   
    SmartBarsSettings = {UI:Get():FramesPosition(),UI:Get():FramesScale(),UI:Get():FramesAlpha(),UI:Get():FramesColumn(),UI:Get():FramesHideRest(),UI:Get():ActionBarCount(),UI:Get():HideInSaveZone(),isCleared}
end
function Config:LoadConfig()  
Actions:SetSavedVariables(TrackedSpellsCharacter)
UI:SetSavedVariables(
    SmartBarsSettings[1], --framesposition
    SmartBarsSettings[2], --framesscale
    SmartBarsSettings[3], --framesalpha
    SmartBarsSettings[4], --framescolumn
    SmartBarsSettings[5],  --framesrest
    SmartBarsSettings[6],  --global action bar count
    SmartBarsSettings[7]  --global hide in restzone    
)
isCleared = SmartBarsSettings[8]  --global isCleared value
currentSpecialization = API:GetSpecialization()
end
function Config:SetDefaults()
    if not TrackedSpellsCharacter then
        TrackedSpellsCharacter = {}      
    end
    if not SmartBarsSettings then
        SmartBarsSettings = {{},{},{},{},{},1,false,false}     
    end  
end
function Config:IsCurrentPatch()
if API:GetBuildInfo()>90000 then
    return true
else
    return false
end
end
function Config:IsConfigMode()
 return isConfigMode
end
function Config:ResetActions()  
    TrackedSpellsCharacter=nill
    ReloadUI()
end
function Config:ResetSettings()
    SmartBarsSettings =nill
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
function Config:DisableOldAddon()
    local name, title, notes, enabled, loadable, reason, security =GetAddOnInfo("BS_ActionsTracker")
    if enabled then
        DisableAddOn("BS_ActionsTracker")
        print("SmartBars - old version of this addon was found enabled(BS_ActionsTracker), it is not possible to have both addons active, so BS_ActionsTracker was disabled.Delete BS_ActionsTracker folder from --/interface/addons. if you dont want get this notification again.")      
    end 
end  
-- Revision version v0.9.0 -----
