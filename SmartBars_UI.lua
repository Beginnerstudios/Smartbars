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
--UI:Frames-------------------------------
function UI:Create()
  local function Scripts()
    local onClick ="OnClick"
    local resetPopup,removeBarPopup = "SMARTBARS_RESETCONFIRM","SMARTBARS_REMOVEBARCONFIRM"
    local configWidgets = primaryFrame.configWidgets
    primaryFrame.CloseButton:SetScript(onClick, function ()
      UI:Delete()
      Config:Toggle()
    end) 
    primaryFrame.resetButton:SetScript(onClick, function ()
      StaticPopup_Show (resetPopup)  
    end)
   -- local staticTitles = configWidgets[1]
    local restZoneWidget = configWidgets[2]
    local barsWidget = configWidgets[3]
    restZoneWidget.checkBox:SetScript(onClick,function (self)
      Config:SetGlobalHideRest(self:GetChecked())
    end)   
    restZoneWidget.loadingCheckBox:SetScript(onClick,function (self)
      Config:SetWelcomeMessage(self:GetChecked())
    end)  
    barsWidget.minusButton:SetScript(onClick, function () 
      if ActionBars:GetCurrentSpecActionBarsCount() >1 then
        StaticPopup_Show (removeBarPopup)  
      end      
    end) 
    barsWidget.plusButton:SetScript(onClick, function ()   
      ActionBars:Add()   
    end)
  end
  local function CreateActions(actions)
    local onClick ="OnClick"
    local xOffstet = 0
    local yOffset = -20
    local count = 0 
    local displayedIDs = {}
    local trackedIDs = {}
    local count2 =0
    for k in pairs(actions) do
      local function CreateWidget()
        local widget = actions[k][3]
        local actionType =actions[k][6]
        local actionID = actions[k][2]
        local actionName = API:GetDisplayedActionInfo(actionID,actionType)
        widget=Templates:ActionWidget(actions[k],primaryFrame,false)
        widget:SetPoint("LEFT",primaryFrame.TitleBg,"LEFT",xOffstet+10,yOffset-100)
        widget:SetScript(onClick,function (self) 
          Actions:Add(actions[k])
          UI:Update()
        end) 
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
        for q,v in pairs(Actions:GetTracked()) do
          local actionID = actions[k][2]
          local trackedActionID = v[2]
          local trackedActionSpec = v[5]
          local currentSpec = API:GetSpecialization()
          if Config:IsValueSame(actionID,trackedActionID) and Config:IsValueSame(trackedActionSpec,currentSpec) then
            widget:SetChecked(true)
          elseif Config:IsValueSame(trackedActionSpec,currentSpec)then
            trackedIDs[trackedActionID] = actionID
          end 
         
        end  
        displayedIDs[actionID] = actions[k]
    
               
          
        
      
      end    
     CreateWidget()
    end 
    for k,v in pairs(trackedIDs) do          
      if trackedIDs[k]==displayedIDs[k]then
      elseif not displayedIDs[k] then        
        local function CreateWidget()
          local cA = Actions:GetCurrent()
          local tA = Actions:GetTracked()
          local ID = Config:JoinNumber(k,API:GetSpecialization()) 
          local actionType =tA[ID][9]
          local actionID = k
          local actionName = select(1,API:GetFoundActionInfo(actionID)[1])
          local newAction = {}      
          newAction[6] = tA[ID][9]   
          newAction[2] = tA[ID][2]     
          local widget=Templates:ActionWidget(newAction,primaryFrame,false)
          widget:SetPoint("LEFT",primaryFrame.TitleBg,"LEFT",xOffstet+10,yOffset-100)
          widget:SetChecked(true)
          widget:SetScript(onClick,function (self) 
         local actionID = Config:JoinNumber(actionID,API:GetSpecialization())         
         tA[actionID] = nil
         cA[actionID][3]:Hide()
         cA[actionID] = nil
          widget:Hide()
          end)
          if actionType =="item" then
              widget.tooltipText = actionType.." - "..actionName
          else
              widget.tooltipText = actionName
          end

          xOffstet = xOffstet+50
          count = count +1
          if(count==6) then
              yOffset = yOffset -55
              xOffstet = 0
              count=0
          end
        end 
        CreateWidget()
      end
    end
    displayedIDs = nil
    trackedIDs = nil
    primaryFrame:SetHeight((yOffset)*-1+155)

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
  configWidgets[2].loadingCheckBox:SetChecked(Config:GetWelcomeMessage())
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
  --primaryFrame:StartSizing()
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
  if primaryFrame then
    local configWidgets = primaryFrame.configWidgets
    configWidgets[1].trackedValue:SetText(Config:GetTableCount(Actions:GetCurrent()))
    configWidgets[3].textValue:SetText(ActionBars:GetCurrentSpecActionBarsCount())
  end
end
function UI:RefreshIcons()
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
--Getters & Setters-----------------------
function UI:GetIsVisible()
return isVisible
end
-- Revision version v1.1.1 ---


