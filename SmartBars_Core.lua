-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Core = {}
local UI = SmartBars.UI
local Actions = SmartBars.Actions
local Config = SmartBars.Config
local Events = SmartBars.Events
local API = SmartBars.API
local Templates = SmartBars.Templates
local ActionBars = SmartBars.ActionBars
local Localization = SmartBars.Localization
local Core = SmartBars.Core
-- Init------------------------------------
UI:Init()
Actions:Init()
Config:Init()
Events:Init()
API:Init()
Templates:Init()
ActionBars:Init()
Localization:Init()
-- Core:Functions--------------------------
function Core:Init()
    Events:RegisterEvents()
    Config:CreateCommands()
end
function Core:Reload()
    Config:SetIsReloading(true)
    ActionBars:Stop()
    Actions:Unload()
    ActionBars:Unload()
    Config:SetSpec(API:GetSpecialization())
    Config:GetUserActions(API:GetUserActions())
    Config:Load()
    ActionBars:Load()
    Actions:Load()
    ActionBars:Start()
    Config:SetIsReloading(false)

end
-- Program run-----------------------------
Core:Init()
C_Timer.After(4, function()
    if Config:GetWelcomeMessage() then
        print(Localization:LoadedMessage())
    end
end)
-- Revision BUILD 207(R)

