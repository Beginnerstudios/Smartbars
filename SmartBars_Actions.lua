-- NameSpaces------------------------------
local _, SmartBars = ...
SmartBars.Actions = {}
local Actions = SmartBars.Actions
-- local UI
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
local trackedActions = {}
local currentActions = {}
-- Actions:Functions-----------------------
function Actions:Add(action)
    local tA = Actions:GetTracked()
    local cA = Actions:GetCurrent()
    local actionID = Utils:JoinNumber(action[2], API:GetSpecialization())
    if tA[actionID] then
        cA[actionID][3]:Hide()
        cA[actionID] = nil
        tA[actionID] = nil
    else
        Actions:Create(action, true, false)
    end
    UI:Update()
end
function Actions:Load()
    local tA = Actions:GetTracked()
    if Utils:GetTableCount(tA) > 0 then
        for actionID in pairs(tA) do
            if tA[actionID][5] == API:GetSpecialization() then
                Actions:Create(tA[actionID], false, true, actionID)
            end
        end
    end
end
function Actions:Unload()
    if Utils:GetTableCount(currentActions) > 0 then
        for actionID in pairs(currentActions) do
            Actions:Delete(currentActions[actionID])
        end
        currentActions = nil
        currentActions = {}
    end
end
function Actions:Create(action, isEnabled, isExisting, key)
    local onClick = "OnClick"
    local cA = Actions:GetCurrent()
    local curretSpec
    local actionID
    local trackedFrame = nil
    local isBoosted = false
    local showOnlyWhenBoosted = nil
    local actionType = nil
    local isPVP
    if isExisting == true then
        curretSpec = action[5]
        trackedFrame = action[6]
        showOnlyWhenBoosted = action[8]
        actionID = key
        actionType = action[9]
        if not action[10] then
            isPVP = API:IsPVPTalent(action[2])
        else
            isPVP = action[10]
        end
    else
        actionID = Utils:JoinNumber(action[2], API:GetSpecialization())
        curretSpec = API:GetSpecialization()
        trackedFrame = select(2, ActionBars:GetHighest())
        showOnlyWhenBoosted = false
        actionType = action[6]
        isPVP = API:IsPVPTalent(action[2])
    end
    cA[actionID] = {action[1], action[2],
                    Templates:PanelActionWidget(action, ActionBars:GetActionBar(trackedFrame).configWidgets[3], true),
                    action[4], curretSpec, trackedFrame, isBoosted, showOnlyWhenBoosted, actionType, isPVP}
    cA[actionID][3].edit = Templates:EditBox(cA[actionID][3], cA[actionID], isEnabled,actionID)
    cA[actionID][3].group = Templates:GroupLayout(cA[actionID][3], cA[actionID], isEnabled, actionID)
    cA[actionID][3].charges = Templates:FontString(cA[actionID][3], 15)
    cA[actionID][3]:EnableMouse(false)
    if isExisting == false then
        trackedActions[actionID] = cA[actionID]
    end
    local function SetupAction()
        cA[actionID][3].group.
        plusButton:SetScript(onClick, function()
            if ActionBars:FindIndex(cA[actionID][6]) then
                if ActionBars:FindIndex(cA[actionID][6]) < ActionBars:GetCurrentSpecActionBarsCount() then
                    cA[actionID][6] = cA[actionID][6] + 1
                    trackedActions[actionID][6] = cA[actionID][6]
                end
            end

        end)
        cA[actionID][3].group.minusButton:SetScript(onClick, function()
            if ActionBars:FindIndex(cA[actionID][6]) then
                if ActionBars:FindIndex(cA[actionID][6]) > 1 then
                    cA[actionID][6] = cA[actionID][6] - 1
                    trackedActions[actionID][6] = cA[actionID][6]

                end
            end
        end)


            cA[actionID][3].group.showWhenBoosted:SetScript(onClick, function(self)
                showOnlyWhenBoosted = self:GetChecked()
                trackedActions[actionID][8] = showOnlyWhenBoosted
                cA[actionID][8] = showOnlyWhenBoosted
            end)

        cA[actionID][3].edit:SetScript("OnEditFocusLost", function(self)
            action[4] = self:GetText()
            trackedActions[actionID][4] = action[4]
        end)
    end
    SetupAction()

end
function Actions:Delete(action)
    action[3]:Hide()
    action = nil
    UI:Update()
end
-- Getters & Setters,Reset-----------------------------
function Actions:Set(loadedTrackedActions)
    trackedActions = loadedTrackedActions
end
function Actions:GetTracked()
    return trackedActions
end
function Actions:GetTrackedForCurrentSpec()
    local currentSpec = API:GetSpecialization();
    tracked = {}
    for actionID, actionData in pairs(trackedActions) do
        -- Check if actionData is a table and has the correct specialization
        if  actionData[5] == currentSpec then
            tracked[actionID] = actionData
        end
    end
    return tracked
end
function Actions:GetCurrent()
    return currentActions
end
-- Revision version v1.1.1 ----
