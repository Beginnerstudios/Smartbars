--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.UI ={}
local UI=SmartBars.UI
local Actions
local Config
local Templates
local ActionBars
local API
--Init------------------------------------
function UI:Init()
Actions = SmartBars.Actions
Config = SmartBars.Config
Templates = SmartBars.Templates
ActionBars = SmartBars.ActionBars
API = SmartBars.API
end
--Variables-------------------------------
--Primaryframe
local primaryFrame 
local isVisible = false  
--DevEvents--
local onClick ="OnClick"

--UI:Frames-------------------------------
function UI:Create()--Create primary frame + ActionUpdater frame 
  local function Scripts()
    local configWidgets = primaryFrame.configWidgets
    primaryFrame.CloseButton:SetScript(onClick, function ()
      UI:Delete()
      Config:Toggle()
    end) 
    primaryFrame.resetButton:SetScript(onClick, function ()
      local confirmPopup = "SMARTBARS_RESETCONFIRM"
      StaticPopup_Show (confirmPopup)  
    end)
   -- local staticTitles = configWidgets[1]
    local restZoneWidget = configWidgets[2]
    local barsWidget = configWidgets[3]
    restZoneWidget.checkBox:SetScript(onClick,function (self)
      Config:SetGlobalHideRest(self:GetChecked())
    end)   
    barsWidget.minusButton:SetScript(onClick, function () 
      if ActionBars:GetCurrentSpecActionBarsCount() >1 then
        local removeBarConfirm = "SMARTBARS_REMOVEBARCONFIRM"
        StaticPopup_Show (removeBarConfirm)  
      end      
    end) 
    barsWidget.plusButton:SetScript(onClick, function ()   
      ActionBars:Add()   
    end)
  end
  local function CreateActions(actions)
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
    Actions:Add(actions[k])
    UI:Update()
    end)  
   
  end  
  end 
  local function Setup() 
  --Count of tracked actions for specific spec
  local trackedActions = Actions:GetCurrent()
  local trackedActionForSpecCount =0
  local configWidgets = primaryFrame.configWidgets
  for actionID in pairs(trackedActions) do 
    local actionSpec = trackedActions[actionID][5] 
    local currentSpec = API:GetSpecialization()
    if Config:IsValueSame(actionSpec,currentSpec) then
      trackedActionForSpecCount = trackedActionForSpecCount +1
    end
  end
  configWidgets[1].trackedValue:SetText(trackedActionForSpecCount)
  local usedSpellsCount = Config:GetTableCount(API:GetUserActions())
  configWidgets[1].usedValue:SetText(usedSpellsCount)
  configWidgets[2].checkBox:SetChecked(Config:GetGlobalHideRest())
  local actionsHeight = usedSpellsCount/6*60+165
  local primaryFrameHeight
  if usedSpellsCount<=18 then 
    primaryFrameHeight = 350
    else 
    primaryFrameHeight = actionsHeight  
  end
  primaryFrame:SetHeight(primaryFrameHeight)
  local barCount = ActionBars:GetCurrentSpecActionBarsCount()                                          
  configWidgets[3].textValue:SetText(barCount)

  end
primaryFrame = Templates:PrimaryFrame()
  Setup()
  Scripts()
  CreateActions(API:GetUserActions(),primaryFrame)   
  isVisible = true 
local function Drag()
  local onDragStart="OnDragStart"
local onDragStop ="OnDragStop"
local highFrameStrata ="HIGH"
local tooltipFrameStrata = "TOOLTIP"
  primaryFrame:SetScript(onDragStart,function ()
  primaryFrame:SetFrameStrata(tooltipFrameStrata)     
  primaryFrame:StartMoving()
  end)
  primaryFrame:SetScript(onDragStop,function ()
    primaryFrame:SetFrameStrata(highFrameStrata) 
    primaryFrame:StopMovingOrSizing()
  end)
end
Drag()
end
function UI:Delete()
  if primaryFrame then
    primaryFrame:Hide()
    primaryFrame = nil
    isVisible = false 
  end
end
--UI:Update-------------------------------
function UI:Update()
local configWidgets = primaryFrame.configWidgets
configWidgets[1].trackedValue:SetText(Config:GetTableCount(Actions:GetCurrent()))
configWidgets[3].textValue:SetText(ActionBars:GetCurrentSpecActionBarsCount())
end
--Getters & Setters-----------------------------
function UI:GetIsVisible()
return isVisible
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

-- Revision version v1.0.2 ---


