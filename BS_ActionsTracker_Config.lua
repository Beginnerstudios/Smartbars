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
    UI:UpdateUI()
    UI:DisplayActions(Actions.GetActions():Used()[1],UI:GetFrame(1));  
    UI:GetFrame(1):Show()
    UI:GetFrame(2):SetMovable(true) 
    UI:GetFrame(2):EnableMouse(true) 
    UI:GetFrame(2).title:SetAlpha(1)
    IsActionsTrackerConfigMode = true    
    UI:GetFrame(2):Show()
    UI:ToggleEditbox(true)    
    else
        UI:GetFrame(1):Hide()
        UI:GetFrame(2):SetMovable(false) 
        UI:GetFrame(2):EnableMouse(false)      
        UI:GetFrame(2).title:SetAlpha(0)                                            
        UI:ToggleEditbox(false)
        Config:SaveConfig()
        IsActionsTrackerPrimaryFrameVisible = false
        IsActionsTrackerConfigMode = false  
    end

end
function Config:SaveConfig()
    TrackedSpellsFramePosition = UI:GetFramePosition(2)
    TrackedActionsColumnCount = UI:GetTrackedActionsColumnCount()
    TrackedActionsFrameScale = UI:GetFrame(2):GetScale()
    TrackedSpellsCharacter = Actions:GetTrackedActions()
    TrackedActionsPositionIndex = Actions:GetTrackedActionsPositionIndex()
end
function Config:LoadConfig()
Actions:SetCurrentSpecialization(API:GetSpecialization())
UI:SetTrackedActionsFramePosition(TrackedSpellsFramePosition)
UI:SetTrackedActionsColumnCount(TrackedActionsColumnCount)
UI:SetTrackedActionsFrameScale(TrackedActionsFrameScale)
Actions:SetTrackedActions(TrackedSpellsCharacter) 
Actions:SetTrackedActionsPositionIndex(TrackedActionsPositionIndex)   
end
function Config:SetDefaults()
    if not TrackedSpellsCharacter then
        TrackedSpellsCharacter = {}      
    end
    if not TrackedSpellsFramePosition then
      TrackedSpellsFramePosition = {0,-200,"CENTER","CENTER"}      
    end
    if not TrackedActionsColumnCount then
      TrackedActionsColumnCount = 8       
    end   
    if not TrackedActionsFrameScale or TrackedActionsFrameScale == 0 then
    TrackedActionsFrameScale = 1
    end   
end
-- Revision version Build 0004 --
