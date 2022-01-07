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
function UI:Create()--Create primary frame + ActionUpdater frame 
function Scripts()

    --Primary Frame
  primaryFrame.CloseButton:SetScript("OnClick", function ()
  UI:Delete()
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
function CreateUserActions(actions)
  local xOffstet = 0
  local yOffset = -20
  local count = 0 
  for k in pairs(actions) do
    local widget = actions[k][3]
    widget=Templates:CreateActionWidget(actions[k],primaryFrame,false)
    widget:SetPoint("LEFT",primaryFrame.TitleBg,"LEFT",xOffstet+10,yOffset-100)
    local actionType =actions[k][6]
    local actionID = actions[k][2]
    local actionName = API:GetDisplayedActionInfo(actionID,actionType)
    if actionType =="item" then
      widget.tooltipText = actionType.." - "..actionName
    else
      widget.tooltipText = actionName
    end
    xOffstet = xOffstet+50
    count = count +1
    --Next line after 12 spells
    if(count==6) then
      yOffset = yOffset -55
      xOffstet = 0
      count=0
    end
    --Compare widgets with tracked actions
    for _,v in pairs(Actions:GetTracked()) do
      if Config:IsValueSame(actions[k][2],v[2]) and Config:IsValueSame(v[5],API:GetSpecialization()) then
        widget:SetChecked(true)
      end
    end
    -- ACTION WIDGETS -- EVENTS 
    widget:SetScript("OnClick",function (self) 
    Actions:Add(actions[k]) end)  
  end  
  UI:Update()
end 
CreateUserActions(API:GetUserActions(),primaryFrame)    
end
function UI:Delete()
  if primaryFrame and primaryOptionsWidgets then
    primaryFrame:Hide()
    primaryFrame = nil
    primaryOptionsWidgets = nil
  end
end
--UI:Update-------------------------------
function UI:Update() ---update all dynamic variables in UI 
  function SetupPrimaryFrame() --handle height of primary frame and primary options widgets + update values for used/tracked actions
    --Count of tracked actions for specific spec
    local trackedActions = Actions:GetCurrent()
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
    SetupPrimaryFrame()
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
function UI:RefreshTrackedIcons()--update icons on tracked actions
  local cA = Actions:GetCurrent()
  for actionID in pairs(cA) do
    if actionID and cA[actionID][5]== API:GetSpecialization()  then
      local widget =cA[actionID][3]
    local spellID = cA[actionID][2]
    local actionType = cA[actionID][9]
    local slotID = cA[actionID][1]
    if widget  then
      local newTexture= API:GetActionTexture(spellID,actionType,slotID)
      widget:SetNormalTexture(newTexture)   
    end
    end
  end
  end
function UI:GetGlobalHideRest()   --get values from SmartBars_UI                                                                                                       
    return  globalHideRest
end
function UI:Set(loadedGlobalHideRest)--set saved variables
 globalHideRest = loadedGlobalHideRest
end
-- Revision version v1.0.0 ---


