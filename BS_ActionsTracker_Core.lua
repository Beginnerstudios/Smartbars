
--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Core ={};
local Core = BS_ActionsTracker.Core
UI = BS_ActionsTracker.UI
Actions = BS_ActionsTracker.Actions
Config = BS_ActionsTracker.Config
Events = BS_ActionsTracker.Events
API = BS_ActionsTracker.API
--LoadingMessage--------------------------
--Core:Functions--------------------------
--Init------------------------------------
UI:Init()
Actions:Init()
Config:Init()
Events:Init()
API:Init()
--Program run-----------------------------



Events:RegisterEvents()
Actions:SetCurrentSpecialization()


C_Timer.After(5, function()   
    Config:LoadConfig()
    print("BS_ActionsTracker -loaded-  BUILD0007\n    Type /bs for settings.\n")   
    Config:CreateCommands();
    UI:CreatePrimaryFrame();
    for i=1,UI:GetTrackedActionsFrameCount(),1 do
    UI:CreateTrackedActionBar(i)
    UI:SetFrameFramePosition(i)
    end
    Actions:InitTrackedActions(Actions:GetTrackedActions());
    UI:UpdateTrackedActions(Actions:GetTrackedActions()) 
end)
-- Revision version Build 0007 --




