
--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Core ={};
local Core = BS_ActionsTracker.Core
UI = BS_ActionsTracker.UI
Actions = BS_ActionsTracker.Actions
Config = BS_ActionsTracker.Config
Events = BS_ActionsTracker.Events
--LoadingMessage--------------------------
--Core:Functions--------------------------
--Init------------------------------------
UI:Init()
Actions:Init()
Config:Init()
Events:Init()
--Program run-----------------------------
Events:RegisterEvents()
Actions:SetCurrentSpecialization()
C_Timer.After(5, function()
  
    print("BS_ActionsTracker loaded -  BUILD0005\n    Type /bs for settings.")   
    Config:CreateCommands();
    UI:CreateFrames();
    Actions:InitTrackedActions(Actions:GetTrackedActions());
    UI:UpdateTrackedActions(Actions:GetTrackedActions())
   
   
end)
-- Revision version Build 0004 --




