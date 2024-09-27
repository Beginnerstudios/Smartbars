-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Events = {}
local Events = SmartBars.Events
local Actions
local ActionBars
local Config
local UI
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
local playerEnteringWorld = "PLAYER_ENTERING_WORLD"
local playerMountDisplayChanged = "PLAYER_MOUNT_DISPLAY_CHANGED"
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
    frame:RegisterEvent(playerEnteringWorld)
    frame:RegisterEvent(playerMountDisplayChanged)
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
        Config:SetSpec(API:GetSpecialization())
        Config:SetUserActions(API:GetUserActions())
        Config:SetPVP(API:IsPVP())
    end
    function MyEvent:PLAYER_UPDATE_RESTING()
            Config:SetResting(API:IsResting())
    end
     function MyEvent:PLAYER_MOUNT_DISPLAY_CHANGED()
                Config:SetIsMounted(API:isPlayerMounted())
        end
    function MyEvent:PLAYER_ENTERING_WORLD()
        Config:SetDefaults()
        Config:SetUserActions(API:GetUserActions())
            Core:Reload()
            if UI:GetIsVisible() then
                UI:Delete()
                Config:Toggle()
            end
    end
    function MyEvent:ZONE_CHANGED_NEW_AREA()
            Config:SetResting(API:IsResting())
            Config:SetIsGliding(API:isGliding())
    end
    function MyEvent:PLAYER_LOGIN()

    end
    function MyEvent:PLAYER_LOGOUT()
    end
    function MyEvent:PARTY_LEADER_CHANGED()

    end
    function MyEvent:PLAYER_SPECIALIZATION_CHANGED()
        Core:Reload()
        if UI:GetIsVisible() then
            UI:Delete()
            Config:Toggle()
        end
    end
    function MyEvent:CHAT_MSG_ADDON(...)
    end
    function MyEvent:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(...)
        local a = ...
        local trackedActions = Actions:GetTrackedForCurrentSpec()
        for actionID,actionData in pairs(trackedActions) do
            if actionData.spellId == a then
                trackedActions[actionID].isBoosted = true
            end
        end
    end
    function MyEvent:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(...)
        local a = ...
        local trackedActions = Actions:GetTrackedForCurrentSpec()
        for actionID,actionData in pairs(trackedActions) do
            if actionData.spellId == a then
                trackedActions[actionID].isBoosted = false
            end
        end
    end
    function MyEvent:ACTIONBAR_SLOT_CHANGED(...)
        Config:SetSpec(API:GetSpecialization())
        Config:SetUserActions(API:GetUserActions())
        local frameIsVisible = UI:GetIsVisible()
        if frameIsVisible == true then
            UI:Update()
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
      StaticPopupDialogs["SMARTBARS_RESET_CURRENT_SPEC"] = {
            text = Localization:ConfirmSpecReset(),
            button1 = "Yes",
            button2 = "No",
            OnAccept = function()
                Config:ResetSpec()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3
        }
end
-- Revision BUILD 207(R)

