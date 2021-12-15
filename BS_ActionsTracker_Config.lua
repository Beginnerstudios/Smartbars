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
--Config:Variables------------------------
local isConfigMode = false
local isPrimaryFrameVisible = false

--Config:Functions------------------------
function Config:CreateCommands()
    SLASH_BS1 = "/bs"
    SlashCmdList["BS"] = function(msg)
    Config:ToggleConfigMode()
    end
end
function Config:ToggleConfigMode()
    if not Config:IsPrimaryFrameVisible() then    
    isPrimaryFrameVisible = true
    UI:UpdateUI()
    UI:DisplayActions(Actions.GetActions():Used()[1],UI:GetPrimaryFrame());  
    UI:GetPrimaryFrame():Show()
    UI:ShowSecondaryFrames()
    isConfigMode = true       
    UI:ToggleEditbox(true)    
    else
        UI:GetPrimaryFrame():Hide()
        UI:HideSecondaryFrames()                                           
        UI:ToggleEditbox(false)
        Config:SaveConfig()
        isPrimaryFrameVisible = false
        isConfigMode = false  
    end

end
function Config:SaveConfig()
    TrackedSpellsFramePosition = UI:GetTrackedActionsFramesPosition()
    TrackedActionsColumnCount = UI:GetTrackedActionsColumnCount()
    TrackedActionsFrameScale = UI:GetActionBar(1):GetScale()
    TrackedSpellsCharacter = Actions:GetTrackedActions()
    TrackedActionsFrameCount = UI:GetTrackedActionsFrameCount()
    TrackedActionsHideInRestZone =UI:GetTrackedActionsHideInSaveZones()
end
function Config:LoadConfig()
UI:SetSavedVariables(TrackedSpellsFramePosition,TrackedActionsColumnCount,TrackedActionsFrameScale,TrackedActionsFrameCount,TrackedActionsHideInRestZone)
Actions:SetCurrentSpecialization(API:GetSpecialization())
Actions:SetTrackedActions(TrackedSpellsCharacter)    
end
function Config:SetDefaults()
    if not IsCleared then
       IsCleared = false
    end
    if not TrackedSpellsCharacter then
        TrackedSpellsCharacter = {}      
    end
    if not TrackedActionsFrameCount then
        TrackedActionsFrameCount = 1     
    end
    if not TrackedSpellsFramePosition then
      TrackedSpellsFramePosition ={} 
      TrackedSpellsFramePosition[1] = {250,300,"CENTER","CENTER"}     
      TrackedSpellsFramePosition[2] = {250,200,"CENTER","CENTER"} 
      TrackedSpellsFramePosition[3] = {250,100,"CENTER","CENTER"} 
      TrackedSpellsFramePosition[4] = {250,0,"CENTER","CENTER"} 
      TrackedSpellsFramePosition[5] = {250,-100,"CENTER","CENTER"}  
    end
    if not TrackedActionsColumnCount then
      TrackedActionsColumnCount = 8       
    end   
    if not TrackedActionsHideInRestZone then
        TrackedActionsHideInRestZone = false
    end
    if not TrackedActionsFrameScale or TrackedActionsFrameScale == 0 then
    TrackedActionsFrameScale = 1
    end   
end
function Config:UpdateUI()
UI:UpdateUI()
end
function Config:IsPrimaryFrameVisible()
    if isPrimaryFrameVisible then
    return true
    else
    return false
    end
end
function Config:IsConfigMode()
    if isConfigMode then
        return true
        else
        return false
        end 
end
function Config:IsCurrentPatch()
if API:GetBuildInfo() == "9.1.5" or API:GetBuildInfo() == "9.2.0" then
    return true
else
    return false
end
end
function Config:ResetAll()
    TrackedSpellsFramePosition = nill
    TrackedActionsColumnCount=nill
    TrackedActionsFrameScale=nill
    TrackedSpellsCharacter=nill
    TrackedActionsFrameCount=nill
    TrackedActionsHideInRestZone=nill
    ReloadUI()
end
-- Revision version Build 0007 --
