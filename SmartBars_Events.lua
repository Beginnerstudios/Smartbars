-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Events = {}
local Events = SmartBars.Events
local Actions
local ActionBars
local Config
local UI
-- local ActionBars
local Localization
local Core
local API
-- Init------------------------------------
function Events:Init()
    Actions = SmartBars.Actions
    Core = SmartBars.Core
    ActionBars = SmartBars.ActionBars
    Config = SmartBars.Config
    UI = SmartBars.UI
    Localization = SmartBars.Localization
    API = SmartBars.API
end
-- Dev strings events-----------------------
local playerLogin = "PLAYER_LOGIN"
local playerLogout = "PLAYER_LOGOUT"
local specChanged = "PLAYER_SPECIALIZATION_CHANGED"
local glowShow = "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"
local glowHide = "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE"
local updateResting = "PLAYER_UPDATE_RESTING"
local playerIsGlidingChanged = "PLAYER_IS_GLIDING_CHANGED"
local zoneChanged = "ZONE_CHANGED_NEW_AREA"
local toggleWarmode = "SPELLS_CHANGED"
local chatMessageAddon = "CHAT_MSG_ADDON"
local partyMemberChanged = "PARTY_LEADER_CHANGED"
local actionBarChanged = "ACTIONBAR_SLOT_CHANGED"
local onEvent = "OnEvent"
local MyEvent = {}
-- Events:Functions------------------------
function Events:RegisterEvents()
    local frame = CreateFrame("Frame")
    frame:RegisterEvent(playerLogin)
    frame:RegisterEvent(playerLogout)
    frame:RegisterEvent(updateResting)
    frame:RegisterEvent(chatMessageAddon)
    frame:RegisterEvent(actionBarChanged)
    frame:RegisterEvent(playerIsGlidingChanged)
    Events:CreateEventsPopups()
        frame:RegisterEvent(toggleWarmode)
        frame:RegisterEvent(specChanged)
        frame:RegisterEvent(glowShow)
        frame:RegisterEvent(glowHide)
        frame:RegisterEvent(partyMemberChanged)
        frame:RegisterEvent(zoneChanged)
    frame:SetScript(onEvent, function(self, event, ...)
        MyEvent[event](Event, ...)
    end)
    function MyEvent:SPELLS_CHANGED()
        C_Timer.After(1, function()
            Config:SetPVP(API:IsPVP())
        end)
    end
    function MyEvent:PLAYER_UPDATE_RESTING()
        C_Timer.After(1, function()
            Config:SetResting(API:IsResting())
        end)
    end
    function MyEvent:ZONE_CHANGED_NEW_AREA()
        C_Timer.After(1, function()
            Config:SetResting(API:IsResting())
        end)
    end
    function MyEvent:PLAYER_LOGIN()
        Config:SetDefaults()
    end
    function MyEvent:PLAYER_LOGOUT()
    end
    function MyEvent:PARTY_LEADER_CHANGED()

    end
    function MyEvent:PLAYER_SPECIALIZATION_CHANGED()
        Config:SetSpec(API:GetSpecialization())
        Core:Unload()
        Core:Load()
        if UI:GetIsVisible() then
            UI:Delete()
            Config:Toggle()
        end
    end
    function MyEvent:CHAT_MSG_ADDON(...)
    end
    function MyEvent:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(...)
        local a = ...
        local trackedActions = Actions:GetCurrent()

        for actionID in pairs(trackedActions) do
            if trackedActions[actionID][2] == a then
                trackedActions[actionID][7] = true
            end
        end
    end
    function MyEvent:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(...)
        local a = ...
        local trackedActions = Actions:GetCurrent()
        for actionID in pairs(trackedActions) do
            if trackedActions[actionID][2] == a then
                trackedActions[actionID][7] = false
            end
        end
    end
    function MyEvent:ACTIONBAR_SLOT_CHANGED(...)
        local frameIsVisible = UI:GetIsVisible()
        if frameIsVisible == true then
            UI:Delete()
            UI:Create()
        end

    end
    function MyEvent:PLAYER_IS_GLIDING_CHANGED(...)
     Config:SetIsGliding(API:isGliding())
    end
end
function Events:CreateEventsPopups()
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
-- Revision version v11.0.2 ----.

