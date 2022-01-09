--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.ActionBars ={}
local ActionBars=SmartBars.ActionBars
local Config
local Templates
local Actions
local Localization
local API
local UI
--Init------------------------------------
function ActionBars:Init()
Config =SmartBars.Config
Templates = SmartBars.Templates
Actions = SmartBars.Actions
Localization = SmartBars.Localization
API = SmartBars.API
UI= SmartBars.UI
end
--Variables--------------------------------
--ActionBars
local updater
local frames = {}
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
  local spec = Config:GetSpec()
  if actionBarsSpecCount[spec] < 9 then
  actionBarsSpecCount[spec] = actionBarsSpecCount[spec]+1
  local frameID = Config:JoinNumber(spec,actionBarsSpecCount[spec])
  frameIDs[frameID] = {frameID,actionBarsSpecCount[spec],spec}
  ActionBars:Create(frameID) 
  ActionBars:Toggle(true)      
  Config:Save()
  UI:Update()
end
end 
function ActionBars:Create(i)--create action bar with for specific frameID and setup its default values
  if not frames then
    frames ={}
  end
  frames[i] = Templates:ActionBar(i)
  frames[i]:SetParent(updater) 

  local function SetupActionBars(i)--Setup variables for action bar position,scale etc..
    local defaultFrameScale = 0.75
    local defaultFrameAlpha = 1
    local scaleWidget = frames[i].configWidgets[2].settings[2]
    local alphaWidget = frames[i].configWidgets[2].settings[3]
    local columnsWidget = frames[i].configWidgets[2].settings[4]
    local hideWidget = frames[i].configWidgets[2].settings[5]
--    local optionWidget = frames[i].configWidgets[2]
    local barWidget = frames[i].configWidgets[2].settings[1]
    local function Position()
    if not framesPosition[i]  then
      local i = ActionBars:FindIndex(i)
      local rowCount =5
      local xOffset = -100   
      local yOffset = 280 - (i*70)
      local point = "CENTER"
      local relativePoint = "CENTER"
        if i>rowCount and i<=2*rowCount then
          xOffset=100
          yOffset=280 - ((i-rowCount)*70)          
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
    local function Scale()
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
    local function Alpha()
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
    local function Columns()
      if not framesColumn[i]  then
        framesColumn[i] = 5
        columnsWidget.text2:SetText(framesColumn[i])
      else
        columnsWidget.text2:SetText(framesColumn[i])
 
      end
    end
    local function Rows()
      if not framesRows[i] then
        framesRows[i] = 1
      --  frames[i]:Height((framesRows[i]*50)+25)
      else
      --  frames[i]:Height((framesRows[i]*50)+25)
      end
    end
    local function Hide()
      if not framesHideRest[i]  then    
        hideWidget.checkBox:SetChecked(false)
       else
         local value = framesHideRest[i]
         hideWidget.checkBox:SetChecked(value)
       end
    end
    local function Scripts()    
    local optionWidget = frames[i].configWidgets[2]
    local iconHolder = frames[i].configWidgets[3]
--    local barText = frames[i].configWidgets[2].settings[1].text
    local barText = frames[i].configWidgets[2].settings[1].text
    local function EditButton()
      local editButton = frames[i].configWidgets[1] 
      editButton.button:SetScript(onClick,function ()        
        if optionWidget:IsVisible() then
          optionWidget:Hide()
        else
          optionWidget:Show()
          for k in pairs(frames) do
            if k ~=i then
              frames[k].configWidgets[2]:Hide()
            end
          end
        end
        barText:SetText(Localization:Bar()..ActionBars:FindIndex(i))
      end) 
    end 
    local function BarNavigator()
      barWidget.minusButton:SetScript(onClick, function ()
        ActionBars:HideOptionPanels() 
         if ActionBars:FindIndex(i)>=2 then
          local previousWidget = frames[i-1].configWidgets[2]
          local previousText = frames[i-1].configWidgets[2].settings[1].text
           previousWidget:Show()
           previousText:SetText(Localization:Bar()..ActionBars:FindIndex(i-1))
         elseif ActionBars:FindIndex(i) ==1 then                  
        local function ShowLastOptionWidget()
            ActionBars:HideOptionPanels()
            local lastFrameID = select(2,ActionBars:GetHighest()) 
            local optionWidget = frames[lastFrameID].configWidgets[2]
            local barText = frames[lastFrameID].configWidgets[2].settings[1].text
            optionWidget:Show()
            barText:SetText(Localization:Bar()..ActionBars:FindIndex(lastFrameID))
 
        end
          ShowLastOptionWidget()
        end
      end) 
      barWidget.plusButton:SetScript(onClick, function ()
           ActionBars:HideOptionPanels()
           if frameIDs[i+1] then
            local nextWidget = frames[i+1].configWidgets[2]
            local nextText = frames[i+1].configWidgets[2].settings[1].text
          nextWidget:Show()
          nextText:SetText(Localization:Bar()..ActionBars:FindIndex(i+1))
           else              
            optionWidget:Show()       
           
           end
      end)
    end
    local function Scale()
      scaleWidget.slider:SetScript(onValueChanged, function (self) 
        iconHolder:SetScale(self:GetValue())  
        framesScale[i] = self:GetValue()      
        scaleWidget.text:SetText(Config:RoundNumber(framesScale[i],2))      
        end) 
    end     
    local function Alpha()
        alphaWidget.slider:SetScript(onValueChanged, function (self)  
          iconHolder:SetAlpha(self:GetValue()) 
          framesAlpha[i] = self:GetValue() 
          alphaWidget.text:SetText(Config:RoundNumber(framesAlpha[i],2))    
            end)  
    end
    local function Hide()
      hideWidget.checkBox:SetScript(onClick,function (self)
        framesHideRest[i] = self:GetChecked()
        end) 
    end
    local function Columns()
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
    local function Drag()
      local onDragStart="OnDragStart"
      local onDragStop ="OnDragStop"
      local backgroundFrameStrata ="BACKGROUND"
      local tooltipFrameStrata = "TOOLTIP"
      frames[i]:SetScript(onDragStart,function ()
        frames[i]:SetFrameStrata(tooltipFrameStrata)  
        frames[i].configWidgets[3]:SetFrameStrata(tooltipFrameStrata)
        frames[i].configWidgets[1]:SetFrameStrata(tooltipFrameStrata)
        frames[i]:StartMoving()
      end)
      frames[i]:SetScript(onDragStop,function ()
        frames[i]:SetFrameStrata(backgroundFrameStrata) 
      
          frames[i].configWidgets[3]:SetFrameStrata(backgroundFrameStrata)
          frames[i].configWidgets[1]:SetFrameStrata(backgroundFrameStrata)   
        frames[i]:StopMovingOrSizing()
    
      end)
    end
    EditButton()  
    BarNavigator() 
    Scale()
    Alpha()
    Hide()
    Columns()
    Drag()

    end
    Position()
    Scale()
    Alpha()
    Columns()
    Rows()
    Hide()
    Scripts()
  end
  SetupActionBars(i) 
end
function ActionBars:Load()--load existing or create first action bar for current spec
  local currentSpecActionsCount = ActionBars:GetCurrentSpecActionBarsCount()
  if currentSpecActionsCount and currentSpecActionsCount~=0 then  
      for frameID in pairs(frameIDs) do                         
        ActionBars:Create(frameID)             
      end   
  else
  local spec = Config:GetSpec()
  actionBarsSpecCount[spec] = 1
  local frameID = Config:JoinNumber(spec,actionBarsSpecCount[spec])
  frameIDs[frameID] = {frameID,actionBarsSpecCount[spec],spec}
  ActionBars:Create(frameID)
  end

end 
function ActionBars:Remove()--remove action bar with highestIndex
local spec = Config:GetSpec()
if  actionBarsSpecCount[spec] > 1 then
  local lastFrameID = select(2,ActionBars:GetHighest())  
  frames[lastFrameID]:Hide()
  frames[lastFrameID].configWidgets[1]:Hide()
  frames[lastFrameID].configWidgets[2]:Hide()
  frames[lastFrameID].configWidgets[3]:Hide()
  frames[lastFrameID] = nil
  frameIDs[lastFrameID] = nil
  framesScale[lastFrameID] = nil 
  framesPosition[lastFrameID] = nil 
  framesAlpha[lastFrameID] = nil 
  framesHideRest[lastFrameID] =nil
  framesColumn[lastFrameID] = nil
  
  local cA = Actions:GetCurrent()
      for k in pairs(cA) do
        local barNumber = cA[k][6]        
        if barNumber==lastFrameID then    
          cA[k][6] = cA[k][6]-1
        end 
      end 
      local tA = Actions:GetTracked()
      for k in pairs(tA) do
        local barNumber = tA[k][6]        
        if barNumber==lastFrameID then    
          tA[k][6] = tA[k][6]-1
        end 
      end 
    
      actionBarsSpecCount[spec] =actionBarsSpecCount[spec]-1
end
Config:Save()
UI:Update()
end
function ActionBars:Unload() --unload all loaded action bars (specchange)
  for frameID in pairs(frames) do  
  if frames[frameID] then
  frames[frameID]:Hide()
  frames[frameID].configWidgets[1]:Hide() --Hide iconholder 
  frames[frameID].configWidgets[2]:Hide() --Hide iconholder 
  frames[frameID].configWidgets[3]:Hide() --Hide iconholder 
  end
  end
  frames = nil
end
--Widgets--------------------------
function ActionBars:HideOptionPanels()--hide all option Panels
  for frameID in pairs(frames) do
    frames[frameID].configWidgets[2]:Hide()
  end
end
function ActionBars:Toggle(value)--Toggle config mode widgets
  --Actionbars
 for _,v in pairs(frameIDs) do
   if v[3] == Config:GetSpec() then
   local frameID = v[1]
   local configWidgets = frames[frameID].configWidgets
   frames[frameID]:SetMovable(value) 
   frames[frameID]:EnableMouse(value)  
   for _ in pairs(configWidgets) do
     local editButton = configWidgets[1]
     local optionPanel = configWidgets[2]
     local iconHolder = configWidgets[3]
     if value == true then
       editButton:Show() -- edit button
       editButton.button:Show()
      
       iconHolder:Show() --icon holder   
     else
       editButton:Hide() 
       editButton.button:Hide()
       optionPanel:Hide()   
       iconHolder:Show() 
     end
 
   end          
 end
 
 end
  --ActionWidgets
 for _,v in pairs(Actions:GetCurrent()) do
     local widget = v[3]
     if v[5] == Config:GetSpec() then
       if widget and widget.edit and widget.group and widget.charges then
         if value == true then
         widget.edit:SetEnabled(value) 
         widget.group:Show()
         widget.charges:Hide()  
        else
         widget.group:Hide()
         widget.charges:Show()
         widget.edit:SetEnabled(value) 
         ActionBars:HideOptionPanels()
        end
        end 
     end
   
   
 end
 end
--Find-------------------------
function ActionBars:FindIndex(frameID) --return frameIndex based on frameID
--  local frameIndex
  for k,v in pairs(frameIDs) do
    if k==frameID then
      return v[2]      
    end
  end
end
function ActionBars:FindFrameID(frameIndex) --return frameID based on frameIndex
  for k,v in pairs(frameIDs) do
    if v[2]==frameIndex and v[3] == Config:GetSpec() then
      return k      
    end
  end
end
--Update----------------------
function ActionBars:StartUpdate()--create frame what hold Script with OnUpdate event (refreshing actions every frame)
  updater = CreateFrame("Frame",nil,nil)
  updater:SetScript(onUpdate, function ()
    local actions = Actions:GetCurrent()
    ActionBars:Update(actions)   
    for frameID,v in pairs(frameIDs) do 
      if v[3] == Config:GetSpec()then
        ActionBars:Sort(frameID,actions)    
      end              
    end
    end) 
end
function ActionBars:StopUpdate()
  updater:SetScript(onUpdate,nil)
end
function ActionBars:Update(actions) --determinate if widget will be visible or hidden
  local configMode = Config:IsConfigMode() --1 in config
  local userSpec = Config:GetSpec() -- 1 in config
  local isResting = Config:GetResting() --1 in config
  local isPvPing = Config:GetPVP() -- 1 in config
  local globalHideRest = Config:GetGlobalHideRest() --1 ab 1 ui
 
  for actionID in pairs(actions) do  
    local slotID = actions[actionID][1]
    local spellID = actions[actionID][2]
    local widget = actions[actionID][3]
    local actionSpec = actions[actionID][5]
    local frameIndex = actions[actionID][6] 
    local isBoosted = actions[actionID][7]   
    local displayOnlyWhenBoosted =actions[actionID][8]
    local actionType = actions[actionID][9]  
    local isPVPspell = actions[actionID][10]  
    

    if Config:IsValueSame(actionSpec,userSpec) then
      if globalHideRest == true and isResting ==true and configMode == false then
       widget:Hide()
      else
        local chargesText = API:GetActionCharges(spellID,actionType) 
        local isUsable,notEnoughMana = API:IsUsableAction(spellID,actionType)  
        local _, duration, _ = API:GetActionCooldown(spellID,actionType,slotID)  
        local inRange = API:IsActionInRange(spellID,actionType)       
        widget.charges:SetText(chargesText)          
        if configMode or isBoosted and isUsable==true and notEnoughMana==false and duration <1.5 and inRange==true then      
          widget:Show()
          if isBoosted == true then
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
                if isPvPing == false and isPVPspell == true then
                  widget:Hide()
                else
                  widget:Show()       
                  if widget then                   
                    ActionButton_HideOverlayGlow(widget)
                  end        
                end           
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
function ActionBars:Sort(frameID,actions)--handle displayed widget position and parent
  local startxOffset = 0
  local startyOffset = 0
 -- local count =0
 -- local rowCount = 0
  local iconHolder = frames[frameID].configWidgets[3]
  for actionID in pairs(actions) do
    local actionFrameNumber = actions[actionID][6]      
    local widget = actions[actionID][3]
      if actionFrameNumber == frameID and widget:IsVisible() then  
        widget:SetPoint("LEFT",iconHolder,"LEFT",startxOffset,startyOffset)        
        widget:SetParent(iconHolder)       
        startxOffset = startxOffset +50
        if(startxOffset== framesColumn[frameID]*50) then
        startxOffset =0
        startyOffset  = startyOffset-50
        end  
      elseif actionFrameNumber == frameID then  
        widget:SetPoint("LEFT",iconHolder,"LEFT",startxOffset,startyOffset)        
        widget:SetParent(iconHolder)  
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
function ActionBars:GetHighest()                                                                     
           
              local highestID=0 
              local frameID
              for k,v in pairs(frameIDs) do
                if k~=nil then
                  if v[2]>=highestID and v[3]==Config:GetSpec() then
                  highestID = v[2]
                  frameID = v[1] 
                  end               
                end   
              end  
                                                                                                   
             return highestID,frameID
                            
end
function ActionBars:GetActionBar(frameID)                                                                     
return frames[frameID]            
end
function ActionBars:GetCurrentSpecActionBarsCount()
local currentSpec = Config:GetSpec() 
return actionBarsSpecCount[currentSpec] 
end
function ActionBars:GetSV()                 
  local returnTable =
         {                                               
            FramesSpecBarCounts = function(self)                                                                                    
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
            FramesPosition = function(self) 
              for k in pairs(frames) do
                --local frameIndex = k
                if k then
                  local function CalculateFramePosition(k)
                    local point, _, relativePoint, xOfs, yOfs = frames[k]:GetPoint(1)
                    local function round2(num, numDecimalPlaces)
                      return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
                    end
                    return {round2(xOfs,2),round2(yOfs,2),point,relativePoint}
                    
                  end 
                  framesPosition[k]=CalculateFramePosition(k)   
                end
                
                           
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
--Revision v 1.0.3 --
