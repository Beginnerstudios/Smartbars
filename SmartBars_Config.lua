--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.Config ={}
local Config = SmartBars.Config
local UI
local Actions
local ActionBars
local Localization
local Core
local Global
local API
--Init------------------------------------
function Config:Init()
    UI = SmartBars.UI
    Core = SmartBars.Core
    Actions = SmartBars.Actions
    Global = SmartBars.Global
    API = SmartBars.API
    ActionBars = SmartBars.ActionBars
    Localization = SmartBars.Localization
end
--Config:Functions------------------------
local isConfigMode = false
local currentSpecialization
local isCleared
local globalHideRest
local pvp
local resting
--Save data---
local currentSaveVersion =99.1
local savedSaveVersion
---Public version----------
local currentVersion = "v - 1.0.2 BETA"
local publicBuild = 99
--Config:Functions------------------------
function Config:CreateCommands()
    SLASH_SB1 = "/sb"
    SlashCmdList["SB"] = function()
    Config:Toggle()
    end
end
function Config:Toggle()
    if  isConfigMode==false then   
        UI:Create()              
        isConfigMode =true           
        ActionBars:Toggle(true)            
    else
        UI:Delete()                                            
        ActionBars:Toggle(false)
        Config:SaveConfig()
        isConfigMode =false 
end
end
function Config:SaveConfig()
    SmartBarsCharacterActions = Actions:GetTracked()   
    SmartBarsSettings = {ActionBars:Get():FramesPosition(),ActionBars:Get():FramesScale(),ActionBars:Get():FramesAlpha(),ActionBars:Get():FramesColumn(),ActionBars:Get():FramesHideRest(),ActionBars:Get():ActionsSpecBarCounts(),globalHideRest,isCleared,ActionBars:Get():FrameIDs(),ActionBars:Get():FramesRows()}
end
function Config:LoadConfig()  
Actions:Set(SmartBarsCharacterActions)   
globalHideRest=SmartBarsSettings[7]  --global hide in restzone    
ActionBars:Set(
    SmartBarsSettings[1], --framesposition
    SmartBarsSettings[2], --framesscale
    SmartBarsSettings[3], --framesalpha
    SmartBarsSettings[4], --framescolumn
    SmartBarsSettings[5],  --framesrest
    SmartBarsSettings[6],  --actionBarCount for each spec
    SmartBarsSettings[9],   --frameIdNumbers
    SmartBarsSettings[10]   --framesRows
)
isCleared = SmartBarsSettings[8]  --global isCleared value
currentSpecialization = API:GetSpecialization()
currentSaveVersion = SmartBarsSavedBuild
end
function Config:SetDefaults()
    if not SmartBarsCharacterActions then
        SmartBarsCharacterActions = {}      
    end
    if not SmartBarsSettings then
        SmartBarsSettings = {{},{},{},{},{},{},false,false,{},{}}     
    end 
end
function Config:SetDefaultBuild()
    if not SmartBarsSavedBuild then
        SmartBarsSavedBuild = 0   
        savedSaveVersion = SmartBarsSavedBuild
    else
        savedSaveVersion = SmartBarsSavedBuild
    end 
end
function Config:SetSavedBuild(value)
    savedSaveVersion = value
    SmartBarsSavedBuild = value
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
function Config:ResetAll()  
    SmartBarsSavedBuild=nil   
    ReloadUI()
end
function Config:CreatePopup()
    StaticPopupDialogs["SMARTBARS_RESETCONFIRM"] = {
      text = Localization:ConfirmReset(),
      button1 = "Yes",
      button2 = "No",
      OnAccept = function()
          Config:ResetAll()
      end,
      timeout = 0,
      whileDead = true,
      hideOnEscape = true,
      preferredIndex = 3,
    }
end
function Config:SetGlobalHideRest(value)
globalHideRest = value
end
--Getter&Setter----------------------------
function Config:GetSpec()
    return currentSpecialization   
end
function Config:GetResting()
    return resting   
end
function Config:GetGlobalHideRest()
    return globalHideRest
end
function Config:GetSmartBarsPublicInfo()
    local smartBarsVersion = currentVersion
    local smartBarsCurrentBuild = publicBuild 
    return smartBarsVersion,smartBarsCurrentBuild
end
function Config:GetSmartBarsInfo()
    local smartBarsVersion = currentVersion
    local smartBarsCurrentSaveVersion = currentSaveVersion 
    local smartBarsSavedSaveVersion = savedSaveVersion 
    return smartBarsVersion,smartBarsCurrentSaveVersion,smartBarsSavedSaveVersion
end
function Config:SetSpec(currentSpec)
    currentSpecialization = currentSpec    
end
function Config:SetPVP(value)
    pvp = value
end
function Config:SetResting(value)
    resting = value
end
function Config:GetPVP()
   return pvp
end
-- Utils-----------------------------------
function Config:GetTableCount(tableArg)
    local count = 0
    if tableArg ~=nil then
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
    local z = tostring(x) .. tostring(y)
    return tonumber(z)
end  
function Config:DisableOldAddon()
    local name, title, notes, enabled, loadable, reason, security =GetAddOnInfo("BS_ActionsTracker")
    if enabled then
        DisableAddOn("BS_ActionsTracker")
        print(Localization:OldFound())      
    end 
end  
function Config:RoundNumber(num,numDecimalPlaces)
   
    return tonumber(string.format("%." .. (numDecimalPlaces) .. "f", num))
     
end
-- Revision version v 1.0.2 -----
