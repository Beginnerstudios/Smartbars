
--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Core ={};
UI = SmartBars.UI
local Actions = SmartBars.Actions
local Config = SmartBars.Config
local Events = SmartBars.Events
local API = SmartBars.API
local Templates = SmartBars.Templates
--LoadingMessage--------------------------
--Core:Functions--------------------------
--Init------------------------------------
UI:Init()
Actions:Init()
Config:Init()
Events:Init()
API:Init()
Templates:Init()
--Program run-----------------------------
Config:DisableOldAddon()
Events:RegisterEvents()
C_Timer.After(5, function()   
    Config:LoadConfig()
    Config:CreateCommands();
    UI:CreatePrimaryFrames();
  --  for i=1,UI:Get():ActionBarCount(),1 do
    --   UI:CreateActionBar(i)
  --  end
  --  for k,v in pairs(UI:Get():FrameIDs()) do
  --      if k~=nill then
  --      UI:CreateActionBar(k)   
  --      end
  --  end
    UI:Load()
    Actions:Load();
 
    print("SmartBars - /bs or /sb for settings.\n")   
end)
-- Revision version v0.9.8 ----




