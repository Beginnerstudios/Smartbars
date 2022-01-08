
--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.Core ={}
local UI = SmartBars.UI
local Actions = SmartBars.Actions
local Config = SmartBars.Config
local Events = SmartBars.Events
local API = SmartBars.API
local Templates = SmartBars.Templates
local ActionBars = SmartBars.ActionBars
local Localization = SmartBars.Localization
local Core = SmartBars.Core
--LoadingMessage--------------------------
--Init------------------------------------
UI:Init()
Actions:Init()
Config:Init()
Events:Init()
API:Init()
Templates:Init()
ActionBars:Init()
Localization:Init()
--Core:Functions--------------------------
function Core:Init()
    Config:DisableOldAddon()
    Events:RegisterEvents()
    Config:CreateCommands()  
end
function Core:Unload()
    ActionBars:StopUpdate()
    ActionBars:Unload()
    Actions:Unload()
end
function Core:Load()
    Config:LoadConfig()   
    ActionBars:Load()
    Actions:Load()
    ActionBars:StartUpdate()  
    UI:RefreshTrackedIcons()
end
--Program run-----------------------------
Core:Init()
C_Timer.After(2, function()   
    Core:Load()   
    print(Localization:LoadedMessage())   
end)
-- Revision version v1.0.2 -----




