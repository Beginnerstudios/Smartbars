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
  if version == "9.1.5" or version == "9.2.0" then
  frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
  end
  frame:SetScript("OnEvent", function(this, event, ...)
      MyAddon[event](MyAddon, ...)
  end)

  function MyAddon:PLAYER_LOGIN()    
  Config:SetDefaults()
  end
  function MyAddon:PLAYER_LOGOUT()   
  Config:SaveConfig()
  end
  function MyAddon:PLAYER_SPECIALIZATION_CHANGED()
  Config:LoadConfig()
  if IsActionsTrackerPrimaryFrameVisible then
  Config:ToggleConfigMode()
  end
  UI:UpdateUI()        
 end
end
-- Revision version Build 0004 --

