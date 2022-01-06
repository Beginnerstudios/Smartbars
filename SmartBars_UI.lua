--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.UI ={}
local UI=SmartBars.UI
local Actions
local Config
local Templates
local ActionBars
--Init------------------------------------
function UI:Init()
Actions = SmartBars.Actions
Config = SmartBars.Config
Templates = SmartBars.Templates
ActionBars = SmartBars.ActionBars
end
--Variables-------------------------------
--Primaryframe
local primaryFrame   
local primaryOptionsWidgets = {}
--Saved variables
local globalHideRest = false
--UI:Frames-------------------------------
function UI:CreatePrimaryFrames()--Create primary frame + ActionUpdater frame 
function Scripts()

    --Primary Frame
  primaryFrame.CloseButton:SetScript("OnClick", function ()
  Config:ToggleConfigMode()
    end) 
    primaryFrame.resetButton:SetScript("OnClick", function ()
      StaticPopup_Show ("SMARTBARS_RESETCONFIRM")  
    end)
    ---Primary options widgets
    local staticTitles = primaryOptionsWidgets[1]
    local restZoneWidget = primaryOptionsWidgets[2]
    local barsWidget = primaryOptionsWidgets[3]
  
    restZoneWidget.checkBox:SetScript("OnClick",function (self)
    globalHideRest = self:GetChecked()
    end)   
      barsWidget.minusButton:SetScript("OnClick", function ()      
        ActionBars:Remove()
      end) 
      barsWidget.plusButton:SetScript("OnClick", function ()   
        ActionBars:Add()     
        end)
  --Option widgets
  
  

end
 primaryFrame,primaryOptionsWidgets = Templates:PrimaryFrame()
 Scripts()
end
--UI:Update-------------------------------
function UI:UpdateUI() ---update all dynamic variables in UI 
  function SetupPrimaryFrame() --handle height of primary frame and primary options widgets + update values for used/tracked actions
    --Count of tracked actions for specific spec
    local trackedActions = Actions:Get()
    local trackedActionForSpecCount =0
    for actionID in pairs(trackedActions) do 
      local actionSpec = trackedActions[actionID][5] 
      local currentSpec = Config:GetSpec()
      if Config:IsValueSame(actionSpec,currentSpec) then
        trackedActionForSpecCount = trackedActionForSpecCount +1
      end
    end
    primaryOptionsWidgets[1].trackedValue:SetText(trackedActionForSpecCount)
    --Determinate height of primary frame
    local usedSpellsCount = Config:GetTableCount(API:GetUserActions())
    primaryOptionsWidgets[1].usedValue:SetText(usedSpellsCount)
    local actionsHeight = usedSpellsCount/6*60+165
    local primaryFrameHeight
    if usedSpellsCount<=18 then 
      primaryFrameHeight = 350
      else 
      primaryFrameHeight = actionsHeight  
    end
    primaryFrame:SetHeight(primaryFrameHeight)
    local barCount = ActionBars:Get():ActionsSpecBarCount(API:GetSpecialization())                                           
    primaryOptionsWidgets[3].textValue:SetText(barCount)
  
  end
  function RefreshTrackedIcons()--update icons on tracked actions
  local tA = Actions:Get()
  for actionID in pairs(tA) do
    if actionID and tA[actionID][5]== API:GetSpecialization()  then
      local widget =tA[actionID][3]
    local spellID = tA[actionID][2]
    local actionType = tA[actionID][9]
    local slotID = tA[actionID][1]
    if widget  then
      local newTexture= API:GetActionTexture(spellID,actionType,slotID)
      widget:SetNormalTexture(newTexture)   
    end
    end
  end
  end
    SetupPrimaryFrame()
    RefreshTrackedIcons()
    Config:SaveConfig()
end
--Getters & Setters-----------------------------
function UI:Get()   --get values from SmartBars_UI                      
  local returnTable =
         {                                         
             CurrentSpec = function(self)                                                                                    
                return  currentSpecialization             
             end,           
             GlobalHideRest = function(self)                                                                                    
              return  globalHideRest
             end,          
             PrimaryFrame = function(self)                                                                                    
             return  primaryFrame
             end            
         }
 return returnTable
end
function UI:GetGlobalHideRest()   --get values from SmartBars_UI                                                                                                       
    return  globalHideRest
end
function UI:Set(loadedGlobalHideRest)--set saved variables
 globalHideRest = loadedGlobalHideRest
end
-- Revision version v0.9.9 ---


