-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.UI = {}
local UI = SmartBars.UI
local Actions
local Config
local Templates
local ActionBars
local API
-- Init------------------------------------
function UI:Init()
    Actions = SmartBars.Actions
    Config = SmartBars.Config
    Templates = SmartBars.Templates
    ActionBars = SmartBars.ActionBars
    API = SmartBars.API
end
-- Variables-------------------------------
-- Primaryframe
local primaryFrame
local isVisible = false
-- UI:Frames-------------------------------
function UI:Create()
    local function SetupPrimaryFrame()
        primaryFrame = Templates:PrimaryFrame()
    end

    local function SetupConfigWidgets()
        local configWidgets = primaryFrame.configWidgets
        local trackedActions = Actions:GetCurrent()
        local currentSpec = API:GetSpecialization()
        local trackedActionForSpecCount = 0

        for _, actionData in pairs(trackedActions) do
            local actionSpec = actionData[5]
            if Config:IsValueSame(actionSpec, currentSpec) then
                trackedActionForSpecCount = trackedActionForSpecCount + 1
            end
        end

        configWidgets[1].trackedValue:SetText(trackedActionForSpecCount)
        configWidgets[1].usedValue:SetText(Config:GetTableCount(API:GetUserActions()))
        configWidgets[2].checkBox:SetChecked(Config:GetGlobalHideRest())
        configWidgets[2].loadingCheckBox:SetChecked(Config:GetWelcomeMessage())
        configWidgets[3].textValue:SetText(ActionBars:GetCurrentSpecActionBarsCount())
    end

    local function SetPrimaryFrameScripts()
        local onClick = "OnClick"
        local configWidgets = primaryFrame.configWidgets

        primaryFrame.CloseButton:SetScript(onClick, function()
            UI:Delete()
            Config:Toggle()
        end)

        primaryFrame.resetButton:SetScript(onClick, function()
            StaticPopup_Show("SMARTBARS_RESETCONFIRM")
        end)

        configWidgets[2].checkBox:SetScript(onClick, function(self)
            Config:SetGlobalHideRest(self:GetChecked())
        end)

        configWidgets[2].loadingCheckBox:SetScript(onClick, function(self)
            Config:SetWelcomeMessage(self:GetChecked())
        end)

        local barsWidget = configWidgets[3]
        barsWidget.minusButton:SetScript(onClick, function()
            if ActionBars:GetCurrentSpecActionBarsCount() > 1 then
                StaticPopup_Show("SMARTBARS_REMOVEBARCONFIRM")
            end
        end)

        barsWidget.plusButton:SetScript(onClick, function()
            ActionBars:Add()
        end)
    end

    local function CreateActionWidgets(actions, actionTypeFilter, initialYOffset)
        local onClick = "OnClick"
        local xOffset = 0
        local yOffset = initialYOffset
        local count = 0
        local displayedIDs = {}
        local trackedIDs = {}
        local function RemoveNotInBars(trackedIDs,displayedIDs)
            for k, v in pairs(trackedIDs) do
                if trackedIDs[k] == displayedIDs[k] then
                elseif not displayedIDs[k] then
                    local function CreateWidget()
                        local cA = Actions:GetCurrent()
                        local tA = Actions:GetTracked()
                        local ID = Config:JoinNumber(k, API:GetSpecialization())
                        local actionID = k
                        local actionName = select(1, API:GetFoundActionInfo(actionID)[1])
                        local newAction = {}
                        newAction[6] = tA[ID][9]
                        newAction[2] = tA[ID][2]
                        local widget = Templates:ActionWidget(newAction, primaryFrame, false)
                        widget:SetPoint("LEFT", primaryFrame.TitleBg, "LEFT", xOffset + 10, yOffset - 100)
                        widget:SetChecked(true)
                        widget:SetScript(onClick, function(self)
                            local actionID = Config:JoinNumber(actionID, API:GetSpecialization())
                            tA[actionID] = nil
                            cA[actionID][3]:Hide()
                            cA[actionID] = nil
                            widget:Hide()
                        end)

                        widget.tooltipText = actionName

                        xOffset = xOffset + 50
                        count = count + 1
                        if (count == 6) then
                            yOffset = yOffset - 55
                            xOffset = 0
                            count = 0
                        end
                    end
                    CreateWidget()
                end
            end
        end

        for k, actionData in pairs(actions) do
            local actionType = actionData[6]
            if actionType == actionTypeFilter then
                local actionID = actionData[2]
                local widget = Templates:ActionWidget(actionData, primaryFrame, false)
                local actionName = API:GetDisplayedActionInfo(actionID, actionType)

                widget:SetPoint("LEFT", primaryFrame.TitleBg, "LEFT", xOffset + 10, yOffset - 100)
                widget:SetScript(onClick, function()
                    Actions:Add(actionData)
                    UI:Update()
                end)
                widget.tooltipText = actionName

                xOffset = xOffset + 50
                count = count + 1

                if count == 8 then
                    yOffset = yOffset - 55
                    xOffset = 0
                    count = 0
                end

                for _, trackedData in pairs(Actions:GetTracked()) do
                    local trackedActionID = trackedData[2]
                    local trackedActionSpec = trackedData[5]
                    local currentSpec = API:GetSpecialization()

                    if Config:IsValueSame(actionID, trackedActionID) and
                        Config:IsValueSame(trackedActionSpec, currentSpec) then
                        widget:SetChecked(true)
                    elseif Config:IsValueSame(trackedActionSpec, currentSpec) then
                        trackedIDs[trackedActionID] = actionID
                    end
                end

                displayedIDs[actionID] = actionData
            end
        end
        if(actionTypeFilter=="spell")then
            RemoveNotInBars(trackedIDs,displayedIDs)
        end

        return yOffset
    end

    local function CreateActionsUI()
        local yOffset = -20

        -- Create spell widgets
        yOffset = CreateActionWidgets(API:GetUserActions(), "spell", yOffset)
        yOffset = yOffset-55
        -- Add title between spells and items
        local title = Templates:ItemsTitle(yOffset, primaryFrame)
        title:SetPoint("LEFT", primaryFrame.TitleBg, "LEFT", 10, yOffset-77)

        -- Create item widgets
        yOffset = CreateActionWidgets(API:GetUserActions(), "item", yOffset-10)

        primaryFrame:SetHeight(-yOffset + 155)
    end

    local function EnableFrameDragging()
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

    -- Initialize and set up UI
    SetupPrimaryFrame()
    SetupConfigWidgets()
    SetPrimaryFrameScripts()
    CreateActionsUI()
    EnableFrameDragging()

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
    if primaryFrame then
        local configWidgets = primaryFrame.configWidgets
        configWidgets[1].trackedValue:SetText(Config:GetTableCount(Actions:GetCurrent()))
        configWidgets[3].textValue:SetText(ActionBars:GetCurrentSpecActionBarsCount())
    end
end
function UI:RefreshIcons()
    local cA = Actions:GetCurrent()
    for actionID in pairs(cA) do
        if actionID and cA[actionID][5] == API:GetSpecialization() then
            local widget = cA[actionID][3]
            local spellID = cA[actionID][2]
            local actionType = cA[actionID][9]
            local slotID = cA[actionID][1]
            if widget then
                local newTexture = API:GetActionTexture(spellID, actionType, slotID)
                widget:SetNormalTexture(newTexture)
            end
        end
    end
end
-- Getters & Setters-----------------------
function UI:GetIsVisible()
    return isVisible
end
-- Revision version v1.1.1 ---

