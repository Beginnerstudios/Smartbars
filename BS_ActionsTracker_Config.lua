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
end
function Config:ToggleConfigMode()
    if not IsActionsTrackerPrimaryFrameVisible then    
    IsActionsTrackerPrimaryFrameVisible = true
    UI:DisplayActions(Actions.GetUserActions():GetUsed()[1],UI:GetFrame(1));  
    UI:GetFrame(1):Show()
    UI:GetFrame(2):SetMovable(true) 
    UI:GetFrame(2):EnableMouse(true) 
    UI:GetFrame(2).title:SetText("BS_ActionsTracker - move frame,edit text")
    IsActionsTrackerConfigMode = true    
    UI:GetFrame(2):Show()
    UI:ToggleEditbox(true)    
    else
        UI:GetFrame(1):Hide()
        UI:GetFrame(2):SetMovable(false) 
        UI:GetFrame(2):EnableMouse(false) 
        UI:GetFrame(2).title:SetText("")   
        UI:UpdateTrackedActions(Actions.GetTrackedActions())
        UI:ToggleEditbox(false)
        IsActionsTrackerPrimaryFrameVisible = false
        IsActionsTrackerConfigMode = false  
    end

end
-- Revision version Build 0003 --
