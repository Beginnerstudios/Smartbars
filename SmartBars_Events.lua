--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Events ={};
local Events=SmartBars.Events;
--Init------------------------------------
function Events:Init()
Actions = SmartBars.Actions
Core = SmartBars.Core
Config = SmartBars.Config
UI = SmartBars.UI
end
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
    if IsCleared==false or IsCleared == nill then
      TrackedSpellsFramePosition = nill
      TrackedActionsColumnCount=nill
      TrackedActionsFrameScale=nill
      TrackedSpellsCharacter=nill
      TrackedActionsFrameCount=nill
      TrackedActionsDisplayedInRestZone =nill
      print("SmartBars -reseted-")
      IsCleared = true
  end
   

  Config:SetDefaults()
  end
  function MyAddon:PLAYER_LOGOUT()   
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
-- Revision version v0.8.6 ----

