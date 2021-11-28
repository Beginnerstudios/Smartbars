
--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Core ={};
UI = BS_ActionsTracker.UI
Actions = BS_ActionsTracker.Actions
Config = BS_ActionsTracker.Config
--LoadingMessage--------------------------
--Core:Functions--------------------------
--Init------------------------------------
UI:Init()
Actions:Init()
Config:Init()
--Program run-----------------------------
---Move to global.lua in next built----------------------------------------
MyAddon = { }
local frame = CreateFrame("Frame")
-- trigger event with /reloadui or /rl
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")

frame:SetScript("OnEvent", function(this, event, ...)
    MyAddon[event](MyAddon, ...)
end)

function MyAddon:PLAYER_LOGIN()

    self:SetDefaults()
    Actions:SetTrackedActions(TrackedSpellsCharacter)
  
end
function MyAddon:PLAYER_LOGOUT()
  
    
    TrackedSpellsCharacter = Actions:GetTrackedActions()
   
end
function MyAddon:SetDefaults()
    
   -- TrackedSpellsCharacter = {}

    if not TrackedSpellsCharacter then 

        TrackedSpellsCharacter = {}
        Actions:SetTrackedActions(TrackedSpellsCharacter)
     
       
    end

    
  

   
end
-----------------------------------------------------------------------
C_Timer.After(5, function()
    ---Test
   -- Actions:GetUserActions2()
    -----
    print("BS_ActionsTracker loaded -  BUILD0002\n    Type /bs for settings.")
    Config:CreateCommands();
    UI:CreateFrames();
   -- UI:DisplayActions(Actions.GetUserActions().GetUsed(),UI:GetFrame(1));   
    Actions:InitTrackedActions(Actions:GetTrackedActions())        
end)





