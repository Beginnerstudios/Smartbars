-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Actions = {}
local Actions = SmartBars.Actions
local API
local Config
local Templates
local ActionBars
local UI
local Utils
-- Init------------------------------------
function Actions:Init()
    --  UI = SmartBars.UI
    Utils = SmartBars.Utils
    API = SmartBars.API
    Config = SmartBars.Config
    Templates = SmartBars.Templates
    ActionBars = SmartBars.ActionBars
    UI = SmartBars.UI
    Utils = SmartBars.Utils
end
-- Variables--------------------------------
local trackedActions
local allTrackedActions
-- Actions:Functions-----------------------
function Actions:AddOrRemove(action,actionId)
    trackedActions = Actions:GetTrackedForCurrentSpec()
    if trackedActions[actionId] then
        Actions:Delete(actionId)
        UI:Update()
    else
        Actions:Create(action,actionId,true)
    end
    UI:Update()
end
function Actions:Load()
    trackedActions = Actions:GetTrackedForCurrentSpec()
    local currentSpec =API:GetSpecialization()
    if Utils:GetTableCount(trackedActions) > 0 then
        for actionID,action in pairs(trackedActions) do
            if trackedActions[actionID].currentSpec == currentSpec then
                Actions:Create(action, actionID,false)
            end
        end
    end
end
function Actions:Unload()
    if Utils:GetTableCount(trackedActions) > 0 then
        for actionID in pairs(trackedActions) do
            Actions:Delete(trackedActions[actionID])
        end
        trackedActions = nil
        trackedActions = {}
    end
end
function Actions:Create(action, key,isFromUiFrame)
    local onClick = "OnClick"
    if not action.priority then
    action.priority = 5
    end
    trackedActions[key] = {}
    trackedActions[key].slotId = action.slotId
    trackedActions[key].spellId = action.spellId
    trackedActions[key].widget = Templates:PanelActionWidget(ActionBars:GetActionBar(select(2,ActionBars:GetHighest())).configWidgets[3],false,action.spellId,action.actionType)
    trackedActions[key].actionText = action.actionText
    trackedActions[key].currentSpec = action.currentSpec
    trackedActions[key].trackedFrame = action.trackedFrame
    local trackedFrame = trackedActions[key].trackedFrame
    if(not trackedFrame)then
        trackedActions[key].trackedFrame = select(2,ActionBars:GetHighest())
    else
        trackedActions[key].trackedFrame = action.trackedFrame
    end
    local actionId = Utils:JoinNumber(trackedActions[key].spellId,trackedActions[key].currentSpec)
    trackedActions[key].isBoosted = false
    trackedActions[key].priority = action.priority
    if action.showOnlyWhenBoosted then
     trackedActions[key].showOnlyWhenBoosted = action.showOnlyWhenBoosted
     else
     trackedActions[key].showOnlyWhenBoosted = false
    end
    trackedActions[key].actionType = action.actionType
    trackedActions[key].isPvpTalent = action.isPvpTalent
    trackedActions[key].widget.edit = Templates:EditBox(trackedActions[key].widget, action.actionText, isFromUiFrame, actionId)
    trackedActions[key].widget.group = Templates:GroupLayout(trackedActions[key].widget,isFromUiFrame,action.priority,trackedActions[key].showOnlyWhenBoosted)
    trackedActions[key].widget.charges = Templates:FontString(trackedActions[key].widget, 13)
    trackedActions[key].widget.edit:EnableMouse(false)
    trackedActions[key].widget:EnableMouse(false)
    if isFromUiFrame then
       trackedActions[key].widget.edit:EnableMouse(true)
        trackedActions[key].widget:EnableMouse(true)
    end
    local function SetupAction()
        trackedActions[key].widget.group.plusButton:SetScript(onClick, function()
           if ActionBars:FindIndex(trackedActions[key].trackedFrame) then
               if ActionBars:FindIndex(trackedActions[key].trackedFrame) < ActionBars:GetCurrentSpecActionBarsCount() then
                   trackedActions[key].trackedFrame = trackedActions[key].trackedFrame + 1
               elseif ActionBars:FindIndex(trackedActions[key].trackedFrame) == ActionBars:GetCurrentSpecActionBarsCount() then
                   trackedActions[key].trackedFrame = Utils:JoinNumber(Config:GetSpec(),1)
               end
           end
        end)
        trackedActions[key].widget.group.minusButton:SetScript(onClick, function()
            if ActionBars:FindIndex(trackedActions[key].trackedFrame) then
                if ActionBars:FindIndex(trackedActions[key].trackedFrame) > 1 then
                    trackedActions[key].trackedFrame = trackedActions[key].trackedFrame - 1
                    trackedActions[key].widget:SetParent(ActionBars:GetActionBar(trackedActions[key].trackedFrame).configWidgets[3])
                 elseif ActionBars:FindIndex(trackedActions[key].trackedFrame) then
                 trackedActions[key].trackedFrame = Utils:JoinNumber(Config:GetSpec(),ActionBars:GetCurrentSpecActionBarsCount())
                end
            end
        end)
        trackedActions[key].widget.group.showWhenBoosted:SetScript(onClick, function(self)
            trackedActions[key].showOnlyWhenBoosted = self:GetChecked()
        end)

          trackedActions[key].widget.edit:SetScript("OnEditFocusLost", function(self)
               trackedActions[key].actionText = self:GetText()
         end)
        allTrackedActions[key] = trackedActions[key]
    end
    SetupAction()
    end
function Actions:Delete(actionId)
    if trackedActions[actionId] then
        trackedActions[actionId].widget:Hide()
        trackedActions[actionId] = nil
        UI:Update()
    end
    if allTrackedActions[actionId] then
        allTrackedActions[actionId].widget:Hide()
        allTrackedActions[actionId] = nil
        UI:Update()
    end
end
-- Getter & Setters ------------
function Actions:Set(loadedTrackedActions)
    allTrackedActions = loadedTrackedActions
end
function Actions:GetAllTrackedActions()
    return allTrackedActions
end
function Actions:GetTrackedForCurrentSpec()
    local currentSpec = API:GetSpecialization();
    tracked = {}
    for actionID, actionData in pairs(Actions:GetAllTrackedActions()) do
        if actionData.currentSpec == currentSpec then
            tracked[actionID] = actionData
        end
    end
    return tracked
end
function Actions:IsTrackedInCurrentSpec(checkedActionId)
    local trackedActionsInCurrentSpec = Actions:GetTrackedForCurrentSpec()
    if Utils:IsTableEmpty(trackedActionsInCurrentSpec) then
        return false
    end
    return trackedActionsInCurrentSpec[checkedActionId] ~= nil
end
function Actions:isUsedByUser(spellId)
 local userActions = Config:GetUserActions()
    for actionID,actionData in pairs(userActions) do
        if tonumber(spellId) == tonumber(actionData.spellId) then
            return true
        end
    end
    return false
end
-- Revision BUILD 207(R)