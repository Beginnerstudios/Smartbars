--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.Localization ={}
local Localization=SmartBars.Localization
--Init------------------------------------
function Localization:Init()

end
--Variables-----
local addonName = "SmartBars - "
local loadedMessage = addonName.."/bs or /sb for settings.\n"
local bar = "Bar: "
local oldFound = addonName.."old version of this addon was found enabled(BS_ActionsTracker), it is not possible to have both addons active, so BS_ActionsTracker was disabled.If you dont want get this notification again delete BS_ActionsTracker folder from --/interface/addons."
local settingsReseted = addonName.."settings reseted."
local resetAll = "Reset All"
local usedActions = "Used actions: "
local trackedActions = "Tracked actions: "
local yourActions = "Your actions: "
local removeLastActionBar ="Remove last Action Bar."
local createNewActionBar ="Create new Action Bar."
local hideAllActions ="Hide all tracked actions in rest zone."
local hideFrameActions="Hide this bar in rest zone."
local hideActionsTitle ="Hide:"
local displayWhenBoosted ="Check if you want display this spell only when BOOSTED."
local columnsText = "Columns: "
local alphaText = "Alpha: "
local scaleText = "Scale: "
local changeBar ="Change bar."
local decreaseColumns ="Decrease number of columns."
local increaseColumns ="Increase number of columns."
local settingsTitle ="Settings"
local editText ="Edit"
local confirmReset = "Are you sure you want reset SmartBars to default state?"
--Localization
function Localization:LoadedMessage()
return loadedMessage
end
function Localization:Bar()
return bar
end
function Localization:OldFound()
return oldFound
end
function Localization:SettingsReseted()
return settingsReseted
end
function Localization:AddonName()
  return addonName
end
function Localization:ResetAll()
  return resetAll
end
function Localization:UsedActions()
    return usedActions
end
function Localization:TrackedActions()
      return trackedActions
end
function Localization:YourActions()
        return yourActions
end
function Localization:AddActionBar()
          return createNewActionBar
end
function Localization:RemoveActionBar()
            return removeLastActionBar
end
function Localization:HideAllActions()
              return hideAllActions
end
function Localization:HideFrameActions()
                return hideFrameActions
end
function Localization:HideActionsTitle()
  return hideActionsTitle
end
function Localization:DisplayWhenBoosted()
  return displayWhenBoosted
end
function Localization:ColumnText()
  return columnsText
end
function Localization:AlphaText()
  return alphaText
end
function Localization:ScaleText()
  return scaleText
end
function Localization:ChangeBar()
  return scaleText
end
function Localization:IncreaseColumns()
  return increaseColumns
end
function Localization:DecreaseColumns()
  return decreaseColumns
end
function Localization:SettingsTitle()
  return settingsTitle
end
function Localization:EditText()
  return editText
end
function Localization:ConfirmReset()
  return confirmReset
end
--Revision v 1.0.2 ---
