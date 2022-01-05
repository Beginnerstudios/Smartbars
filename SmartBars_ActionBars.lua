--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.ActionBars ={}
local ActionBars=SmartBars.ActionBars
local UI
local Config
local Templates
local Actions
local Localization
--Init------------------------------------
function ActionBars:Init()
UI = SmartBars.UI
Config =SmartBars.Config
Templates = SmartBars.Templates
Actions = SmartBars.Actions
Localization = SmartBars.Localization
end
--Variables--------------------------------
--ActionBars
local updater
local frames = {}
local optionWidgets = {}
--Saved variables
local actionBarsSpecCount ={}
local framesPosition = {}
local framesScale = {}
local framesAlpha = {}
local framesColumn ={}
local framesHideRest = {}
local framesRows = {}
local frameIDs = {}
--DevEvents
local onClick = "OnClick"
local onValueChanged = "OnValueChanged"
local onUpdate = "OnUpdate"

--ActionBars----------------------
function ActionBars:Add()-- add new action bar to current specialization
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
function ActionBars:Create(i)--create action bar with for specific frameID and setup its default values
local primaryFrame = UI:Get():PrimaryFrame()

  frames[i] = Templates:ActionBar(i)
  frames[i]:SetParent(updater) 

  function SetupSettings(i)--Setup variables for action bar position,scale etc..
    local defaultFrameScale = 0.75
    local defaultFrameAlpha = 1
    local scaleWidget = frames[i].configWidgets[2].settings[2]
    local alphaWidget = frames[i].configWidgets[2].settings[3]
    local columnsWidget = frames[i].configWidgets[2].settings[4]
    local hideWidget = frames[i].configWidgets[2].settings[5]
    local optionWidget = frames[i].configWidgets[2]
    local barWidget = frames[i].configWidgets[2].settings[1]
  

    function Position()
    if not framesPosition[i]  then
      local i = ActionBars:FindIndex(i)
      local rowCount =10
      local xOffset = 0   
      local yOffset = 300 - (i*70)
      local point = "CENTER"
      local relativePoint = "CENTER"
        if i>rowCount and i<=2*rowCount then
          xOffset=150
          yOffset=300 - ((i-rowCount)*70)  
        elseif i>2*rowCount then
        xOffset=300
        yOffset=300 - ((i-2*(rowCount))*70)  
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
        frames[i].configWidgets[3]:SetScale(defaultFrameScale)
        scaleWidget.slider:SetValue(defaultFrameScale)
        scaleWidget.text:SetText(Config:RoundNumber(defaultFrameScale,2))       
      else
        local scale = framesScale[i] 
        frames[i].configWidgets[3]:SetScale(scale)
        scaleWidget.slider:SetValue(scale)
        scaleWidget.text:SetText(Config:RoundNumber(scale,2))
      end       
    end
    function Alpha()
      if not framesAlpha[i]  then
        frames[i].configWidgets[3]:SetAlpha(defaultFrameAlpha)
        alphaWidget.slider:SetValue(defaultFrameAlpha)
        alphaWidget.text:SetText(Config:RoundNumber(defaultFrameAlpha,2))
      else
        local alpha = framesAlpha[i]
        frames[i].configWidgets[3]:SetAlpha(alpha)
        alphaWidget.slider:SetValue(alpha)
        alphaWidget.text:SetText(Config:RoundNumber(alpha,2))
      end 
    end
    function Columns()
      if not framesColumn[i]  then
        framesColumn[i] = 5
        columnsWidget.text2:SetText(framesColumn[i])
      else
        columnsWidget.text2:SetText(framesColumn[i])
 
      end
    end
    function Rows()
      if not framesRows[i] then
        framesRows[i] = 1
      --  frames[i]:Height((framesRows[i]*50)+25)
      else
      --  frames[i]:Height((framesRows[i]*50)+25)
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
    --  optionWidget.CloseButton:SetScript(onClick, function ()
     -- Config:ToggleConfigMode()
     -- end) 
     --Edit button
      frames[i].configWidgets[1].button:SetScript(onClick,function ()
        ActionBars:HideOptionPanels()
         if optionWidget:IsVisible() then
          optionWidget:Hide()
      else
        optionWidget:Show()
        end
     end)
     --Bar navigator
     barWidget.minusButton:SetScript(onClick, function ()
      ActionBars:HideOptionPanels() 
      if ActionBars:FindIndex(i)>=2 then
        frames[i-1].configWidgets[2]:Show()
        frames[i-1].configWidgets[2].settings[1].text:SetText(Localization:Bar()..ActionBars:FindIndex(i-1))
      elseif ActionBars:FindIndex(i) ==1 then                  
        ActionBars:ShowLastOptionWidget()
        end
      end) 
      barWidget.plusButton:SetScript(onClick, function ()
        ActionBars:HideOptionPanels()
        if frameIDs[i+1] then
        frames[i+1].configWidgets[2]:Show()
        frames[i+1].configWidgets[2].settings[1].text:SetText(Localization:Bar()..ActionBars:FindIndex(i+1))
        else
        local frameID = ActionBars:FindFrameID(1)
        frames[frameID].configWidgets[2]:Show()
        end
      end)
      --Scale

      scaleWidget.slider:SetScript(onValueChanged, function (self) 
      frames[i].configWidgets[3]:SetScale(self:GetValue())  
      framesScale[i] = self:GetValue()      
      scaleWidget.text:SetText(Config:RoundNumber(framesScale[i],2))      
      end)   
      --Alpha
    
      alphaWidget.slider:SetScript(onValueChanged, function (self)  
      frames[i].configWidgets[3]:SetAlpha(self:GetValue()) 
      framesAlpha[i] = self:GetValue() 
      alphaWidget.text:SetText(Config:RoundNumber(framesAlpha[i],2))    
        end)
      --Rest zone widget
   
      hideWidget.checkBox:SetScript(onClick,function (self)
      framesHideRest[i] = self:GetChecked()
      UI:UpdateUI()
      end)  
      --Columns widget
  
      columnsWidget.minusButton:SetScript(onClick, function ()
      if framesColumn[i]>= 2 then
      framesColumn[i] = framesColumn[i] -1
      columnsWidget.text2:SetText(framesColumn[i])
      end
      end) 
      columnsWidget.plusButton:SetScript(onClick, function ()  
      framesColumn[i] = framesColumn[i] +1
      columnsWidget.text2:SetText(framesColumn[i])  
      end)
    end
    Position()
    Scale()
    Alpha()
    Columns()
    Rows()
    Hide()
    Scripts()
  end
  SetupSettings(i) 
end
function ActionBars:Load()--load existing or create first action bar for current spec
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
function ActionBars:Remove()--remove action bar with highestIndex
local spec = API:GetSpecialization()
if  actionBarsSpecCount[spec] > 1 then
  local lastFrameIndex,lastFrameID = ActionBars:Get():HighestFrameID()  
  frames[lastFrameID]:Hide()
  frames[lastFrameID].configWidgets[2]:Hide()
  frames[lastFrameID].configWidgets[1]:Hide()
  frames[lastFrameID].configWidgets[3]:Hide()
  frames[lastFrameID] = nil
  frameIDs[lastFrameID] = nil
  framesScale[lastFrameID] = nil 
  framesPosition[lastFrameID] = nil 
  framesAlpha[lastFrameID] = nil 
  framesHideRest[lastFrameID] =nil
  framesColumn[lastFrameID] = nil
  
  local tA = Actions:Get()
      for k in pairs(tA) do
        local barNumber = tA[k][6]        
        if barNumber==lastFrameID then    
          tA[k][6] = tA[k][6]-1
          print(tA[k][6])
        end 
      end 
      actionBarsSpecCount[spec] =actionBarsSpecCount[spec]-1
end
ActionBars:ShowLastOptionWidget()
UI:UpdateUI()
end
function ActionBars:ToggleWidgets(value)--Toggle config mode widgets
local actionBarFrameTemplate = "InsetFrameTemplate"
 --Actionbars
for k in pairs(frames) do

 frames[k]:SetMovable(value) 
 frames[k]:EnableMouse(value)  
 
 local configWidgets = frames[k].configWidgets

   for widget in pairs(configWidgets) do
    local editButton = configWidgets[1]
    local optionPanel = configWidgets[2]
    local iconHolder = configWidgets[3]

    if value == true then
      editButton:Show() -- edit button
      editButton.button:Show()
      optionPanel:Show() -- option
      iconHolder:Show() --icon holder   
    else
      editButton:Hide() 
      editButton.button:Hide()
      optionPanel:Hide()   
      iconHolder:Show() 
    end

   end          
  
end
  --ActionWidgets
  for _,v in pairs(Actions:Get()) do
    local widget = v[3]
   if widget~=nil then
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
--OptionWidgets--------------------------
function ActionBars:HideOptionPanels()--hide all option Panels
  for i in pairs(frames) do
    frames[i].configWidgets[2]:Hide()
  end
end
function ActionBars:ShowLastOptionWidget() -- display optionWidget with highest index
  ActionBars:HideOptionPanels()
  local a,lastFrameID = ActionBars:Get():HighestFrameID() 
  local optionWidget = frames[lastFrameID].configWidgets[2]
  local barText = frames[lastFrameID].configWidgets[2].settings[1].text
  optionWidget:Show()
  barText:SetText(Localization:Bar()..ActionBars:FindIndex(lastFrameID))

end
--Find-------------------------
function ActionBars:FindIndex(frameID) --return frameIndex based on frameID
  local frameIndex
  for k,v in pairs(frameIDs) do
    if k==frameID then
      return v[2]      
    end
  end
end
function ActionBars:FindFrameID(frameIndex) --return frameID based on frameIndex
  for k,v in pairs(frameIDs) do
    if v[2]==frameIndex and v[3] == API:GetSpecialization() then
      return k      
    end
  end
end
--Update----------------------
function ActionBars:StartUpdate()--create frame what hold Script with OnUpdate event (refreshing actions every frame)
  updater = CreateFrame("Frame",nil,nil)
  updater:SetScript(onUpdate, function ()
    local actions = Actions:Get()
    ActionBars:UpdateBars(actions)   
    for frameID in pairs(frameIDs) do                 
    ActionBars:SortBars(frameID,actions)    
    end
    end) 
end
function ActionBars:UpdateBars(actions) --determinate if widget will be visible or hidden
  local configMode = Config:IsConfigMode()
  local userSpec = Config:GetSpec()
  local isResting = Config:GetResting()
  local globalHideRest = UI:GetGlobalHideRest()
 
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
          if isBoosted then
            ActionButton_ShowOverlayGlow(widget)
          end                      
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
function ActionBars:SortBars(frameID,actions)--handle displayed widget position and parent
  local startxOffset = 0
  local startyOffset = 0
  local count =0
  local rowCount = 0
  local iconHolder = frames[frameID].configWidgets[3]
  for actionID in pairs(actions) do
    local actionFrameNumber = actions[actionID][6]
    local widget = actions[actionID][3]
      if actionFrameNumber == frameID and widget:IsVisible() then         
        widget:SetPoint("LEFT",iconHolder,"LEFT",startxOffset,startyOffset)        
        startxOffset = startxOffset +50
        if(startxOffset== framesColumn[frameID]*50) then
        startxOffset =0
        startyOffset  = startyOffset-50
        end  
      elseif actionFrameNumber == frameID then  
        widget:SetPoint("LEFT",iconHolder,"LEFT",startxOffset,startyOffset)      
      end
  end
end
function ActionBars:HideDifSpecBars()--hide bars what are not in current specialization
for frameID,v in pairs(frameIDs) do
  if v[3] ~= API:GetSpecialization() then
    if frames[frameID] then
    frames[frameID]:Hide()
    end
  end
end  
end
--Getter & Setter ------------ 
function ActionBars:Set(loadedFramesPosition,loadedFramesScale,loadedFramesAlpha,loadedFramesColumn,loadedFramesHideRest,loadedActionBarsSpecCount,loadedFrameIDs,loadedFramesRows)
  framesPosition = loadedFramesPosition
  framesScale =loadedFramesScale
  framesAlpha = loadedFramesAlpha
  framesColumn = loadedFramesColumn
  framesHideRest = loadedFramesHideRest
  actionBarsSpecCount = loadedActionBarsSpecCount
  frameIDs = loadedFrameIDs
  framesRows = loadedFramesRows
end
function ActionBars:Get()                 
  local returnTable =
         {                         
             ActionBar = function(self,barIndex)             
                return frames[barIndex]                             
             end,  
             ActionBars = function(self)             
              return frames                             
             end,              
             ActionsSpecBarCount = function(self,index)                                                                                    
            return actionBarsSpecCount[index]
             end,
             ActionsSpecBarCounts = function(self)                                                                                    
              return actionBarsSpecCount
               end,
             FramesScale = function(self)                                                                                                  
             return framesScale
             end,
            FrameIDs = function(self)                                                                                                  
            return frameIDs
            end,
            FramesRows = function(self)                                                                                                  
              return framesRows
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
              for k in pairs(frames) do
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
--Revision v 0.9.9 --
