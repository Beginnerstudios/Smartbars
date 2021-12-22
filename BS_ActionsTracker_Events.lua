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
  frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
  frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
  end
  
  frame:SetScript("OnEvent", function(this, event, ...)
      MyAddon[event](MyAddon, ...)
  end)

  function MyAddon:PLAYER_LOGIN() 
    if IsCleared ==false or IsCleared == nill then
      TrackedSpellsFramePosition = nill
      TrackedActionsColumnCount=nill
      TrackedActionsFrameScale=nill
      TrackedSpellsCharacter=nill
      TrackedActionsFrameCount=nill
      TrackedActionsDisplayedInRestZone =nill
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
  local primaryIsVisible = UI:Get():PrimaryFrame():IsVisible()
  if primaryIsVisible then
  Config:ToggleConfigMode()
  end
  UI:UpdateUI()        
  end
  function MyAddon:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(...) 
    local a = ...
        local trackedActions = Actions:GetTracked()         
      for actionID,v in pairs(trackedActions) do                     
      if trackedActions[actionID][2] == a then
        trackedActions[actionID][7] = true
      end 
    end
  end
  function MyAddon:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(...)
    local a = ... 
    local trackedActions = Actions:GetTracked()               
    for actionID,v in pairs(trackedActions) do                     
    if trackedActions[actionID][2] ==a then
      trackedActions[actionID][7] = false
    end 
  end
  end
end
-- Revision version v0.8.2 ---

