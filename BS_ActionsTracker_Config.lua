--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Config ={};
local Config = BS_ActionsTracker.Config;

--Init------------------------------------
function Config:Init()
    UI = BS_ActionsTracker.UI
    Core = BS_ActionsTracker.Core
    Actions = BS_ActionsTracker.Actions
    Global = BS_ActionsTracker.Global
end
--Config:Functions------------------------
function Config:CreateCommands()

SLASH_BS1 = "/bs"
SlashCmdList["BS"] = function(msg)
    Config:ToggleConfigMode()
end
function Config:ToggleConfigMode()
--if frame is open
if not IsActionsTrackerPrimaryFrameVisible then 
    -- if frame is closed    
    UI:DisplayActions(Actions.GetUserActions2(),UI:GetFrame(1));  
    UI:GetFrame(1):Show()
    UI:GetFrame(2):SetMovable(true) 
    UI:GetFrame(2).title:SetText("BS_ActionsTracker - move frame,edit text")
    Actions:SetIsConfigMode(true)
    IsActionsTrackerConfigMode = true    
    UI:GetFrame(2):Show()
    for k,v in pairs(Actions.GetTrackedActions()) do
        if v[3]~=nill then
        v[3].edit:SetEnabled(true)
        end
    end     
    IsActionsTrackerPrimaryFrameVisible = true
    else
        UI:GetFrame(1):Hide()
        UI:GetFrame(2):SetMovable(false) 
        UI:GetFrame(2).title:SetText("")
        Actions:SetIsConfigMode(false) 
        UI:UpdateTrackedActions(Actions.GetTrackedActions())
        IsActionsTrackerConfigMode = false 
        for k,v in pairs(Actions.GetTrackedActions()) do
            if v[3]~=nill then
            v[3].edit:SetEnabled(false)
            end
        end 
        IsActionsTrackerPrimaryFrameVisible = false
    end
    end
end
