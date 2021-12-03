--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Events ={};
local Events=BS_ActionsTracker.Events;
--Init------------------------------------
function Events:Init()
Actions = BS_ActionsTracker.Actions
Core = BS_ActionsTracker.Core
Config = BS_ActionsTracker.Config
end
--Variables-------------------------------
--Events:Functions------------------------
function Events:RegisterEvents()
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
     
     Config:SaveConfig()
  end
  function MyAddon:SetDefaults()

      if not TrackedSpellsCharacter then

          TrackedSpellsCharacter = {}
          Actions:SetTrackedActions(TrackedSpellsCharacter)
      end
      if not TrackedSpellsFramePosition then

        TrackedSpellsFramePosition = {0,-200,"CENTER","CENTER"}
        
    end
  end  
end
-- Revision version Build 0004 --

