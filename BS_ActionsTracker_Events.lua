--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Events ={};
local Events=BS_ActionsTracker.Events;
--Init------------------------------------
function Events:Init()
Actions = BS_ActionsTracker.Actions
Core = BS_ActionsTracker.Core
Config = BS_ActionsTracker.Config
UI = BS_ActionsTracker.UI
end
--Variables-------------------------------
--Events:Functions------------------------
function Events:RegisterEvents()
  MyAddon = { }
  local frame = CreateFrame("Frame")
  frame:RegisterEvent("PLAYER_LOGIN")
  frame:RegisterEvent("PLAYER_LOGOUT")
  frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

  frame:SetScript("OnEvent", function(this, event, ...)
      MyAddon[event](MyAddon, ...)
  end)

  function MyAddon:PLAYER_LOGIN()

      self:SetDefaults()    
      Actions:SetCurrentSpecialization(GetSpecialization())  
      Actions:SetTrackedActions(TrackedSpellsCharacter)

  end
  function MyAddon:PLAYER_LOGOUT()
     
     Config:SaveConfig()
  end
  function MyAddon:PLAYER_SPECIALIZATION_CHANGED()
     Actions:SetCurrentSpecialization(GetSpecialization())
     if IsActionsTrackerPrimaryFrameVisible then
       Config:ToggleConfigMode()
     end
     UI:UpdateUI()
    
      
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

