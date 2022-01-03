--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.ActionBars ={};
local ActionBars=SmartBars.ActionBars;
local UI
local Config
local Templates
local Actions
--Init------------------------------------
function ActionBars:Init()
UI = SmartBars.UI
Config =SmartBars.Config
Templates = SmartBars.Templates
Actions = SmartBars.Actions
end
--Variables--------------------------------
--ActionBars
local updater
local frames = {};
local frameIDs
local optionWidgets = {}
--Saved variables
local actionBarsSpecCount ={}
local framesPosition = {}
local framesScale = {}
local framesAlpha = {}
local framesColumn ={}
local framesHideRest = {}

function ActionBars:Add()  
  local spec = API:GetSpecialization()
  if actionBarsSpecCount[spec] < 9 then
  actionBarsSpecCount[spec] = actionBarsSpecCount[spec]+1
  local frameID = Config:JoinNumber(spec,actionBarsSpecCount[spec])
  frameIDs[frameID] = {frameID,actionBarsSpecCount[spec],spec}
  ActionBars:Create(frameID) 
  ActionBars:ToggleWidgets(true)   
  ActionBars:HideOptionPanels()     
  ActionBars:ShowLastOptionWidget()
  UI:UpdateUI() 
end
end 
function ActionBars:Create(i)--Create action bar + option widgets 
local primaryFrame = UI:Get():PrimaryFrame()

  frames[i] = Templates:ActionBar(i)
  frames[i]:SetParent(updater) 
  frames[i].optionWidgets = Templates:OptionWidget(i)  
  frames[i].optionWidgets:SetParent(primaryFrame) 
  function SetupSettings(i)--Setup variables for action bar position,scale etc..
    local defaultFrameScale = 0.75
    local defaultFrameAlpha = 1
    local scaleWidget = frames[i].optionWidgets.settings[2]
    local alphaWidget = frames[i].optionWidgets.settings[3]
    local columnsWidget = frames[i].optionWidgets.settings[4]
    local hideWidget = frames[i].optionWidgets.settings[5]
    local optionWidget = frames[i].optionWidgets
    local barWidget = frames[i].optionWidgets.settings[1]
  

    function Position()
    if not framesPosition[i]  then
      local i = ActionBars:FindIndex(i)
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
    i = ActionBars:FindFrameID(i)
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
        scaleWidget.slider:SetValue(defaultFrameScale)
        scaleWidget.text:SetText(Config:RoundNumber(defaultFrameScale,2))       
      else
        local scale = framesScale[i] 
        frames[i]:SetScale(scale)
        scaleWidget.slider:SetValue(scale)
        scaleWidget.text:SetText(Config:RoundNumber(scale,2))
      end       
    end
    function Alpha()
      if not framesAlpha[i]  then
        frames[i]:SetAlpha(defaultFrameAlpha)
        alphaWidget.slider:SetValue(defaultFrameAlpha)
        alphaWidget.text:SetText(Config:RoundNumber(defaultFrameAlpha,2))
      else
        local alpha = framesAlpha[i]
        frames[i]:SetAlpha(alpha)
        alphaWidget.slider:SetValue(alpha)
        alphaWidget.text:SetText(Config:RoundNumber(alpha,2))
      end 
    end
    function Columns()
      if not framesColumn[i]  then
        framesColumn[i] = 10
        columnsWidget.text2:SetText(framesColumn[i])
      else
        columnsWidget.text2:SetText(framesColumn[i])
      end
    end
    function Hide()
      if not framesHideRest[i]  then    
        hideWidget.checkBox:SetChecked(false)
       else
         local value = framesHideRest[i]
         hideWidget.checkBox:SetChecked(value)
       end
    end
    function Scripts()
      optionWidget.CloseButton:SetScript("OnClick", function ()
      Config:ToggleConfigMode()
      end) 
     --Edit button
      frames[i].configWidgets[2]:SetScript("OnClick",function ()
        ActionBars:HideOptionPanels()
         if optionWidget:IsVisible() then
          optionWidget:Hide()
      else
        optionWidget:Show()
        end
     end)
     --Bar navigator
     barWidget.minusButton:SetScript("OnClick", function ()
      ActionBars:HideOptionPanels() 
      if ActionBars:FindIndex(i)>=2 then
        frames[i-1].optionWidgets:Show()
        frames[i-1].optionWidgets.settings[1].text:SetText("Bar: "..ActionBars:FindIndex(i-1));
      elseif ActionBars:FindIndex(i) ==1 then                  
        ActionBars:ShowLastOptionWidget()
        end
      end) 
      barWidget.plusButton:SetScript("OnClick", function ()
        ActionBars:HideOptionPanels()
        if frameIDs[i+1] then
        frames[i+1].optionWidgets:Show()
        frames[i+1].optionWidgets.settings[1].text:SetText("Bar: "..ActionBars:FindIndex(i+1));
        else
        local frameID = ActionBars:FindFrameID(1)
        frames[frameID].optionWidgets:Show()
        end
      end)
      --Scale

      scaleWidget.slider:SetScript("OnValueChanged", function (self) 
      frames[i]:SetScale(self:GetValue())  
      framesScale[i] = self:GetValue()      
      scaleWidget.text:SetText(Config:RoundNumber(framesScale[i],2));      
      end)   
      --Alpha
    
      alphaWidget.slider:SetScript("OnValueChanged", function (self)  
      frames[i]:SetAlpha(self:GetValue()) 
      framesAlpha[i] = self:GetValue() 
      alphaWidget.text:SetText(Config:RoundNumber(framesAlpha[i],2));    
        end)
      --Rest zone widget
   
      hideWidget.checkBox:SetScript("OnClick",function (self)
      framesHideRest[i] = self:GetChecked()
      UI:UpdateUI()
      end)  
      --Columns widget
  
      columnsWidget.minusButton:SetScript("OnClick", function ()
      if framesColumn[i]>= 2 then
      framesColumn[i] = framesColumn[i] -1
      columnsWidget.text2:SetText(framesColumn[i])
      end
      end) 
      columnsWidget.plusButton:SetScript("OnClick", function ()  
      framesColumn[i] = framesColumn[i] +1
      columnsWidget.text2:SetText(framesColumn[i])  
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
function ActionBars:Load()
  local currentSpecActionsCount = ActionBars:Get():ActionsSpecBarCount(API:GetSpecialization())
  if currentSpecActionsCount then  
      for frameID,v in pairs(frameIDs) do   
        if v[3] == API:GetSpecialization() then                  
        ActionBars:Create(frameID)      
        end
      end   
  else
  local spec = API:GetSpecialization()
  actionBarsSpecCount[spec] = 1
  local frameID = Config:JoinNumber(spec,actionBarsSpecCount[spec])
  frameIDs[frameID] = {frameID,actionBarsSpecCount[spec],spec}
  ActionBars:Create(frameID)
  end
end 
function ActionBars:Remove()
local spec = API:GetSpecialization()
if  actionBarsSpecCount[spec] > 1 then

  local lastFrameIndex,lastFrameID = ActionBars:Get():HighestFrameID()  
  frames[lastFrameID]:Hide()
  frames[lastFrameID].optionWidgets:Hide()
  frames[lastFrameID] = nill
  frameIDs[lastFrameID] = nill
  framesScale[lastFrameID] = nill 
  framesPosition[lastFrameID] = nill 
  framesAlpha[lastFrameID] = nill 
  framesHideRest[lastFrameID] =nill
  framesColumn[lastFrameID] = nill
  
  local tA = Actions:GetTracked()
      for k,v in pairs(tA) do
        local barNumber = tA[k][6]        
        if barNumber==lastFrameID then    
          tA[k][6] = tA[k][6]-1
        end 
      end 
      actionBarsSpecCount[spec] =actionBarsSpecCount[spec]-1
end
ActionBars:ShowLastOptionWidget()
UI:UpdateUI()
end
function ActionBars:HideOptionPanels()
  for i in pairs(frames) do
    frames[i].optionWidgets:Hide()
  end

end
function ActionBars:ShowLastOptionWidget()
  ActionBars:HideOptionPanels()
  local a,lastFrameID = ActionBars:Get():HighestFrameID()
  if frames[lastFrameID].optionWidgets then
      frames[lastFrameID].optionWidgets:Show()
      frames[lastFrameID].optionWidgets.settings[1].text:SetText("Bar: "..ActionBars:FindIndex(lastFrameID));
  end

end
function ActionBars:ToggleWidgets(value)--Toggle edit boxes for edit in tracked actions

 --Actionbars
for k,v in pairs(frames) do
 frames[k]:SetMovable(value) 
 frames[k]:EnableMouse(value)  
 local configWidgets = frames[k].configWidgets
 if value == true then
   for widget in pairs(configWidgets) do
     configWidgets[widget]:Show()
   end          
 else
   for widget in pairs(frames[k].configWidgets) do
     configWidgets[widget]:Hide()
   end 
 end

end
  --ActionWidgets
  for k,v in pairs(Actions:GetTracked()) do
    local widget = v[3]
   if widget~=nill then
    if value == true then
    widget.edit:SetEnabled(true) 
    widget.group:Show()
    widget.charges:Hide()  
   else
    widget.group:Hide()
    widget.charges:Show()
    widget.edit:SetEnabled(value) 
 
   end
  end
  
  end
ActionBars:ShowLastOptionWidget()

end
--Find-------------------------
function ActionBars:FindIndex(frameID) --return frame index based on frameID
  local frameIndex
  for k,v in pairs(frameIDs) do
    if k==frameID then
      return v[2]      
    end
  end
end
function ActionBars:FindFrameID(frameIndex) --return frame index based on frameID
  for k,v in pairs(frameIDs) do
    if v[2]==frameIndex and v[3] == API:GetSpecialization() then
      return k      
    end
  end
end
--Update-----------------
function ActionBars:StartUpdate()
  updater = CreateFrame("Frame",nil,nil);
  updater:SetScript("OnUpdate", function ()
    ActionBars:UpdateBars()   
    for frameID,v in pairs(frameIDs) do    
    if frames[frameID]~=nill then                 
    ActionBars:SortBars(frameID)  
    end  
    end
    end) 
end
function ActionBars:UpdateBars() --determinate if widget will be wisible or hidden
  local actions = Actions:GetTracked()
  local configMode = Config:IsConfigMode()
  local userSpec = Config:GetSpec()
  local isResting = Config:GetResting()
  local globalHideRest = UI:Get():GlobalHideRest()
 
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
function ActionBars:SortBars(frameID)--handle displayed widget position
  local trackedActions = Actions:GetTracked()
  local startxOffset = 0
  local startyOffset =-37
  for actionID in pairs(trackedActions) do
    local actionFrameNumber = trackedActions[actionID][6]
    local widget = trackedActions[actionID][3]
      if actionFrameNumber == frameID and widget:IsVisible() then         
        widget:SetPoint("LEFT",frames[frameID],"LEFT",startxOffset,startyOffset)
        widget:SetParent(frames[frameID])
        startxOffset = startxOffset +50
        if(startxOffset== framesColumn[frameID]*50) then
        startxOffset =0
        startyOffset  = startyOffset-50
        end  
      elseif actionFrameNumber == frameID then  
        widget:SetPoint("LEFT",frames[frameID],"LEFT",startxOffset,startyOffset)
        widget:SetParent(frames[frameID])       
         
    end
  end
end
function ActionBars:HideDifSpecBars()
for frameID,v in pairs(frameIDs) do
  if v[3] ~= API:GetSpecialization() then
    if frames[frameID] then
    frames[frameID]:Hide()
    end
  end
end  
end
--Getter & Setter -- 
function ActionBars:Set(loadedFramesPosition,loadedFramesScale,loadedFramesAlpha,loadedFramesColumn,loadedFramesHideRest,loadedActionBarsSpecCount,loadedFrameIDs)--set saved variables
  framesPosition = loadedFramesPosition
  framesScale =loadedFramesScale
  framesAlpha = loadedFramesAlpha
  framesColumn = loadedFramesColumn
  framesHideRest = loadedFramesHideRest
  actionBarsSpecCount = loadedActionBarsSpecCount
  frameIDs = loadedFrameIDs
end
function ActionBars:Get()   --get values from SmartBars_UI                      
  local returnTable =
         {                         
             ActionBar = function(self,barIndex)             
                return frames[barIndex]                             
             end,  
             ActionBars = function(self,barIndex)             
              return frames                             
             end,              
             ActionsSpecBarCount = function(self,index)                                                                                    
            return actionBarsSpecCount[index]
             end,
             ActionsSpecBarCounts = function(self,index)                                                                                    
              return actionBarsSpecCount
               end,
             FramesScale = function(self)                                                                                                  
             return framesScale
             end,
            FrameIDs = function(self)                                                                                                  
            return frameIDs
            end,
            HighestFrameID = function(self)  
              local highestID=0 
              local frameID
              for k,v in pairs(frameIDs) do
                if k~=nil then
                  if v[2]>highestID and v[3]==API:GetSpecialization() then
                    highestID = v[2]
                    frameID = v[1]                
                end   
                end  
            end 
            --(highestID.."|"..frameID)                                                                                           
              return highestID,frameID
            end,
            FramesPosition = function(self) 
              for k,v in pairs(frames) do
                local frameIndex = k
                if k then
                  function CalculateFramePosition(frameIndex)
                    local point, relativeTo, relativePoint, xOfs, yOfs = frames[frameIndex]:GetPoint(1)
                    local function round2(num, numDecimalPlaces)
                      return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
                    end
                    return {round2(xOfs,2),round2(yOfs,2),point,relativePoint}
                    
                  end 
                end
                
                framesPosition[k]=CalculateFramePosition(k)              
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
         }
 return returnTable
end
--Revision v 0.9.8 --
