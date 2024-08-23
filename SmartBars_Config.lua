-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Config = {}
local Config = SmartBars.Config
local UI
local Actions
local ActionBars
local Localization
-- local Core
-- local Global
local API
-- Init------------------------------------
function Config:Init()
    UI = SmartBars.UI
    Actions = SmartBars.Actions
    API = SmartBars.API
    ActionBars = SmartBars.ActionBars
    Localization = SmartBars.Localization
end
-- Config:Variables------------------------
local isConfigMode = false
local currentSpecialization
local isCleared
local globalHideRest
local welcomeMessage = true
local pvp
local resting
-- Save data---
local currentSaveVersion = 99.1
local savedSaveVersion
---Public version----------
local currentVersion = "v - 1.1.2 (Alpha)"
local publicBuild = 112
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
    if isConfigMode == false then
        UI:Create()
        isConfigMode = true
        ActionBars:Toggle(true)
    else
        UI:Delete()
        ActionBars:Toggle(false)
        Config:Save()
        isConfigMode = false
    end
end
function Config:Save()
    SmartBarsCharacterActions = Actions:GetTracked()
    SmartBarsSettings = {ActionBars:GetSV():FramesPosition(), ActionBars:GetSV():FramesScale(),
                         ActionBars:GetSV():FramesAlpha(), ActionBars:GetSV():FramesColumn(),
                         ActionBars:GetSV():FramesHideRest(), ActionBars:GetSV():FramesSpecCounts(), globalHideRest,
                         isCleared, ActionBars:GetSV():FrameIDs(), ActionBars:GetSV():FramesSorting(), welcomeMessage}
end
function Config:Load()
    if (#SmartBarsSettings < 11) then
        --  print("Smartbars - press /sb and reset all to get new features.If you don't want loose your config just download previous version.")
    end
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
    isCleared = SmartBarsSettings[8] -- global isCleared value
    currentSpecialization = API:GetSpecialization()
    currentSaveVersion = SmartBarsSavedBuild
end
function Config:Reset()
    SmartBarsSavedBuild = nil
    ReloadUI()
    print("Smartbars reseted all settings on this character.")
end
-- Getter------------------------------------
function Config:GetSpec()
    return currentSpecialization
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
function Config:GetSmartBarsPublicInfo()
    return currentVersion, publicBuild
end
function Config:GetSmartBarsInfo()
    local smartBarsVersion = currentVersion
    local smartBarsCurrentSaveVersion = currentSaveVersion
    local smartBarsSavedSaveVersion = savedSaveVersion
    return smartBarsVersion, smartBarsCurrentSaveVersion, smartBarsSavedSaveVersion
end
function Config:GetPVP()
    return pvp
end
function Config:IsCurrentPatch()
    if API:GetBuildInfo() > 90000 then
        return true
    else
        return false
    end
end
function Config:IsConfigMode()
    return isConfigMode
end
-- Seter------------------------------------
function Config:SetPVP(value)
    pvp = value
end
function Config:SetResting(value)
    resting = value
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
end
function Config:SetDefaultBuild()
    if not SmartBarsSavedBuild then
        SmartBarsSavedBuild = 0
        savedSaveVersion = SmartBarsSavedBuild
    else
        savedSaveVersion = SmartBarsSavedBuild
    end
end
function Config:SetSavedBuild(value)
    savedSaveVersion = value
    SmartBarsSavedBuild = value
end
-- Utils-----------------------------------
function Config:GetTableCount(tableArg)
    local count = 0
    if tableArg ~= nil then
        for _ in pairs(tableArg) do
            count = count + 1
        end
    end
    return count
end
function Config:IsValueSame(value1, value2)
    if value1 == value2 then
        return true
    else
        return false
    end
end
function Config:JoinNumber(x, y)
    local z = tostring(x) .. tostring(y)
    return tonumber(z)
end
function Config:RoundNumber(num, numDecimalPlaces)

    return tonumber(string.format("%." .. (numDecimalPlaces) .. "f", num))

end
function Config:SendMessage()
    local prefix = "SmartBars"
    C_ChatInfo.RegisterAddonMessagePrefix(prefix)
    local build = publicBuild
    C_ChatInfo.SendAddonMessage(prefix, build, "WHISPER", UnitName("player"))
end
function Config:CreatePopup()
    StaticPopupDialogs["SMARTBARS_RESETCONFIRM"] = {
        text = Localization:ConfirmReset(),
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            Config:Reset()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3
    }
    StaticPopupDialogs["SMARTBARS_REMOVEBARCONFIRM"] = {
        text = Localization:ConfirmRemoveBar(),
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            ActionBars:Remove()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3
    }
end
-- Revision version v 1.1.1 ---------------
