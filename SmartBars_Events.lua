--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.Events ={}
local Events=SmartBars.Events
local Actions
local Config
local UI
local ActionBars
local Localization
--Init------------------------------------
function Events:Init()
Actions = SmartBars.Actions
Core = SmartBars.Core
Config = SmartBars.Config
UI = SmartBars.UI
ActionBars = SmartBars.ActionBars
Localization = SmartBars.Localization
end
--Dev strings events-----------------------
local playerLogin = "PLAYER_LOGIN"
local playerLogout = "PLAYER_LOGOUT"
local specChanged ="PLAYER_SPECIALIZATION_CHANGED"
local glowShow = "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"
local glowHide = "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE"
local onEvent ="OnEvent"
--Events:Functions------------------------
function Events:RegisterEvents()
  Event = { }
  local frame = CreateFrame("Frame")
  frame:RegisterEvent(playerLogin)
  frame:RegisterEvent(playerLogout)
  Config:CreatePopup()
  if Config:IsCurrentPatch() then
  frame:RegisterEvent(specChanged)
  frame:RegisterEvent(glowShow)
  frame:RegisterEvent(glowHide)
  end
 

  frame:SetScript(onEvent, function(self, event, ...)
    Event[event](MyAddon, ...)
  end)

  function Event:PLAYER_LOGIN() 
    Config:SetDefaultBuild()
    Config:ValidateSavedSettings()
    local version,build,savedBuild = Config:GetSmartBarsInfo()
    if savedBuild < build then
      SmartBarsCharacterActions = nil
      SmartBarsSettings = nil
      Config:SetSavedBuild(build) 
      Config:SetDefaults()
      print(Localization:SettingsReseted())      
    end 
  end
  function Event:PLAYER_LOGOUT()   
  end
  function Event:PLAYER_SPECIALIZATION_CHANGED()
    ActionBars:Unload()
    Config:LoadConfig()
    ActionBars:Load()
    ActionBars:StartUpdate()
 
  local primaryIsVisible = UI:Get():PrimaryFrame():IsVisible()
  if primaryIsVisible then
  Config:ToggleConfigMode()
  end
 UI:UpdateUI()       
  end
  function Event:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(...) 
    local a = ...
        local trackedActions = Actions:Get()         
      for actionID in pairs(trackedActions) do                     
      if trackedActions[actionID][2] == a then
        trackedActions[actionID][7] = true
      end 
    end
  end
  function Event:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(...)
    local a = ... 
    local trackedActions = Actions:Get()               
    for actionID in pairs(trackedActions) do                     
    if trackedActions[actionID][2] ==a then
      trackedActions[actionID][7] = false
    end 
  end
  end
end
-- Revision version v0.9.9 ----.

