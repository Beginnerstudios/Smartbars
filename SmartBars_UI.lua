--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.UI ={};
local UI=SmartBars.UI;
local Actions
local Config
local Templates
--Init------------------------------------
function UI:Init()
Actions = SmartBars.Actions
Config = SmartBars.Config
Templates = SmartBars.Templates
end
--Variables-------------------------------
--Primaryframe
local primaryFrame   
local primaryOptionsWidgets = {}
local updater
--ActionBars
local frames = {};
local optionWidgets = {}
--Saved variables
local globalHideRest = false
local actionBarsCount = 1
local framesPosition = {}
local framesScale = {}
local framesAlpha = {}
local framesColumn ={}
local framesHideRest = {}
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
    UI:UpdateUI()
    end)
     
      barsWidget.minusButton :SetScript("OnClick", function ()
      UI:RemoveActionBar()
      UI:UpdateUI()
      barsWidget.textValue:SetText(actionBarsCount);
      end) 
  
      barsWidget.plusButton:SetScript("OnClick", function ()         
        UI:AddActionBar()                                     
        barsWidget.textValue:SetText(actionBarsCount)
        UI:ToggleWidgets(true)           
        UI:UpdateUI()
        end)
  --Option widgets
  
  
  
   --Updater
   updater:SetScript("OnUpdate", function ()
    local tA = Actions:GetTracked()
    UI:UpdateBars(tA)  
    local frameIndex = 1
    while frames[frameIndex] do
    UI:SortBars(tA,frameIndex)
    frameIndex = frameIndex +1 
    end
    end) 
  end
 primaryFrame,primaryOptionsWidgets,updater = Templates:PrimaryFrame()
 Scripts()
end
function UI:CreateActionBar(i)--Create action bar + option widgets
  
    frames[i] = Templates:ActionBar(i)   
    optionWidgets[i] = Templates:OptionWidget(i)
    optionWidgets[i]:SetParent(primaryFrame)     

    function SetupSettings(i)--Setup variables for action bar position,scale etc..
      local defaultFrameScale = 0.75
      local defaultFrameAlpha = 1
      function Position()
      if not framesPosition[i]  then
        local rowCount =10
        local xOffset = 0   
        local yOffset = 300 - (i*40)
        local point = "CENTER"
        local relativePoint = "CENTER"
          if i>rowCount and i<=2*rowCount then
            xOffset=150
            yOffset=300 - ((i-rowCount)*40)  
          elseif i>2*rowCount then
          xOffset=300
          yOffset=300 - ((i-2*(rowCount))*40)  
          end
      frames[i]:SetPoint(point,nil,relativePoint,xOffset,yOffset)
      framesPosition[i] = {xOffset,yOffset,point,relativePoint}  
      else
       local xOffset = framesPosition[i][1] 
       local yOffset = framesPosition[i][2]
       local point = framesPosition[i][3]
       local relativePoint = framesPosition[i][4]
       frames[i]:SetPoint(point,nil,relativePoint,xOffset,yOffset)
      end
      end
      function Scale()
        if not framesScale[i]  then      
          frames[i]:SetScale(defaultFrameScale)
          optionWidgets[i].settings[2].slider:SetValue(defaultFrameScale)
          optionWidgets[i].settings[2].text:SetText(Config:RoundNumber(defaultFrameScale,2))
        else
          local scale = framesScale[i] 
          frames[i]:SetScale(scale)
          optionWidgets[i].settings[2].slider:SetValue(scale)
          optionWidgets[i].settings[2].text:SetText(Config:RoundNumber(scale,2))
        end 
      end
      function Alpha()
        if not framesAlpha[i]  then
          frames[i]:SetAlpha(defaultFrameAlpha)
          optionWidgets[i].settings[3].slider:SetValue(defaultFrameAlpha)
          optionWidgets[i].settings[3].text:SetText(Config:RoundNumber(defaultFrameAlpha,2))
        else
          local alpha = framesAlpha[i]
          frames[i]:SetAlpha(alpha)
          optionWidgets[i].settings[3].slider:SetValue(alpha)
          optionWidgets[i].settings[3].text:SetText(Config:RoundNumber(alpha,2))
        end 
      end
      function Columns()
        if not framesColumn[i]  then
          framesColumn[i] = 10
          optionWidgets[i].settings[4].text2:SetText(framesColumn[i])
        else
          optionWidgets[i].settings[4].text2:SetText(framesColumn[i])
        end
      end
      function Hide()
        if not framesHideRest[i]  then    
          optionWidgets[i].settings[5].checkBox:SetChecked(false)
         else
           local value = framesHideRest[i]
           optionWidgets[i].settings[5].checkBox:SetChecked(value)
         end
      end
      function Scripts()
        optionWidgets[i].CloseButton:SetScript("OnClick", function ()
        Config:ToggleConfigMode()
        end) 
       --Edit button
        frames[i].configWidgets[2]:SetScript("OnClick",function ()
          UI:HideOptionPanels()
           if optionWidgets[i]:IsVisible() then
             optionWidgets[i]:Hide()
        else
         optionWidgets[i]:Show()
          end
       end)
       --Bar navigator
        local optionWidgetBarNavigator = optionWidgets[i].settings[1]
        optionWidgetBarNavigator.minusButton:SetScript("OnClick", function () 
          if i>=2 then
            UI:HideOptionPanels()
            optionWidgets[i-1]:Show()
            optionWidgets[i-1].settings[1].text:SetText("Bar: "..i-1);
          elseif i ==1 then
           UI:HideOptionPanels()
           optionWidgets[#optionWidgets]:Show()
           optionWidgets[#optionWidgets].settings[1].text:SetText("Bar: "..#frames);
          end
        end) 
        optionWidgetBarNavigator.plusButton:SetScript("OnClick", function ()
          if i<#frames then
            UI:HideOptionPanels()
            optionWidgets[i+1]:Show()
            optionWidgets[i+1].settings[1].text:SetText("Bar: "..i+1);
          elseif i==#frames then
            UI:HideOptionPanels()
            optionWidgets[1]:Show()
            optionWidgets[1].settings[1].text:SetText("Bar: 1");
          end
        end)
        --Scale
        local optionWidgetScale = optionWidgets[i].settings[2]
        optionWidgetScale.slider:SetScript("OnValueChanged", function (self) 
        frames[i]:SetScale(self:GetValue())  
        framesScale[i] = self:GetValue()      
        optionWidgetScale.text:SetText(Config:RoundNumber(framesScale[i],2));      
        end)   
        --Alpha
        local optionWidgetAlpha = optionWidgets[i].settings[3]
        optionWidgetAlpha.slider:SetScript("OnValueChanged", function (self)  
        frames[i]:SetAlpha(self:GetValue()) 
        framesAlpha[i] = self:GetValue() 
        optionWidgetAlpha.text:SetText(Config:RoundNumber(framesAlpha[i],2));    
          end)
        --Rest zone widget
        local optionWidgetRestZone = optionWidgets[i].settings[5]
        --optionWidgetRestZone.checkBox:SetChecked(framesHideRest[i])
        optionWidgetRestZone.checkBox:SetScript("OnClick",function (self)
        framesHideRest[i] = self:GetChecked()
        UI:UpdateUI()
        end)  
        --Columns widget
        local optionWidgetColumns = optionWidgets[i].settings[4] 
        optionWidgetColumns.minusButton:SetScript("OnClick", function ()
        if framesColumn[i]>= 2 then
        framesColumn[i] = framesColumn[i] -1
        optionWidgetColumns.text2:SetText(framesColumn[i])
        end
        end) 
        optionWidgetColumns.plusButton:SetScript("OnClick", function ()  
        framesColumn[i] = framesColumn[i] +1
        optionWidgetColumns.text2:SetText(framesColumn[i])  
        end)
      end
      Position()
      Scale()
      Alpha()
      Columns()
      Hide()
      Scripts()
    end

    SetupSettings(i) 
end
function UI:RemoveActionBar()
  if frames then 
    if #frames >1 then
      local lastIndex = #frames
      frames[#frames]:Hide()  
      UI:HideOptionPanels()
      optionWidgets[#frames-1]:Show()
      framesScale[#frames] = nill 
      framesPosition[#frames] = nill 
      framesAlpha[#frames] = nill 
      frames[#frames] = nill
     
      local tA = Actions:GetTracked()
      for k,v in pairs(tA) do
        local barNumber = tA[k][6]
        if barNumber>1 and barNumber==lastIndex then         
        Actions:Move(tA[k],-1)
        end  
      end
      actionBarsCount = actionBarsCount-1
    end
  end  
end
function UI:AddActionBar()
  if #frames < 30 then
  UI:CreateActionBar(#frames+1)
  UI:ToggleWidgets(true)
  actionBarsCount = actionBarsCount +1
  end
end
--UI:Widgets-------------------------------
function UI:ToggleWidgets(value)--Toggle edit boxes for edit in tracked actions
   --ActionWidgets
  for k,v in pairs(Actions:GetTracked()) do
    local widget = v[3]
   if widget~=nill then
    if value == true then
    widget.edit:SetEnabled(value) 
    widget.group:Show()
    widget.charges:Hide()  
   else
    widget.group:Hide()
    widget.charges:Show()

   end
  end
  
  end
  --Actionbars
  for i=1,#frames do
    frames[i]:SetMovable(value) 
    frames[i]:EnableMouse(value)  

    local configWidgets = frames[i].configWidgets
    if value == true then
      for widget in pairs(configWidgets) do
        configWidgets[widget]:Show()
      end          
    else
      for widget in pairs(frames[i].configWidgets) do
        configWidgets[widget]:Hide()
      end 
    end
  end

  UI:HideOptionPanels()
  optionWidgets[#optionWidgets]:Show()
end
function UI:HideOptionPanels()
  for i in pairs(optionWidgets) do
    optionWidgets[i]:Hide()
  end
end
--UI:Update-------------------------------
function UI:UpdateUI() ---update all dynamic variables in UI 
  function SetupPrimaryFrame() --handle height of primary frame and primary options widgets + update values for used/tracked actions
    --Count of tracked actions for specific spec
    local trackedActions = Actions:GetTracked()
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
    local usedSpellsCount = Config:GetTableCount(API:GetUserActions());
    primaryOptionsWidgets[1].usedValue:SetText(usedSpellsCount)
    local actionsHeight = usedSpellsCount/6*60+165
    local primaryFrameHeight
    if usedSpellsCount<=18 then 
      primaryFrameHeight = 350
      else 
      primaryFrameHeight = actionsHeight  
    end
    primaryFrame:SetHeight(primaryFrameHeight)
  
  end
  function RefreshTrackedIcons()--update icons on tracked actions
  local tA = Actions:GetTracked()
  for actionID in pairs(tA) do
    local widget =tA[actionID][3]
    local spellID = tA[actionID][2]
    local actionType = tA[actionID][9]
    local slotID = tA[actionID][1]
    if widget~=nill then
      local newTexture= API:GetActionTexture(spellID,actionType,slotID)
      widget:SetNormalTexture(newTexture)   
    end
  end
  end
    SetupPrimaryFrame()
    RefreshTrackedIcons()
    Config:SaveConfig()
end
function UI:UpdateBars(barsToupdate) --determinate if widget will be wisible or hidden
  local actions = barsToupdate
  local configMode = Config:IsConfigMode()
  local userSpec = Config:GetSpec()
  local isResting = Config:GetResting()
  
if actions ~=nill then
  for actionID in pairs(actions) do  
    local slotID = actions[actionID][1]
    local spellID = actions[actionID][2]
    local widget = actions[actionID][3]
    local actionSpec = actions[actionID][5]
    local frameIndex = actions[actionID][6] 
    local isBoosted = actions[actionID][7]   
    local displayOnlyWhenBoosted =actions[actionID][8]
    local actionType = actions[actionID][9]  
     
    if Config:IsValueSame(actionSpec,userSpec) then   
      if globalHideRest == true and isResting ==true and configMode == false then
       widget:Hide()
      else
        local chargesText = API:GetActionCharges(spellID,actionType) 
        local isUsable,notEnoughMana = API:IsUsableAction(spellID,actionType)  
        local start, duration, onCooldown = API:GetActionCooldown(spellID,actionType,slotID)  
        local inRange = API:IsActionInRange(spellID,actionType)       
        widget.charges:SetText(chargesText)          
        if configMode or isBoosted and isUsable==true and notEnoughMana==false and duration <1.5 and inRange==true then      
          widget:Show()                         
        else             
          if isResting and framesHideRest[frameIndex]==true or displayOnlyWhenBoosted or globalHideRest == true and isResting  then  
            widget:Hide()  
          else                                                                   
            if notEnoughMana or isUsable==false or duration>1.5 or inRange==false then
              widget:Hide()                                           
            else           
              local isUserBuffedBy= API:GetPlayerAuraBySpellID(spellID)
              if isUserBuffedBy then
                widget:Hide()                     
              else
                widget:Show() 
              end                                                            
            end         
          end   
        end 
      end    
      else
        widget:Hide()
    end
  end
  end   
end
function UI:SortBars(trackedActions,sortNumber)--handle displayed widget position
  local startxOffset = 0
  local startyOffset =-37
  
  for actionID in pairs(trackedActions) do
    local frameNumber = trackedActions[actionID][6]
    local widget = trackedActions[actionID][3]
    if frameNumber == sortNumber then
      if widget:IsVisible() then
        widget:SetPoint("LEFT",frames[frameNumber],"LEFT",startxOffset,startyOffset)
        startxOffset = startxOffset +50
      if(startxOffset== framesColumn[sortNumber]*50) then
      startxOffset =0
      startyOffset  = startyOffset-50
          end
      end
    end
  end
end
--Getters & Setters-----------------------------
function UI:Get()   --get values from SmartBars_UI                      
  local returnTable =
         {                         
             ActionBar = function(self,barIndex)             
                return frames[barIndex]                             
             end,        
             CurrentSpec = function(self)                                                                                    
                return  currentSpecialization
             end,
             ActionBarCount = function(self)                                                                                    
              return actionBarsCount
             end,           
             GlobalHideRest = function(self)                                                                                    
              return  globalHideRest
             end,
             FramesScale = function(self)                                                                                                  
             return framesScale
             end,
             FramesPosition = function(self) 
              for i=1,#frames do
                function CalculateFramePosition(frameIndex)
                  local point, relativeTo, relativePoint, xOfs, yOfs = frames[frameIndex]:GetPoint(1)
                  local function round2(num, numDecimalPlaces)
                    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
                  end
                  return {round2(xOfs,2),round2(yOfs,2),point,relativePoint}
                  
                end
                framesPosition[i]=CalculateFramePosition(i)              
              end
                return framesPosition         
             end,
             FramesAlpha = function(self)                                                                                    
             return framesAlpha
              end,
              FramesColumn = function(self)                                                                                    
              return  framesColumn
              end,
              FramesHideRest = function(self)                                                                                    
              return  framesHideRest
              end,
             PrimaryFrame = function(self)                                                                                    
             return  primaryFrame
             end            
         }
 return returnTable
end
function UI:SetSavedVariables(loadedFramesPosition,loadedFramesScale,loadedFramesAlpha,loadedFramesColumn,loadedFramesHideRest,loadedActionBarsCount,loadedGlobalHideRest)--set saved variables
 framesPosition = loadedFramesPosition
 framesScale =loadedFramesScale
 framesAlpha = loadedFramesAlpha
 framesColumn = loadedFramesColumn
 framesHideRest = loadedFramesHideRest
 actionBarsCount = loadedActionBarsCount
 globalHideRest = loadedGlobalHideRest
end
-- Revision version v0.9.8 ---


