-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Templates = {}
local Templates = SmartBars.Templates
local Config
local ActionBars
local Localization
local API
-- Init------------------------------------
function Templates:Init()
    Config = SmartBars.Config
    ActionBars = SmartBars.ActionBars
    Localization = SmartBars.Localization
    API = SmartBars.API
end
-----DEV XML Variables--------------
local defaultFont = "GameFontHighLight"
local defaultLayer = "ARTWORK"
local backgroundFrameStrata = "BACKGROUND"
local mediumFrameStrata = "MEDIUM"
local tooltipFrameStrata = "TOOLTIP"
local basicFrameWithInset = "BasicFrameTemplateWithInset"
local actionBarFrameTemplate = "InsetFrameTemplate"
local optionsSliderTemplate = "OptionsSliderTemplate"
local defaultButton = "UIPanelButtonTemplate"
local defaultCheckButton = "ChatConfigCheckButtonTemplate"
local overlayLayer = "OVERLAY"
local fontFrizqt = "Fonts\\FRIZQT__.TTF"
local left = "LEFT"
local right = "RIGHT"
local center = "CENTER"
local top = "TOP"
local outline = "OUTLINE"
local frame = "Frame"
local button = "Button"
local slider = "Slider"
local checkButton = "CheckButton"
local editBox = "EditBox"
local leftButton = "LeftButton"
-- Chars--
local minus = "-"
local plus = "+"
local nextRight = ">"
local nextLeft = "<"
local zero = "0"
local emptyText = " "
-- Defaultvalues--
local defaultFrameScale = 0.75
local minimumScale = 0.3
local maximumScale = 1.5
-- Templates-----------------------------------------------------
function Templates:PrimaryFrame()
    local function Frame()
        local frame = CreateFrame(frame, nil, nil, basicFrameWithInset, defaultLayer)
        frame:EnableMouse(true)
        frame:SetMovable(true)
        frame:RegisterForDrag(leftButton)
        frame:SetFrameStrata(backgroundFrameStrata)
        frame:SetWidth(320)
        frame:SetScale(defaultFrameScale)
        frame:SetPoint(center, nil, center, -450, 100)
        frame:SetClampedToScreen(true)
        frame.resetButton = CreateFrame(button, nil, frame, defaultButton)
        frame.resetButton:SetPoint(right, frame.TitleBg, right, -50, 0)
        frame.resetButton:SetSize(50, 15)
        frame.resetButton:SetNormalFontObject(defaultFont)
        frame.resetButton:SetText(Localization:ResetAll())
        frame.title = frame:CreateFontString(nil, defaultLayer)
        frame.title:SetPoint(left, frame.TitleBg, left, 5, -2)
        frame.title:SetFontObject(defaultFont)
        frame.title:SetText(Localization:AddonName() .. Config:GetSmartBarsInfo())
        return frame
    end
    local function StaticTitles()
        local titles = CreateFrame(frame, nil, UIConfig)
        local titleOffsetX = 10
        local valueOffsetX = 95
        local yZeroOffset = 0
        local yOffset = 20
        titles.usedStatic = titles:CreateFontString(nil, defaultLayer)
        titles.usedStatic:SetPoint(left, titles, left, titleOffsetX, yZeroOffset)
        titles.usedStatic:SetFontObject(defaultFont)
        titles.usedStatic:SetText(Localization:UsedActions())

        titles.trackedStatic = titles:CreateFontString(nil, defaultLayer)
        titles.trackedStatic:SetPoint(left, titles, left, titleOffsetX, yOffset * -1)
        titles.trackedStatic:SetFontObject(defaultFont)
        titles.trackedStatic:SetText(Localization:TrackedActions())

        titles.actionsStatic = titles:CreateFontString(nil, defaultLayer)
        titles.actionsStatic:SetPoint(left, titles, left, titleOffsetX, (3 * (yOffset)) * -1)
        titles.actionsStatic:SetFontObject(defaultFont)
        titles.actionsStatic:SetText(Localization:YourActions())

        titles.trackedValue = titles:CreateFontString(nil, defaultLayer)
        titles.trackedValue:SetPoint(left, titles.trackedStatic, left, valueOffsetX, yZeroOffset)
        titles.trackedValue:SetFontObject(defaultFont)
        titles.trackedValue:SetText(zero)

        titles.usedValue = titles:CreateFontString(nil, defaultLayer)
        titles.usedValue:SetPoint(left, titles.usedStatic, left, valueOffsetX, yZeroOffset)
        titles.usedValue:SetFontObject(defaultFont)
        titles.usedValue:SetText(zero)
        return titles
    end
    local function BarsWidget()
        local barsWidget = CreateFrame(frame, nil)
        barsWidget.textStatic = barsWidget:CreateFontString(nil, defaultLayer)
        barsWidget.textStatic:SetPoint(left, barsWidget, center, 50, 0)
        barsWidget.textStatic:SetFontObject(defaultFont)
        barsWidget.textStatic:SetText(Localization:Bar())
        barsWidget.textValue = barsWidget:CreateFontString(nil, defaultLayer)
        barsWidget.textValue:SetPoint(center, barsWidget, center, 75, 0)
        barsWidget.textValue:SetFontObject(defaultFont)

        barsWidget.minusButton = CreateFrame(button, nil, barsWidget, defaultButton, defaultLayer)
        barsWidget.minusButton:SetPoint(center, barsWidget, center, 50, -20)
        barsWidget.minusButton:SetSize(25, 25)
        barsWidget.minusButton:SetText(minus)
        barsWidget.minusButton:SetNormalFontObject(defaultFont)
        barsWidget.minusButton.tooltipText = Localization:RemoveActionBar()

        barsWidget.plusButton = CreateFrame(button, nil, barsWidget, defaultButton, defaultLayer)
        barsWidget.plusButton:SetPoint(center, barsWidget, center, 75, -20)
        barsWidget.plusButton:SetSize(25, 25)
        barsWidget.plusButton:SetText(plus)
        barsWidget.plusButton:SetNormalFontObject(defaultFont)
        barsWidget.plusButton.tooltipText = Localization:AddActionBar()
        return barsWidget
    end
    local function RestZoneWidget()
        local widget = CreateFrame(frame, nil)
        widget:SetSize(35, 35)
        widget.checkBox = CreateFrame(checkButton, nil, widget, defaultCheckButton, defaultLayer)
        widget.checkBox:SetSize(20, 20)
        widget.checkBox:SetPoint(center, widget, center, 105, 0)
        widget.checkBox:SetHitRectInsets(0, 0, 0, 0)
        widget.checkBox.tooltip = Localization:HideAllActions()
        widget.title = widget:CreateFontString(nil, defaultLayer)
        widget.title:SetPoint(left, widget, center, 0, 0)
        widget.title:SetFontObject(defaultFont)
        widget.title:SetText(Localization:HideActionsTitle())

        widget.loadingCheckBox = CreateFrame(checkButton, nil, widget, defaultCheckButton, defaultLayer)
        widget.loadingCheckBox:SetSize(20, 20)
        widget.loadingCheckBox:SetPoint(center, widget, center, 105, -20)
        widget.loadingCheckBox:SetHitRectInsets(0, 0, 0, 0)
        widget.loadingCheckBox.tooltip = Localization:LoadingMessageTooltip()
        widget.loadingTitle = widget:CreateFontString(nil, defaultLayer)
        widget.loadingTitle:SetPoint(left, widget, center, 0, -20)
        widget.loadingTitle:SetFontObject(defaultFont)
        widget.loadingTitle:SetText(Localization:LoadingMessageTitle())
        return widget
    end

    local primaryFrame = Frame()
    primaryFrame.configWidgets = {StaticTitles(), RestZoneWidget(), BarsWidget()}
    local xOfs = 0
    for k in pairs(primaryFrame.configWidgets) do
        primaryFrame.configWidgets[k]:SetPoint(left, primaryFrame.TitleBg, left, (xOfs), -30)
        primaryFrame.configWidgets[k]:SetParent(primaryFrame)
        primaryFrame.configWidgets[k]:SetSize(80, 80)
        xOfs = xOfs + 85
    end
    return primaryFrame
end
function Templates:ActionBar(index)

    local actionBar = CreateFrame(frame, nil, nil, nil, defaultButton)
    local function Frame()
        actionBar:EnableMouse(true)
        actionBar:RegisterForDrag(leftButton)
        actionBar:SetFrameStrata(backgroundFrameStrata)
        actionBar:SetMovable(true)
        actionBar:SetSize(100, 20)
        actionBar:SetClampedToScreen(true)
        return actionBar
    end
    local edit = CreateFrame(frame, nil, nil, actionBarFrameTemplate)
    local function Edit()
        edit:SetPoint(center, actionBar, center, -30, 0)
        edit:SetSize(15, 15)
        edit.button = CreateFrame(button, nil, actionBar, defaultButton, backgroundFrameStrata)
        edit.button:Hide()
        edit.button:SetPoint(center, edit, center, -10, -30)
        edit.button:SetSize(40, 20)
        edit.button.text = edit.button:CreateFontString(nil, "BACKGROUND")
        edit.button.text:SetPoint(center, edit.button, center, 0, 0)
        edit.button.text:SetFontObject(defaultFont)
        edit.button.text:SetText(Localization:Bar() .. ActionBars:FindIndex(index))
        return edit
    end
    local function OptionWidget()
        local optionWidget = CreateFrame(frame, nil, nil, actionBarFrameTemplate, overlayLayer)
        optionWidget:SetFrameStrata(tooltipFrameStrata)
        optionWidget:SetPoint(left, edit, right, 10, 170)
        optionWidget:SetSize(150, 300)
        optionWidget:SetScale(0.75)
        optionWidget:EnableMouse(false)
        local function BarNavigator()
            local barNavigator = CreateFrame(frame, nil, nil, nil, overlayLayer)
            barNavigator.text = barNavigator:CreateFontString(nil, overlayLayer)
            barNavigator.text:SetPoint(center, barNavigator, center, 0, -20)
            barNavigator.text:SetFontObject(defaultFont)
            barNavigator.text:SetText(Localization:Bar() .. index)
            barNavigator.text2 = barNavigator:CreateFontString(nil, defaultLayer)
            barNavigator.text2:SetPoint(center, barNavigator, center, -15, -20)
            barNavigator.text2:SetFontObject(defaultFont)
            barNavigator.minusButton = CreateFrame(button, nil, barNavigator, defaultButton, overlayLayer)
            barNavigator.minusButton:SetPoint(center, barNavigator, center, -35, -20)
            barNavigator.minusButton:SetSize(25, 25)
            barNavigator.minusButton:SetText(nextLeft)
            barNavigator.minusButton:SetNormalFontObject(defaultFont)

            barNavigator.plusButton = CreateFrame(button, nil, barNavigator, defaultButton, overlayLayer)
            barNavigator.plusButton:SetPoint(center, barNavigator, center, 35, -20)
            barNavigator.plusButton:SetSize(25, 25)
            barNavigator.plusButton:SetText(nextRight)
            barNavigator.plusButton:SetNormalFontObject(defaultFont)

            return barNavigator
        end
        local function ScaleSlider()
            local scaleWidget = CreateFrame(frame, nil)
            scaleWidget.title = scaleWidget:CreateFontString(nil, overlayLayer)
            scaleWidget.title:SetPoint(left, scaleWidget, center, -50, 0)
            scaleWidget.title:SetFontObject(defaultFont)
            scaleWidget.title:SetText(Localization:ScaleText())
            scaleWidget.slider = CreateFrame(slider, nil, scaleWidget, optionsSliderTemplate)
            scaleWidget.slider:SetPoint(center, scaleWidget, center, 0, -20)
            scaleWidget.slider:SetWidth(100)
            scaleWidget.slider:SetHeight(15)
            scaleWidget.slider:SetMinMaxValues(minimumScale, maximumScale)
            scaleWidget.text = scaleWidget:CreateFontString(nil, overlayLayer)
            scaleWidget.text:SetPoint(center, scaleWidget.title, center, 75, 0)
            scaleWidget.text:SetFontObject(defaultFont)
            scaleWidget.slider:SetStepsPerPage(10)

            return scaleWidget
        end
        local function AlphaSlider()
            local alphaWidget = CreateFrame(frame, nil)
            alphaWidget.title = alphaWidget:CreateFontString(nil, overlayLayer)
            alphaWidget.title:SetPoint(left, alphaWidget, center, -50, 0)
            alphaWidget.title:SetFontObject(defaultFont)
            alphaWidget.title:SetText(Localization:AlphaText())
            alphaWidget.slider = CreateFrame(slider, nil, alphaWidget, optionsSliderTemplate)
            alphaWidget.slider:SetPoint(center, alphaWidget, center, 0, -20)
            alphaWidget.slider:SetWidth(100)
            alphaWidget.slider:SetHeight(15)
            alphaWidget.slider:SetMinMaxValues(0.3, 1)
            alphaWidget.text = alphaWidget:CreateFontString(nil, overlayLayerv)
            alphaWidget.text:SetPoint(center, alphaWidget.title, center, 70, 0)
            alphaWidget.text:SetFontObject(defaultFont)
            alphaWidget.slider:SetStepsPerPage(10)
            return alphaWidget
        end
        local function ColumnsWidgets()
            local columnsWidget = CreateFrame(frame, nil)
            columnsWidget.text = columnsWidget:CreateFontString(nil, overlayLayer)
            columnsWidget.text:SetPoint(left, columnsWidget, center, -50, 0)
            columnsWidget.text:SetFontObject(defaultFont)
            columnsWidget.text:SetText(Localization:ColumnText())
            columnsWidget.text2 = columnsWidget:CreateFontString(nil, overlayLayer)
            columnsWidget.text2:SetPoint(center, columnsWidget, center, 35, 0)
            columnsWidget.text2:SetFontObject(defaultFont)

            columnsWidget.minusButton = CreateFrame(button, nil, columnsWidget, defaultButton, overlayLayer)
            columnsWidget.minusButton:SetPoint(left, columnsWidget, center, 0, -20)
            columnsWidget.minusButton:SetSize(25, 25)
            columnsWidget.minusButton:SetText(minus)
            columnsWidget.minusButton:SetNormalFontObject(defaultFont)
            columnsWidget.minusButton.tooltipText = Localization:DecreaseColumns()
            columnsWidget.plusButton = CreateFrame(button, nil, columnsWidget, defaultButton, overlayLayer)
            columnsWidget.plusButton:SetPoint(left, columnsWidget, center, 22, -20)
            columnsWidget.plusButton:SetSize(25, 25)
            columnsWidget.plusButton:SetText(plus)
            columnsWidget.plusButton:SetNormalFontObject(defaultFont)
            columnsWidget.plusButton.tooltipText = Localization:IncreaseColumns()
            return columnsWidget
        end
        local function RestZoneWidget()
            local restZoneWidget = CreateFrame(frame, nil)
            restZoneWidget.checkBox = CreateFrame(checkButton, nil, restZoneWidget, defaultCheckButton, overlayLayer)
            restZoneWidget.checkBox.tooltipText = Localization:HideFrameActions()
            restZoneWidget.checkBox:SetHitRectInsets(0, 0, 0, 0)
            restZoneWidget.checkBox:SetSize(35, 35)
            restZoneWidget.checkBox:SetPoint(right, restZoneWidget, center, 50, 00)
            restZoneWidget.checkBox.tooltip = Localization:HideAllActions()
            restZoneWidget.title = restZoneWidget:CreateFontString(nil, overlayLayer)
            restZoneWidget.title:SetPoint(left, restZoneWidget, center, -50, 0)
            restZoneWidget.title:SetFontObject(defaultFont)
            restZoneWidget.title:SetText(Localization:HideActionsTitle())
            return restZoneWidget
        end
        local function Sorting()
            local restZoneWidget = CreateFrame(frame, nil)
            restZoneWidget.checkBox = CreateFrame(checkButton, nil, restZoneWidget, defaultCheckButton, overlayLayer)
            restZoneWidget.checkBox.tooltipText = Localization:HideFrameActions()
            restZoneWidget.checkBox:SetHitRectInsets(0, 0, 0, 0)
            restZoneWidget.checkBox:SetSize(35, 35)
            restZoneWidget.checkBox:SetPoint(right, restZoneWidget, center, 50, 00)
            restZoneWidget.checkBox.tooltip = Localization:ReverseSortingTooltip()
            restZoneWidget.title = restZoneWidget:CreateFontString(nil, overlayLayer)
            restZoneWidget.title:SetPoint(left, restZoneWidget, center, -50, 0)
            restZoneWidget.title:SetFontObject(defaultFont)
            restZoneWidget.title:SetText(Localization:ReverseSortingTitle())
            return restZoneWidget
        end

        optionWidget.settings = {BarNavigator(), ScaleSlider(), AlphaSlider(), ColumnsWidgets(), RestZoneWidget(),
                                 Sorting()}
        local yOfs = 0
        for k in pairs(optionWidget.settings) do
            optionWidget.settings[k]:SetPoint(center, optionWidget, top, 0, (yOfs) * -1)
            optionWidget.settings[k]:SetParent(optionWidget)
            optionWidget.settings[k]:SetSize(35, 35)
            yOfs = yOfs + 55
        end
        return optionWidget
    end
    local function IconHolder()
        local iconHolder = CreateFrame(frame, nil, nil, nil, overlayLayer)
        iconHolder:SetPoint(center, actionBar, center, 0, -50)
        iconHolder:SetSize(50, 50)
        iconHolder:EnableMouse(false)
        return iconHolder
    end
    local actionBar = Frame()
    actionBar.configWidgets = {Edit(), OptionWidget(), IconHolder()}
    for k in pairs(actionBar.configWidgets) do
        if k ~= 3 then
            actionBar.configWidgets[k]:Hide()
        end
    end
    return actionBar
end
function Templates:GroupLayout(parentWidget, valueToSave, isDisplayed)
    -- Add group layout to desired widget
    local yOfs = -15
    local newWidget = CreateFrame(frame, nil, parentWidget)
    newWidget:SetPoint(center, parentWidget, center, 0, 0)
    newWidget.barNumberText = newWidget:CreateFontString(nil, defaultLayer)
    newWidget.barNumberText:SetPoint(center, parentWidget, center, 17, -17)
    newWidget.barNumberText:SetFont(fontFrizqt, 15, defaultLayer)
    if Config:IsCurrentPatch() then
        newWidget.showWhenBoosted = CreateFrame(checkButton, nil, newWidget, defaultCheckButton, defaultLayer)
        newWidget.showWhenBoosted:SetHitRectInsets(0, 0, 0, 0)
        newWidget.showWhenBoosted:SetPoint(center, parentWidget, center, 18, 18)
        newWidget.showWhenBoosted:SetSize(20, 20)
        newWidget.showWhenBoosted:SetChecked(valueToSave[8])
        newWidget.showWhenBoosted:SetNormalFontObject(defaultFont)
        newWidget.showWhenBoosted.tooltipText = Localization:DisplayWhenBoosted()
    end
    newWidget.minusButton = CreateFrame(button, nil, newWidget, defaultButton, defaultLayer)
    newWidget.minusButton:SetPoint(center, parentWidget, center, -15, yOfs)
    newWidget.minusButton:SetSize(20, 20)
    newWidget.minusButton:SetText(minus)
    newWidget.minusButton.tooltipText = Localization:ChangeBar()
    newWidget.minusButton:SetNormalFontObject(defaultFont)

    newWidget.plusButton = CreateFrame(button, nil, newWidget, defaultButton, defaultLayer)
    newWidget.plusButton:SetPoint(center, parentWidget, center, 0, yOfs)
    newWidget.plusButton:SetSize(20, 20)
    newWidget.plusButton:SetText(plus)
    newWidget.plusButton:SetNormalFontObject(defaultFont)
    newWidget.plusButton.tooltipText = Localization:ChangeBar()
    if not isDisplayed then
        newWidget:Hide()
    end
    return newWidget
end
function Templates:EditBox(parentWidget, valueToSave, isEnabled)
    -- Add editbox with desired text on frame
    local edit = CreateFrame(editBox, nil, parentWidget, nil, defaultLayer)
    edit:SetPoint(center, parentWidget, center, 2, 0)
    edit:SetSize(50, 50)
    edit:SetText(valueToSave[4])
    edit:SetAutoFocus(false)
    edit:SetMaxLetters(3)
    edit.tooltipText = Localization:ChangeBar()
    edit:SetEnabled(isEnabled)
    edit:SetFont(fontFrizqt, 25, outline)
    return edit
end
function Templates:FontString(parentWidget, fontSize, someText)
    -- Add fontstring with desired parameters
    local fontString = parentWidget:CreateFontString(nil, defaultLayer)
    fontString:SetPoint(right, parentWidget, center, 22, -17)
    fontString:SetFont(fontFrizqt, fontSize, nil)
    if not someText then
        fontString:SetText(emptyText)
    else
        fontString:SetText(someText)
    end
    return fontString
end
function Templates:ActionWidget(action, parentFrame, isTracked, isFound)
    -- Return widget with correct size and textures
    local actionWidget = CreateFrame(checkButton, nil, parentFrame, defaultCheckButton, defaultLayer)
    actionWidget:SetPoint(left, parentFrame, left, 0, 0)
    actionWidget:SetHitRectInsets(0, 0, 0, 0)
    actionWidget:SetSize(50, 50)
    actionWidget.tooltip = API:GetDisplayedActionInfo(action[2], action[6])
    local newTexture = API:GetActionTexture(action[2], action[6])

    actionWidget:SetFrameStrata(mediumFrameStrata)
    if newTexture then
        if isTracked then
            actionWidget:SetHighlightTexture(newTexture)
            actionWidget:SetPushedTexture(newTexture)
        else
            actionWidget:SetHighlightTexture(newTexture)
            actionWidget:SetPushedTexture(newTexture)
        end
        actionWidget:SetNormalTexture(newTexture)
    end

    return actionWidget
end
function Templates:PanelActionWidget(action, parentFrame, isTracked, isFound)
    -- Return widget with correct size and textures
    local actionWidget = CreateFrame(checkButton, nil, parentFrame, defaultCheckButton, defaultLayer)
    actionWidget:SetPoint(left, parentFrame, left, 0, 0)
    actionWidget:SetHitRectInsets(0, 0, 0, 0)
    actionWidget:SetSize(50, 50)
    actionWidget:SetFrameStrata(mediumFrameStrata)
    if action[6] and action[2] ~= nil then
        actionWidget:SetNormalTexture(API:GetActionTexture(action[2], action[6]))
    end

    return actionWidget
end
-- Revision v 1.1.1 --
