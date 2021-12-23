
--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Core ={};
local Core = SmartBars.Core
UI = SmartBars.UI
Actions = SmartBars.Actions
Config = SmartBars.Config
Events = SmartBars.Events
API = SmartBars.API
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
C_Timer.After(5, function()   
    Config:LoadConfig()
    print("SmartBars - /bs or /sb for settings.\n")   
    Config:CreateCommands();
    UI:CreateFrames();
    for i=1,UI:Get():ActionBarCount(),1 do
    UI:CreateActionBar(i)
    UI:PositionActionBar(i)
    end
    Actions:Load();
end)
-- Revision version v0.8.6 ---




