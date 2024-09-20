-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.UI = {}
local UI = SmartBars.UI
local Actions
local Config
local Templates
local ActionBars
local Utils
-- Init------------------------------------
function UI:Init()
    Utils = SmartBars.Utils
    Actions = SmartBars.Actions
    Config = SmartBars.Config
    Templates = SmartBars.Templates
    ActionBars = SmartBars.ActionBars
end
-- Primaryframe
local primaryFrame
local isVisible = false
local displayedWidgets
local searchText
local changelogPopupDisplayed=false
-- UI:Frames-------------------------------
function UI:Create()
    local function AdjustAlphaOfWidgets(searchText)
    for actionID, actionData in pairs(UI:GetDisplayedWidgets()) do
                                                    local tooltipText = string.lower(actionData.tooltip)
                                                    if string.find(tooltipText, searchText) then
                                                        actionData:SetAlpha(1.0)  -- Set alpha to 100% if the tooltip contains the search string
                                                    else
                                                        actionData:SetAlpha(0.2)  -- Set alpha to 50% if the tooltip does not contain the search string
                                                    end
                                                end
    end
    local function Scripts()
        local onClick = "OnClick"
        local resetPopup, removeBarPopup,resetCurrentSpec = "SMARTBARS_RESETCONFIRM", "SMARTBARS_REMOVEBARCONFIRM","SMARTBARS_RESET_CURRENT_SPEC"
        local configWidgets = primaryFrame.configWidgets
        primaryFrame.CloseButton:SetScript(onClick, function()
            UI:Delete()
            Config:Toggle()
            searchText=nil
        end)
        primaryFrame.resetButton:SetScript(onClick, function()
            StaticPopup_Show(resetPopup)
        end)
        primaryFrame.resetCurrentSpecButton:SetScript(onClick, function()
                    StaticPopup_Show(resetCurrentSpec)
                end)
        -- local staticTitles = configWidgets[1]
        local restZoneWidget = configWidgets[2]
        local barsWidget = configWidgets[3]
        local searchBar = configWidgets[4]
        restZoneWidget.checkBox:SetScript(onClick, function(self)
            Config:SetGlobalHideRest(self:GetChecked())
        end)
        restZoneWidget.loadingCheckBox:SetScript(onClick, function(self)
            Config:SetWelcomeMessage(self:GetChecked())
        end)
         restZoneWidget.mountCheckBox:SetScript(onClick, function(self)
                    Config:SetHideWhenMouned(self:GetChecked())
                end)
        barsWidget.minusButton:SetScript(onClick, function()
            if ActionBars:GetCurrentSpecActionBarsCount() > 1 then
                StaticPopup_Show(removeBarPopup)
            end
        end)
        barsWidget.plusButton:SetScript(onClick, function()
            ActionBars:Add()
        end)
        searchBar.searchBar:SetScript("OnTextChanged", function()
                                           searchText = string.lower(searchBar.searchBar:GetText())
                                           AdjustAlphaOfWidgets(searchText)
                                    end)
                                    searchBar.clearButton:SetScript("OnClick", function()
                                                                               searchText=nil
                                                                               searchBar.searchBar:SetText("")
                                                                        end)
    end
    local function CreateActions(actions,primaryFrame)
        local onClick = "OnClick"
        local xOffset = 0
        local yOffset = -20
        local count = 0
        local displayedIDs = {}
        displayedWidgets ={}
        -- Separate actions into spells and items
        local spellActions = {}
        local itemActions = {}
        for k, action in pairs(actions) do
            local actionType = action.actionType
            if actionType == "spell" then
                spellActions[k] = action  -- Keep the original key
            elseif actionType == "item" then
                itemActions[k] = action  -- Keep the original key
            end
        end
        local function addAddRemoveScriptToWidget(widget,action,actionKey)
            widget:SetScript(onClick, function()
                Actions:AddOrRemove(action,actionKey)
                UI:Update()
            end)
        end
        local function addRemoveScriptToWidget(widget,actionKey)
            widget:SetScript("OnClick", function()
                widget:Hide()
                widget=nil
                Actions:Delete(actionKey)
                UI:Update()
            end)
        end
        local function CreateWidget(action,actionKey)
            local widget = Templates:PanelActionWidget(primaryFrame,false,action.spellId,action.actionType);
            widget:SetPoint("LEFT", primaryFrame.TitleBg, "LEFT", xOffset + 10, yOffset - 100)
            xOffset = xOffset + 50
            count = count + 1
            displayedIDs[actionKey] = actionKey
            if Actions:IsTrackedInCurrentSpec(actionKey) then
                widget:SetChecked(true)
            end
            displayedWidgets[actionKey] = widget
            return widget
        end
        -- SPELLS
        if(Utils:GetTableCount(spellActions)>0) then
          for actionKey, action in pairs(spellActions) do
                     if (count == 8) then
                         yOffset = yOffset - 55
                         xOffset = 0
                         count = 0
                     end
                     local newWidget =  CreateWidget(action,actionKey)
                     addAddRemoveScriptToWidget(newWidget,action,actionKey)
                 end
         end
        -- ITEMS
        if(Utils:GetTableCount(itemActions)>0) then
               yOffset = yOffset - 75
                         xOffset = 0
                         count = 0
           local itemsTitle = Templates:ItemsTitle("Items:", 0, primaryFrame)
                            itemsTitle:SetPoint("LEFT", primaryFrame.TitleBg, "LEFT", 10 , yOffset-60)
                            for actionKey, action in pairs(itemActions) do
                                if (count == 8) then
                                    yOffset = yOffset - 55
                                    xOffset = 0
                                    count = 0
                                end
                                local newWidget = CreateWidget(action,actionKey)
                                addAddRemoveScriptToWidget(newWidget,action,actionKey)
                            end
        end
        -- MISSING
        local currentSpecTrackedActions = Actions:GetTrackedForCurrentSpec();
        local missingCount =0;
        for actionKey in pairs(currentSpecTrackedActions) do
                    if not displayedIDs[actionKey] then
                        missingCount = missingCount+1
                    end
        end
        if(missingCount > 0 ) then
           yOffset = yOffset - 75
                                    xOffset = 0
                                    count = 0
           local missingTitle = Templates:ItemsTitle("Tracked, but not on action bars:", 0, primaryFrame)
                missingTitle:SetPoint("LEFT", primaryFrame.TitleBg, "LEFT", 10 , yOffset-60)
                for actionKey, actionData in pairs(currentSpecTrackedActions) do
                    if not displayedIDs[actionKey] then
                        if count == 8 then
                            yOffset = yOffset - 55
                            xOffset = 0
                            count = 0
                        end
                        local newWidget = CreateWidget(actionData,actionKey)
                        addRemoveScriptToWidget(newWidget,actionKey)
                    end
                end
        end
        primaryFrame:SetHeight((yOffset) * -1 + 155)
    end
    local function Setup(primaryFrame)
        local configWidgets = primaryFrame.configWidgets
        configWidgets[1].trackedValue:SetText(Utils:GetTableCount(Actions:GetTrackedForCurrentSpec()))
        local usedSpellsCount = Utils:GetTableCount(Config:GetUserActions())
        configWidgets[1].usedValue:SetText(usedSpellsCount)
        configWidgets[2].checkBox:SetChecked(Config:GetGlobalHideRest())
        configWidgets[2].loadingCheckBox:SetChecked(Config:GetWelcomeMessage())
        configWidgets[2].mountCheckBox:SetChecked(Config:GetHideWhenMounted())
        local barCount = ActionBars:GetCurrentSpecActionBarsCount()
        configWidgets[3].textValue:SetText(barCount)

    end
    local function Drag()
            local onDragStart = "OnDragStart"
            local onDragStop = "OnDragStop"
            local highFrameStrata = "HIGH"
            local tooltipFrameStrata = "TOOLTIP"
            primaryFrame:SetScript(onDragStart, function()
                primaryFrame:SetFrameStrata(tooltipFrameStrata)
                primaryFrame:StartMoving()
            end)
            primaryFrame:SetScript(onDragStop, function()
                primaryFrame:SetFrameStrata(highFrameStrata)
                primaryFrame:StopMovingOrSizing()
            end)
        end
    primaryFrame = Templates:PrimaryFrame()
    Setup(primaryFrame)
    Scripts()
    CreateActions(Config:GetUserActions(), primaryFrame)
    Drag()
    if(searchText) then
    primaryFrame.configWidgets[4].searchBar:SetText(searchText)
    end
     isVisible = true
end
function UI:Delete()
    if primaryFrame then
        primaryFrame:Hide()
        primaryFrame = nil
        isVisible = false
    end
end
-- UI:Update-------------------------------
function UI:Update()
UI:Delete()
UI:Create()
    if primaryFrame then
        local configWidgets = primaryFrame.configWidgets
        configWidgets[1].trackedValue:SetText(Utils:GetTableCount(Actions:GetTrackedForCurrentSpec()))
        configWidgets[3].textValue:SetText(ActionBars:GetCurrentSpecActionBarsCount())
    end
end
-- Getters & Setters-----------------------
function UI:GetIsVisible()
    return isVisible
end
function UI:SetIsChangelogPopupDisplayed(value)
     changelogPopupDisplayed = value
end
function UI:GetDisplayedWidgets()
    return displayedWidgets
end
function UI:GetIsChangelogPopupDisplayed()
    return changelogPopupDisplayed
end
-- Revision BUILD 206(R)

