-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Config = {}
local Config = SmartBars.Config
local UI
local Actions
local ActionBars
local API
-- Init------------------------------------
function Config:Init()
    UI = SmartBars.UI
    Actions = SmartBars.Actions
    API = SmartBars.API
    ActionBars = SmartBars.ActionBars
end
-- Config:Functions------------------------
function Config:CreateCommands()
    SLASH_SB1 = "/sb"
    SlashCmdList["SB"] = function(msg)
        if msg == "reset" then
            Config:Reset()
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
function Config:Save()
    SmartBarsCharacterActions = Actions:GetTracked()
    SmartBarsSettings = {ActionBars:GetSV():FramesPosition(), ActionBars:GetSV():FramesScale(),
                         ActionBars:GetSV():FramesAlpha(), ActionBars:GetSV():FramesColumn(),
                         ActionBars:GetSV():FramesHideRest(), ActionBars:GetSV():FramesSpecCounts(), Config:GetGlobalHideRest(),
                         false, ActionBars:GetSV():FrameIDs(), ActionBars:GetSV():FramesSorting(), Config:GetWelcomeMessage()}
end
function Config:Load()
    Actions:Set(SmartBarsCharacterActions)
    globalHideRest = SmartBarsSettings[7] -- global hide in restzone   
    welcomeMessage = SmartBarsSettings[11]
    ActionBars:Set(SmartBarsSettings[1], -- framesposition
    SmartBarsSettings[2], -- framesscale
    SmartBarsSettings[3], -- framesalpha
    SmartBarsSettings[4], -- framescolumn
    SmartBarsSettings[5], -- framesrest
    SmartBarsSettings[6], -- actionBarCount for each spec
    SmartBarsSettings[9], -- frameIdNumbers
    SmartBarsSettings[10] -- frameSorting
    )
    Config:SetSpec(API:GetSpecialization())
end
function Config:Reset()
    SmartBarsCharacterActions = nil
    SmartBarsSettings = nil
    ReloadUI()
    print("Smartbars reseted all settings and actions on this character.")
end
-- Config:Variables------------------------
local configMode = false
local globalHideRest
local welcomeMessage = true
local pvp
local isGliding
local resting
local currentSpecialization
local currentVersion = "v - 1.1.2 (Alpha)"
-- Getter------------------------------------
function Config:GetSpec()
    return currentSpecialization
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
-- Seter------------------------------------
function Config:SetConfigMode(value)
    configMode = value
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
function Config:SetSpec(currentSpec)
    currentSpecialization = currentSpec
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
        SmartBarsSettings = {{}, {}, {}, {}, {}, {}, false, false, {}, {}}
    end
    Config:SetSpec(API:GetSpecialization())
    Config:SetResting(API:IsResting())
    Config:SetIsGliding(API:isGliding())
end
-- Revision version v 11.0.2 ---------------
