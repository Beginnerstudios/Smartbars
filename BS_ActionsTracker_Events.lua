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

  local version,build,date = GetBuildInfo()
  if version == "9.1.5" then
    frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
  end
  frame:SetScript("OnEvent", function(this, event, ...)
      MyAddon[event](MyAddon, ...)
  end)

  function MyAddon:PLAYER_LOGIN()    
      self:SetDefaults()    
      Actions:SetCurrentSpecialization(Config:GetCorrectSpecialization())  
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
      if not TrackedActionsColumnCount then
        TrackedActionsColumnCount = 8       
      end
    if not TrackedActionsFrameScale or TrackedActionsFrameScale == 0 then
      TrackedActionsFrameScale = 1
    
     
  end
  end  
end
-- Revision version Build 0004 --

