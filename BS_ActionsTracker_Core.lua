
--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Core ={};
UI = BS_ActionsTracker.UI
Actions = BS_ActionsTracker.Actions
Config = BS_ActionsTracker.Config
--LoadingMessage--------------------------
--Core:Functions--------------------------
function RegisterEvents()
    MyAddon = { }
    local frame = CreateFrame("Frame")
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
        
        if not TrackedSpellsCharacter then 
    
            TrackedSpellsCharacter = {}
            Actions:SetTrackedActions(TrackedSpellsCharacter)           
        end  
    end
end
--Init------------------------------------
UI:Init()
Actions:Init()
Config:Init()
RegisterEvents()
--Program run-----------------------------
C_Timer.After(5, function()
    print("BS_ActionsTracker loaded -  BUILD0003\n    Type /bs for settings.")
    Config:CreateCommands();
    UI:CreateFrames();  
    Actions:InitTrackedActions(Actions:GetTrackedActions())        
end)
-- Revision version Build 0003 --




