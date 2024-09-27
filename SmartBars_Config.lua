-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Config = {}
local Config = SmartBars.Config
local UI
local Actions
local ActionBars
local API
local Utils
-- Init------------------------------------
function Config:Init()
    UI = SmartBars.UI
    Actions = SmartBars.Actions
    API = SmartBars.API
    ActionBars = SmartBars.ActionBars
    Utils = SmartBars.Utils
end
-- Config:Functions------------------------
function Config:CreateCommands()
    SLASH_SB1 = "/sb"
    SlashCmdList["SB"] = function(msg)
        if msg == "reset" then
            StaticPopup_Show("SMARTBARS_RESETCONFIRM")
        else
            Config:Toggle()
        end
    end
end
function Config:Toggle()
    if Config:GetConfigMode() == false then
        UI:Create()
        Config:SetConfigMode(true)
        ActionBars:Toggle(true)
    else
        UI:Delete()
        ActionBars:Toggle(false)
        Config:Save()
        Config:SetConfigMode(false)
    end
end
function Config:GetSpecializationName()
    return API:GetSpecializatonNameFromIndex(Config:GetSpec())
end
function Config:Save()
    --Actions
    local newActions = {}
    local trackedActions = Actions:GetAllTrackedActions()
    --Utils:DebugActions(trackedActions,"Action during save")
    for key, value in pairs(trackedActions) do
        -- Create a new table with numeric keys for each action
        local numericKeyAction = {}
        numericKeyAction[1] = value.slotId
        numericKeyAction[2] = value.spellId
        numericKeyAction[3] = value.widget
        numericKeyAction[4] = value.actionText
        numericKeyAction[5] = value.currentSpec
        numericKeyAction[6] = value.trackedFrame
        numericKeyAction[7] = value.isBoosted
        numericKeyAction[8] = value.showOnlyWhenBoosted
        numericKeyAction[9] = value.actionType
        numericKeyAction[10]= value.isPvpTalent
        numericKeyAction[11]= value.priority
        -- Insert the numericKeyAction table into newActions using a numeric index
        table.insert(newActions, numericKeyAction)
    end
    SmartBarsCharacterActions = newActions
    --Settings
    local sv = ActionBars:GetActionBarsValues()
    SmartBarsSettings = {sv.FramesPosition, sv.FramesScale, sv.FramesAlpha, sv.FramesColumn,
                         sv.FramesHideRest, sv.FramesSpecCounts, Config:GetGlobalHideRest(),
                         false, sv.FrameIDs, sv.FramesSorting, Config:GetWelcomeMessage(),Config:GetHideWhenMounted()}
end
function Config:Load()
    --Actions
    local newActions ={}
    for _,value in pairs(SmartBarsCharacterActions) do
        local actionKey = Utils:JoinNumber(value[2],value[5])
        newActions[actionKey] = {}
        newActions[actionKey].slotId = value[1]
        newActions[actionKey].spellId = tonumber(value[2])
        newActions[actionKey].widget = value[3]
        newActions[actionKey].actionText = value[4]
        newActions[actionKey].currentSpec = value[5]
        newActions[actionKey].trackedFrame = value[6]
        newActions[actionKey].isBoosted = value[7]
        newActions[actionKey].showOnlyWhenBoosted = value[8]
        newActions[actionKey].actionType = value[9]
        newActions[actionKey].isPvpTalent = value[10]
          if value[11] then
                newActions[actionKey].priority = value[11]
                else
                newActions[actionKey].priority =5
                end
    end
    Actions:Set(newActions)
    --Utils:DebugActions(newActions,"Action during load")
    --Settings
    local actionBarsSettings ={}
            actionBarsSettings.framesPositions = SmartBarsSettings[1]
            actionBarsSettings.framesScale =  SmartBarsSettings[2]
            actionBarsSettings.framesAlpha =  SmartBarsSettings[3]
            actionBarsSettings.framesColumns = SmartBarsSettings[4]
            actionBarsSettings.framesRest =SmartBarsSettings[5]
            actionBarsSettings.framesCount = SmartBarsSettings[6]
            actionBarsSettings.framesIdNumbers = SmartBarsSettings[9]
            actionBarsSettings.framesSorting = SmartBarsSettings[10]
    ActionBars:Set(actionBarsSettings)
    Config:SetGlobalHideRest(SmartBarsSettings[7])
    Config:SetWelcomeMessage(SmartBarsSettings[11])
    local hideWHenMounted
    if SmartBarsSettings[12]~=nil then
    hideWHenMounted = SmartBarsSettings[12]
    else
    hideWHenMounted = false
    end
    Config:SetHideWhenMouned(hideWHenMounted)
end
function Config:Reset()
    SmartBarsCharacterActions = nil
    SmartBarsSettings = nil
    ReloadUI()
    print("Smartbars reseted all settings and actions on this character.")
end
function Config:ResetSpec()
local trackedActionsInSpec = Actions:GetTrackedForCurrentSpec()
for actionID in pairs(trackedActionsInSpec) do
Actions:Delete(actionID)
end
while ActionBars:GetCurrentSpecActionBarsCount() > 1 do
   ActionBars:Remove()
end
Config:Save()
    ReloadUI()
    print("Smartbars reseted actions for current spec.")
end
-- Config:Variables------------------------
local configMode = false
local globalHideRest
local welcomeMessage
local pvp
local isGliding
local resting
local currentSpecialization
local userActions
local isReloading
local hideWhenMounted
local isMounted
local currentVersion = "Build 207(R)"
-- Getter------------------------------------
function Config:GetIsMounted()
    return isMounted
end
function Config:GetSpec()
    return currentSpecialization
end
function Config:GetHideWhenMounted()
    return hideWhenMounted
end
function Config:GetIsRealoding()
    return isReloading
end
function Config:GetIsGliding()
    return isGliding
end
function Config:GetResting()
    return resting
end
function Config:GetGlobalHideRest()
    return globalHideRest
end
function Config:GetWelcomeMessage()
    return welcomeMessage
end
function Config:GetSmartbarsVersion()
    return currentVersion
end
function Config:GetPVP()
    return pvp
end
function Config:GetConfigMode()
    return configMode
end
function Config:GetUserActions()
    return userActions
end
-- Seter------------------------------------
function Config:SetHideWhenMouned(value)
    hideWhenMounted = value
end
function Config:SetIsMounted(value)
    isMounted = value
end
function Config:SetConfigMode(value)
    configMode = value
end
function Config:SetIsReloading(value)
    isReloading = value
end
function Config:SetUserActions(value)
    userActions = value
end
function Config:SetPVP(value)
    pvp = value
end
function Config:SetResting(value)
    resting = value
end
function Config:SetIsGliding(value)
    isGliding = value
end
function Config:SetSpec(value)
    currentSpecialization = value
end
function Config:SetGlobalHideRest(value)
    globalHideRest = value
end
function Config:SetWelcomeMessage(value)
    welcomeMessage = value
end
function Config:SetDefaults()
    if not SmartBarsCharacterActions then
        SmartBarsCharacterActions = {}
    end
    if not SmartBarsSettings then
        SmartBarsSettings = {{}, {}, {}, {}, {}, {}, false, false, {}, {},false}
    end
    Config:SetSpec(API:GetSpecialization())
    Config:SetResting(API:IsResting())
    Config:SetIsGliding(API:isGliding())
    Config:SetIsMounted(API:isPlayerMounted())
end
-- Revision BUILD 207(R)
