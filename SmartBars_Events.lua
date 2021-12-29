--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Events ={};
local Events=SmartBars.Events;
local Actions
local Core
local Config
local Global
local UI
--Init------------------------------------
function Events:Init()
Actions = SmartBars.Actions
Core = SmartBars.Core
Config = SmartBars.Config
UI = SmartBars.UI
end
--Events:Functions------------------------
function Events:RegisterEvents()
  Event = { }
  local frame = CreateFrame("Frame")
  frame:RegisterEvent("PLAYER_LOGIN")
  frame:RegisterEvent("PLAYER_LOGOUT")


  if Config:IsCurrentPatch() then
  frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
  frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
  frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
  end
  
  frame:SetScript("OnEvent", function(this, event, ...)
    Event[event](MyAddon, ...)
  end)

  function Event:PLAYER_LOGIN() 
    Config:SetDefaultBuild()
    if SmartBarsSavedBuild < SmartBarsCurrentBuild then
      SmartBarsCharacterActions = nill
      SmartBarsSettings = nill
      SmartBarsSavedBuild = SmartBarsCurrentBuild
      Config:SetDefaults()
      print("SmartBars - settings reseted.")      
    end 
  end
  function Event:PLAYER_LOGOUT()   
  end
  function Event:PLAYER_SPECIALIZATION_CHANGED()
  Config:LoadConfig()
  local primaryIsVisible = UI:Get():PrimaryFrame():IsVisible()
  if primaryIsVisible then
  Config:ToggleConfigMode()
  end
  UI:UpdateUI()       
  end
  function Event:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(...) 
    local a = ...
        local trackedActions = Actions:GetTracked()         
      for actionID,v in pairs(trackedActions) do                     
      if trackedActions[actionID][2] == a then
        trackedActions[actionID][7] = true
      end 
    end
  end
  function Event:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(...)
    local a = ... 
    local trackedActions = Actions:GetTracked()               
    for actionID,v in pairs(trackedActions) do                     
    if trackedActions[actionID][2] ==a then
      trackedActions[actionID][7] = false
    end 
  end
  end
end
-- Revision version v0.9.0 ----

