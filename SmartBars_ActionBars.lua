-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.ActionBars = {}
local ActionBars = SmartBars.ActionBars
local Config
local Templates
local Actions
local Localization
local API
local UI
local Utils
-- Init------------------------------------
function ActionBars:Init()
    Config = SmartBars.Config
    Templates = SmartBars.Templates
    Actions = SmartBars.Actions
    Localization = SmartBars.Localization
    API = SmartBars.API
    UI = SmartBars.UI
    Utils = SmartBars.Utils
end
-- Variables
local framesSpecCount = {}
local framesPosition = {}
local framesScale = {}
local framesAlpha = {}
local framesColumn = {}
local framesHideRest = {}
local frameIDs = {}
local reverseSorting = {}
-- ActionBars----------------------
local framesParent
local frames = {}
function ActionBars:Add()
    -- add new action bar to current specialization
    local spec = Config:GetSpec()
    if framesSpecCount[spec] < 9 then
        framesSpecCount[spec] = framesSpecCount[spec] + 1
        local frameID = Utils:JoinNumber(spec, framesSpecCount[spec])
        frameIDs[frameID] = {frameID, framesSpecCount[spec], spec}
        ActionBars:Create(frameID)
        ActionBars:Toggle(true)
        Config:Save()
        UI:Update()
    end
end
function ActionBars:Create(i)
    if not frames then
        frames = {}
    end
    frames[i] = Templates:ActionBar(i)
    frames[i]:SetParent(framesParent)

    local function SetupActionBars(i)
        -- Setup variables for action bar position,scale etc..
        local defaultFrameScale = 0.75
        local onValueChanged = "OnValueChanged"
        local onClick = "OnClick"
        local defaultFrameAlpha = 1
        local scaleWidget = frames[i].configWidgets[2].settings[2]
        local alphaWidget = frames[i].configWidgets[2].settings[3]
        local columnsWidget = frames[i].configWidgets[2].settings[4]
        local hideWidget = frames[i].configWidgets[2].settings[5]
        local reverseOrderWidget = frames[i].configWidgets[2].settings[6]
        local barWidget = frames[i].configWidgets[2].settings[1]
        local function Position()
            if not framesPosition[i] then
                local i = ActionBars:FindIndex(i)
                local rowCount = 5
                local xOffset = -100
                local yOffset = 280 - (i * 70)
                local point = "CENTER"
                local relativePoint = "CENTER"
                if i > rowCount and i <= 2 * rowCount then
                    xOffset = 100
                    yOffset = 280 - ((i - rowCount) * 70)
                end
                i = ActionBars:FindFrameID(i)
                frames[i]:SetPoint(point, nil, relativePoint, xOffset, yOffset)
                framesPosition[i] = {xOffset, yOffset, point, relativePoint}
            else

                local xOffset = framesPosition[i][1]
                local yOffset = framesPosition[i][2]
                local point = framesPosition[i][3]
                local relativePoint = framesPosition[i][4]
                frames[i]:SetPoint(point, nil, relativePoint, xOffset, yOffset)
            end
        end
        local function Scale()
            if not framesScale[i] then
                frames[i].configWidgets[3]:SetScale(defaultFrameScale)
                scaleWidget.slider:SetValue(defaultFrameScale)
                scaleWidget.text:SetText(Utils:RoundNumber(defaultFrameScale, 2))
            else
                local scale = framesScale[i]
                frames[i].configWidgets[3]:SetScale(scale)
                scaleWidget.slider:SetValue(scale)
                scaleWidget.text:SetText(Utils:RoundNumber(scale, 2))
            end
        end
        local function Alpha()
            if not framesAlpha[i] then
                frames[i].configWidgets[3]:SetAlpha(defaultFrameAlpha)
                alphaWidget.slider:SetValue(defaultFrameAlpha)
                alphaWidget.text:SetText(Utils:RoundNumber(defaultFrameAlpha, 2))
            else
                local alpha = framesAlpha[i]
                frames[i].configWidgets[3]:SetAlpha(alpha)
                alphaWidget.slider:SetValue(alpha)
                alphaWidget.text:SetText(Utils:RoundNumber(alpha, 2))
            end
        end
        local function Columns()
            if not framesColumn[i] then
                framesColumn[i] = 5
                columnsWidget.text2:SetText(framesColumn[i])
            else
                columnsWidget.text2:SetText(framesColumn[i])

            end
        end
        local function Hide()
            if not framesHideRest[i] then
                hideWidget.checkBox:SetChecked(false)
            else
                local value = framesHideRest[i]
                hideWidget.checkBox:SetChecked(value)
            end
        end
        local function ReverseSorting()
            if not reverseSorting[i] then
                reverseOrderWidget.checkBox:SetChecked(false)
            else
                local value = reverseSorting[i]
                reverseOrderWidget.checkBox:SetChecked(value)
            end
        end
        local function Scripts()
            local optionWidget = frames[i].configWidgets[2]
            local iconHolder = frames[i].configWidgets[3]
            --    local barText = frames[i].configWidgets[2].settings[1].text
            local barText = frames[i].configWidgets[2].settings[1].text
            local function EditButton()
                local editButton = frames[i].configWidgets[1]
                editButton.button:SetScript(onClick, function()
                    if optionWidget:IsVisible() then
                        optionWidget:Hide()
                    else
                        optionWidget:Show()
                        for k in pairs(frames) do
                            if k ~= i then
                                frames[k].configWidgets[2]:Hide()
                            end
                        end
                    end
                    barText:SetText(Localization:Bar() .. ActionBars:FindIndex(i))
                end)
            end
            local function BarNavigator()
                barWidget.minusButton:SetScript(onClick, function()
                    ActionBars:HideOptionPanels()
                    if ActionBars:FindIndex(i) >= 2 then
                        local previousWidget = frames[i - 1].configWidgets[2]
                        local previousText = frames[i - 1].configWidgets[2].settings[1].text
                        previousWidget:Show()
                        previousText:SetText(Localization:Bar() .. ActionBars:FindIndex(i - 1))
                    elseif ActionBars:FindIndex(i) == 1 then
                        local function ShowLastOptionWidget()
                            ActionBars:HideOptionPanels()
                            local lastFrameID = select(2, ActionBars:GetHighest())
                            local optionWidget = frames[lastFrameID].configWidgets[2]
                            local barText = frames[lastFrameID].configWidgets[2].settings[1].text
                            optionWidget:Show()
                            barText:SetText(Localization:Bar() .. ActionBars:FindIndex(lastFrameID))

                        end
                        ShowLastOptionWidget()
                    end
                end)
                barWidget.plusButton:SetScript(onClick, function()
                    ActionBars:HideOptionPanels()
                    if frameIDs[i + 1] then
                        local nextWidget = frames[i + 1].configWidgets[2]
                        local nextText = frames[i + 1].configWidgets[2].settings[1].text
                        nextWidget:Show()
                        nextText:SetText(Localization:Bar() .. ActionBars:FindIndex(i + 1))
                    else
                        optionWidget:Show()

                    end
                end)
            end
            local function Scale()
                scaleWidget.slider:SetScript(onValueChanged, function(self)
                    iconHolder:SetScale(self:GetValue())
                    framesScale[i] = self:GetValue()
                    scaleWidget.text:SetText(Utils:RoundNumber(framesScale[i], 2))
                end)
            end
            local function Alpha()
                alphaWidget.slider:SetScript(onValueChanged, function(self)
                    iconHolder:SetAlpha(self:GetValue())
                    framesAlpha[i] = self:GetValue()
                    alphaWidget.text:SetText(Utils:RoundNumber(framesAlpha[i], 2))
                end)
            end
            local function Hide()
                hideWidget.checkBox:SetScript(onClick, function(self)
                    framesHideRest[i] = self:GetChecked()
                end)
            end
            local function ReverseOrder()
                reverseOrderWidget.checkBox:SetScript(onClick, function(self)
                    reverseSorting[i] = self:GetChecked()
                end)
            end
            local function Columns()
                columnsWidget.minusButton:SetScript(onClick, function()
                    if framesColumn[i] >= 2 then
                        framesColumn[i] = framesColumn[i] - 1
                        columnsWidget.text2:SetText(framesColumn[i])
                    end
                end)
                columnsWidget.plusButton:SetScript(onClick, function()
                    framesColumn[i] = framesColumn[i] + 1
                    columnsWidget.text2:SetText(framesColumn[i])
                end)
            end
            local function Drag()
                local onDragStart = "OnDragStart"
                local onDragStop = "OnDragStop"
                local backgroundFrameStrata = "BACKGROUND"
                local tooltipFrameStrata = "TOOLTIP"
                frames[i]:SetScript(onDragStart, function()
                    frames[i]:SetFrameStrata(tooltipFrameStrata)
                    frames[i].configWidgets[3]:SetFrameStrata(tooltipFrameStrata)
                    frames[i].configWidgets[1]:SetFrameStrata(tooltipFrameStrata)
                    frames[i]:StartMoving()
                end)
                frames[i]:SetScript(onDragStop, function()
                    frames[i]:SetFrameStrata(backgroundFrameStrata)
                    frames[i].configWidgets[3]:SetFrameStrata(backgroundFrameStrata)
                    frames[i].configWidgets[1]:SetFrameStrata(backgroundFrameStrata)
                    frames[i]:StopMovingOrSizing()

                end)
            end
            EditButton()
            BarNavigator()
            Scale()
            Alpha()
            Hide()
            Columns()
            Drag()
            ReverseOrder()
        end
        Position()
        Scale()
        Alpha()
        Columns()
        Hide()
        ReverseSorting()
        Scripts()
    end
    SetupActionBars(i)
end
function ActionBars:Load()
    if not frames then
        frames = {}
    end
    if not frameIDs then
        frameIDs = {}
    end
    -- load existing or create first action bar for current spec
    local currentSpecActionsCount = ActionBars:GetCurrentSpecActionBarsCount()
    if currentSpecActionsCount and currentSpecActionsCount ~= 0 then
        for frameID in pairs(frameIDs) do
            ActionBars:Create(frameID)
        end
    else
        local spec = Config:GetSpec()
        framesSpecCount[spec] = 1
        local frameID = Utils:JoinNumber(spec, framesSpecCount[spec])
        frameIDs[frameID] = {frameID, framesSpecCount[spec], spec}
        ActionBars:Create(frameID)
    end

end
function ActionBars:Remove()
    -- remove action bar with highestIndex
    local spec = Config:GetSpec()
    if framesSpecCount[spec] > 1 then
        local lastFrameID = select(2, ActionBars:GetHighest())
        frames[lastFrameID]:Hide()
        frames[lastFrameID].configWidgets[1]:Hide()
        frames[lastFrameID].configWidgets[2]:Hide()
        frames[lastFrameID].configWidgets[3]:Hide()
        frames[lastFrameID] = nil
        frameIDs[lastFrameID] = nil
        framesScale[lastFrameID] = nil
        framesPosition[lastFrameID] = nil
        framesAlpha[lastFrameID] = nil
        framesHideRest[lastFrameID] = nil
        framesColumn[lastFrameID] = nil
        reverseSorting[lastFrameID] = nil


        local tA = Actions:GetTrackedForCurrentSpec()
        for k in pairs(tA) do
            local barNumber = tA[k].trackedFrame
            if barNumber == lastFrameID then
                tA[k].trackedFrame = tA[k].trackedFrame - 1
            end
        end

        framesSpecCount[spec] = framesSpecCount[spec] - 1
    end
    Config:Save()
    UI:Update()
end
function ActionBars:Unload()
    if frames then
        for frameID in pairs(frames) do
            if frames[frameID] then
                frames[frameID]:Hide()
                frames[frameID].configWidgets[1]:Hide() -- Hide iconholder
                frames[frameID].configWidgets[2]:Hide() -- Hide iconholder
                frames[frameID].configWidgets[3]:Hide() -- Hide iconholder
            end
        end
        frames = nil
        frameIDs = nil
    end
end
-- Widgets--------------------------
function ActionBars:HideOptionPanels()
    -- hide all option Panels
    for frameID in pairs(frames) do
        frames[frameID].configWidgets[2]:Hide()
    end
end
function ActionBars:Toggle(value)
    local function toggleBars()
    for _, v in pairs(frameIDs) do
            if v[3] == Config:GetSpec() then
                local frameID = v[1]
                local configWidgets = frames[frameID].configWidgets
                frames[frameID]:SetMovable(value)
                for _ in pairs(configWidgets) do
                    local editButton = configWidgets[1]
                    if value == true then
                        editButton:Show()
                        editButton.button:Show()
                        editButton:EnableMouse(value)
                    else
                        editButton:Hide()
                        editButton:EnableMouse(value)
                        editButton.button:Hide()
                    end

                end
            end

        end
    end
    toggleBars()
    local function toggleWidgets()
   local trackedActions = Actions:GetTrackedForCurrentSpec();
       for _, v in pairs(trackedActions) do
           local widget = v.widget
           if v.currentSpec == Config:GetSpec() then
           widget.edit:EnableMouse(value)
               if widget and widget.edit and widget.group and widget.charges then
                   widget:EnableMouse(value)
                   if value == true then
                       widget.edit:SetEnabled(value)
                       widget.group:Show()
                       widget.charges:Hide()
                   else
                       widget.group:Hide()
                       widget.charges:Show()
                       widget.edit:SetEnabled(value)
                       ActionBars:HideOptionPanels()
                   end
               end
           end
       end
    end
    toggleWidgets()
end
-- Find-------------------------
function ActionBars:FindIndex(frameID)
    for k, v in pairs(frameIDs) do
        if k == frameID then
            return v[2]
        end
    end
end
function ActionBars:FindFrameID(frameIndex)
    -- return frameID based on frameIndex
    for k, v in pairs(frameIDs) do
        if v[2] == frameIndex and v[3] == Config:GetSpec() then
            return k
        end
    end
end
-- Update----------------------
function ActionBars:Start()
        framesParent = CreateFrame("Frame", nil, nil)
        framesParent:SetScript("OnUpdate", function()
            local actions = Actions:GetTrackedForCurrentSpec()
            ActionBars:Update(actions)
            for frameID, v in pairs(frameIDs) do
                if v[3] == Config:GetSpec() then
                    ActionBars:Sort(frameID, actions)
                end
            end
        end)
end
function ActionBars:Stop()
    if framesParent then
        framesParent:SetScript("OnUpdate", nil)
    end
end
function ActionBars:Update(actions)
    if(Config:GetIsRealoding()== false) then
        -- determinate if widget will be visible or hidden
        local configMode = Config:GetConfigMode() -- 1 in config
        local isResting = Config:GetResting() -- 1 in config
        local isPvPing = Config:GetPVP() -- 1 in config
        local globalHideRest = Config:GetGlobalHideRest() -- 1 ab 1 ui
        local isGliding = Config:GetIsGliding()
        local isHideWhenMounted = Config:GetHideWhenMounted()
        local isMounted = Config:GetIsMounted()

        for _,actionData in pairs(actions) do
                local slotID = actionData.slotID
                local spellID = actionData.spellId
                local widget = actionData.widget
                local frameIndex = actionData.trackedFrame
                local isBoosted = actionData.isBoosted
                local displayOnlyWhenBoosted = actionData.showOnlyWhenBoosted
                local actionType = actionData.actionType
                local isPVPspell = actionData.isPvpTalent
                local isInCinematic = API:IsInCinematic()
                    if (isBoosted) then
                        ActionButton_ShowOverlayGlow(widget)
                    else
                        ActionButton_HideOverlayGlow(widget)
                    end
                    if configMode == true then
                        widget:Show()
                        ActionButton_HideOverlayGlow(widget)
                    elseif isGliding or isHideWhenMounted and isMounted then
                        widget:Hide()
                    else
                        local isSpellKnown = API:isSpellKnown(spellID, actionType)
                        local isOnActionBars = Actions:isUsedByUser(spellID)
                        if(isSpellKnown and isOnActionBars) then
                            if globalHideRest == true and isResting == true or isResting == true and framesHideRest[frameIndex] == true or
                                    displayOnlyWhenBoosted == true and isBoosted == false or isPvPing == false and isPVPspell == true  or isInCinematic == true then
                                widget:Hide()
                            else
                                local chargesText = API:GetActionCharges(spellID, actionType)
                                widget.charges:SetText(chargesText)
                                local isUsable, notEnoughMana = API:IsUsableAction(spellID, actionType)
                                local duration = API:GetActionCooldown(spellID, actionType)
                                local inRange = API:IsActionInRange(spellID, actionType)

                                if isBoosted == true and displayOnlyWhenBoosted == true and isUsable == true and notEnoughMana == false and
                                        duration < 1.5 and inRange == true or isBoosted == true and displayOnlyWhenBoosted == false and
                                        isUsable == true and notEnoughMana == false and duration < 1.5 and inRange == true then
                                    widget:Show()
                                else
                                    local isUserBuffedBy = API:GetPlayerAuraBySpellID(spellID)
                                    if notEnoughMana == true or isUsable == false or duration > 1.7 or inRange == false or isUserBuffedBy ~=nil then
                                        widget:Hide()
                                    else
                                        widget:Show()
                                    end
                                end
                            end
                        else
                            widget:Hide()
                        end

                    end






        end
    end
end
function ActionBars:Sort(frameID, actions)
    -- Create a sortable list of actions
    local sortedActions = {}
    for actionID, action in pairs(actions) do
        table.insert(sortedActions, action)
    end

    -- Sort the actions by priority: 10 first, then 5, then 1
    table.sort(sortedActions, function(a, b)
        return a.priority > b.priority
    end)

    -- Handle displayed widget position and parent
    local startxOffset = 0
    local startyOffset = 0
    local iconHolder = frames[frameID].configWidgets[3]
    local sorting = reverseSorting[frameID]
    local yOffsetSorting = -50

    if sorting == nil then
        sorting = true
    end
    if sorting then
        yOffsetSorting = 50
    end

    -- Place widgets according to the sorted order
    for _, action in ipairs(sortedActions) do
        local actionFrameNumber = action.trackedFrame
        local widget = action.widget
        if actionFrameNumber == frameID and widget:IsVisible() then
            widget:SetPoint("LEFT", iconHolder, "LEFT", startxOffset, startyOffset)
            widget:SetParent(iconHolder)
            startxOffset = startxOffset + 50
            if startxOffset == framesColumn[frameID] * 50 then
                startxOffset = 0
                startyOffset = startyOffset + yOffsetSorting
            end
        elseif actionFrameNumber == frameID then
            widget:SetPoint("LEFT", iconHolder, "LEFT", startxOffset, startyOffset)
            widget:SetParent(iconHolder)
        end
    end
end
-- Getter & Setters ------------
function ActionBars:Set(loadedSettings)
    framesPosition = loadedSettings.framesPositions
    framesScale = loadedSettings.framesScale
    framesAlpha = loadedSettings.framesAlpha
    framesColumn = loadedSettings.framesColumns
    framesHideRest = loadedSettings.framesRest
    framesSpecCount = loadedSettings.framesCount
    frameIDs = loadedSettings.framesIdNumbers
    reverseSorting = loadedSettings.framesSorting
end
function ActionBars:GetHighest()
    local highestID = 0
    local frameID
    for k, v in pairs(frameIDs) do
        if k ~= nil then
            if v[2] >= highestID and v[3] == Config:GetSpec() then
                highestID = v[2]
                frameID = v[1]
            end
        end
    end

    return highestID, frameID

end
function ActionBars:GetActionBar(frameID)
    return frames[frameID]
end
function ActionBars:GetCurrentSpecActionBarsCount()
    local currentSpec = Config:GetSpec()
    return framesSpecCount[currentSpec]
end
function ActionBars:GetActionBarsValues()
    local function FramesPosition()
        for k in pairs(frames) do
            if k then
                local function CalculateFramePosition(k)
                    local point, _, relativePoint, xOfs, yOfs = frames[k]:GetPoint(1)
                    local function round2(num, numDecimalPlaces)
                        return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
                    end
                    return {round2(xOfs, 2), round2(yOfs, 2), point, relativePoint}
                end
                framesPosition[k] = CalculateFramePosition(k)
            end
        end
        return framesPosition
    end

    return {
        FramesPosition = FramesPosition(),
        FramesScale = framesScale,
        FramesAlpha = framesAlpha,
        FramesColumn = framesColumn,
        FramesHideRest = framesHideRest,
        FramesSpecCounts = framesSpecCount,
        FrameIDs = frameIDs,
        FramesSorting = reverseSorting
    }
end
-- Revision BUILD 207(R)
