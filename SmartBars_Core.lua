
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
--LoadingMessage--------------------------
--Core:Functions--------------------------
--Init------------------------------------
UI:Init()
Actions:Init()
Config:Init()
Events:Init()
API:Init()
Templates:Init()
ActionBars:Init()
Localization:Init()
--Program run-----------------------------
Config:DisableOldAddon()
Events:RegisterEvents()
Config:CreateCommands()
C_Timer.After(3, function()   
    Config:LoadConfig() 
    UI:CreatePrimaryFrames()    
    ActionBars:Load()
    Actions:Load()
    ActionBars:StartUpdate()    
    print(Localization:LoadedMessage())   
end)
-- Revision version v0.9.8 ----




