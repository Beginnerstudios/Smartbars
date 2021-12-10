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

  if Config:IsCurrentPatch() then
  frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
  end
  
  frame:SetScript("OnEvent", function(this, event, ...)
      MyAddon[event](MyAddon, ...)
  end)

  function MyAddon:PLAYER_LOGIN() 
    if  IsCleared ~=true then
      TrackedSpellsFramePosition = nill
      TrackedActionsColumnCount=nill
      TrackedActionsFrameScale=nill
      TrackedSpellsCharacter=nill
      TrackedActionsFrameCount=nill
      print("BS_ActionsTracker -reseted-")
      IsCleared = true
  end
   

  Config:SetDefaults()
  end
  function MyAddon:PLAYER_LOGOUT()   
  --when player logout
  end
  function MyAddon:PLAYER_SPECIALIZATION_CHANGED()
  Config:LoadConfig()
  if Config:IsPrimaryFrameVisible() then
  Config:ToggleConfigMode()
  end
  Config:UpdateUI()        
 end
end
-- Revision version Build 0004 --

