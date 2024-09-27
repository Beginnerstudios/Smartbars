-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Localization = {}
local Localization = SmartBars.Localization
-- Init------------------------------------
function Localization:Init()

end
-- Variables-----
local addonName = "SmartBars - "
-- Color variables
local colorCyan = "|cFF00FFFF"
local colorGreen = "|cFF00FF00"
local colorYellow = "|cFFFFFF00"
local colorReset = "|r"

local loadedMessage = addonName .. colorGreen .. "loaded successfully!" .. colorReset .. "\n" ..
    colorYellow .. "Use " .. colorCyan .. "/sb" .. colorReset .. colorYellow .. " for settings." .. colorReset .. "\n" ..
    colorYellow .. "Use " .. colorCyan .. "/sb reset" .. colorReset .. colorYellow .. " to reset your character's settings." .. colorReset .. "\n" ..
    colorYellow .. "I'd love to see what you've created with SmartBars! Share a screenshot of your UI on " .. colorCyan .. "Discord" .. colorReset .. colorYellow .. ", " .. colorCyan .. "YouTube" .. colorReset .. colorYellow .. ", or " .. colorCyan .. "Curse" .. colorReset .. "." .. colorReset


local bar = "Bar: "
local settingsReseted = addonName .. "settings reseted."
local resetAll = "Reset All"
local usedActions = "Used actions: "
local trackedActions = "Tracked actions: "
local yourActions = "Spells: "
local yourItems = "Items: "

local removeLastActionBar = "Remove last Action Bar."
local createNewActionBar = "Create new Action Bar."
local hideAllActions = "Hide all tracked actions in rest zone."
local hideFrameActions = "Hide this bar in rest zone."
local hideActionsTitle = "Hide in rest zone:"
local hideWhenMounted = "Hide on mount:"
local reverseSortingTitle = "Reverse Sorting"
local reverseSortingTooltip = "Checked - bottom to top\nUnchecked - top to bottom"
local loadingMessageTitle = "Welcome message:"
local tooltipLoadingMessageTitle = "Toggle welcome message."
local updateMessageTitle = "Update:"
local displayWhenBoosted = "Check if you want display this spell only when BOOSTED."
local columnsText = "Columns: "
local alphaText = "Alpha: "
local scaleText = "Scale: "
local changeBar = "Change bar."
local decreaseColumns = "Decrease number of columns."
local increaseColumns = "Increase number of columns."
local settingsTitle = "Settings"
local editText = "Edit"
local confirmReset = "Are you sure that you want reset all settings and actions on current character?"
local confirmSpecReset = "Are you sure that you want reset all actions and bars in current specialization?"
local confirmRemoveBar = "Are you sure you want remove this bar? Your actions will be moved to previous bar."
local changeLog = [[
Build 207(R):
- Added option to hide action while mounted.
  All actions are hidden while skyriding.
- Added option to remove all actions in current spec.
Build 203-206(R):
- Added priority settings for tracked actions (1-10).
  Higher priority moves actions to the left on the bar.
  To configure, hover over an action in config mode and scroll up or down.
  Idea contributed by: Dezarc
- Added a search bar to filter actions in the main UI window.
]]
-- Localization
function Localization:LoadedMessage()
    return loadedMessage
end
function Localization:Bar()
    return bar
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
function Localization:GetChangelog()
    return changeLog
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
function Localization:YourItems()
    return yourItems
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
function Localization:HideWhenMounted()
    return hideWhenMounted
end
function Localization:HideFrameActions()
    return hideFrameActions
end
function Localization:HideActionsTitle()
    return hideActionsTitle
end
function Localization:ReverseSortingTitle()
    return reverseSortingTitle
end
function Localization:ReverseSortingTooltip()
    return reverseSortingTooltip
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
    return changeBar
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
function Localization:ConfirmSpecReset()
    return confirmSpecReset
end
function Localization:ConfirmRemoveBar()
    return confirmRemoveBar
end
function Localization:LoadingMessageTitle()
    return loadingMessageTitle
end
function Localization:UpdateMessageTitle()
    return updateMessageTitle
end
function Localization:LoadingMessageTooltip()
    return tooltipLoadingMessageTitle
end
-- Revision BUILD 207(R)
