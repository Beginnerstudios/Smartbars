--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.UI ={};
local UI=BS_ActionsTracker.UI;
local Actions
--Init------------------------------------
function UI:Init()
Actions = BS_ActionsTracker.Actions
Core = BS_ActionsTracker.Core
Config = BS_ActionsTracker.Config
end
--Variables-------------------------------
local primaryFrame   -- hold only primary config frame
local secondaryFrame --holds all tracked action bars (OnUpdate runs on this frame)
local frames = {};   -- hold all tracked bars as childs of secondaryFrame
local trackedActionsColumnCount=0 --SV
local trackedSpellsFramePosition ={};--SV
local trackedActionsFrameScale =0--SV
local trackedActionsFrameCount = 1--SV
local trackedActionsFrameAlpha =0
local trackedActionsHideInRestZone --SV
local primaryFrameMinimuHeight
local trackedBarsMaximum = 10

--UI:Frames-------------------------------
function UI:CreateFrames()  
  local function PrimaryFrame()
    local defaultFont = "GameFontHighlight"
    local defaultLayer = "OVERLAY"
   
      function Frame()
    local primaryFrame = CreateFrame("Frame","BS_ActionsTracker.Primary",UIParent,"BasicFrameTemplateWithInset");
    UI:SetFrameMoveable(primaryFrame)  
    primaryFrame:Hide()
    primaryFrame:SetSize(500,0);
    primaryFrame:SetPoint("CENTER",UIParent,"CENTER",-400,100);
    primaryFrame.CloseButton:SetScript("OnClick", function ()
    Config:ToggleConfigMode()
    end)
    return primaryFrame
      end     
      function StaticTitles(parentFrame)
       UIConfig = parentFrame
       local titles = CreateFrame("Frame","BS_ActionsTracker.Primary",UIConfig) 
       titles.frame = titles:CreateFontString(nil,defaultLayer);
       titles.frame:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",5,-2);
       titles.frame:SetFontObject(defaultFont)
       titles.frame:SetText("BS_ActionsTracker v - 0.8.5");

       titles.usedStatic = titles:CreateFontString(nil,defaultLayer);
       titles.usedStatic:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-30);
       titles.usedStatic:SetFontObject(defaultFont)
       titles.usedStatic:SetText("Used actions:");
    
       titles.trackedStatic = titles:CreateFontString(nil,defaultLayer);
       titles.trackedStatic:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-50);
       titles.trackedStatic:SetFontObject(defaultFont)
       titles.trackedStatic:SetText("Tracked actions:");

       titles.actionsStatic = titles:CreateFontString(nil,defaultLayer);
       titles.actionsStatic:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-70);
       titles.actionsStatic:SetFontObject(defaultFont)
       titles.actionsStatic:SetText("Used actions in action bars:");
       
       titles.trackedValue = titles:CreateFontString(nil,defaultLayer);
       titles.trackedValue:SetPoint("LEFT",titles.trackedStatic,"LEFT",100,0);
       titles.trackedValue:SetFontObject(defaultFont)
       titles.trackedValue:SetText("0");
       
       titles.usedValue = titles:CreateFontString(nil,defaultLayer);
       titles.usedValue:SetPoint("LEFT",titles.usedStatic,"LEFT",100,0);
       titles.usedValue:SetFontObject(defaultFont)
       titles.usedValue:SetText("0");
       return titles
      end
      function ResetButton()
      local resetWidget = CreateFrame("Frame", "only_for_testing")
      resetWidget.title = resetWidget:CreateFontString(nil,defaultLayer);
      resetWidget.title:SetPoint("LEFT",resetWidget,"CENTER",-50,0);
      resetWidget.title:SetFontObject("GameFontHighlight")
      resetWidget.title:SetText("Reset all:")  
      resetWidget.resetButton = CreateFrame("Button", nill, resetWidget,"UIPanelButtonTemplate")
      resetWidget.resetButton:SetPoint("RIGHT",resetWidget,"CENTER",50,-30);
      resetWidget.resetButton:SetSize(50,35)
      resetWidget.resetButton:SetText("Reset")
      resetWidget.resetButton:SetNormalFontObject(defaultFont)
      resetWidget.resetButton:SetScript("OnClick", function ()
      Config:ResetAll()
      end)
      return resetWidget
      end
      function ScaleSlider()           
        local scaleWidget = CreateFrame("Frame", "dasd")
        scaleWidget.title = scaleWidget:CreateFontString(nil,defaultLayer);
        scaleWidget.title:SetPoint("LEFT",scaleWidget,"CENTER",-50,0);
        scaleWidget.title:SetFontObject("GameFontHighlight")
        scaleWidget.title:SetText("Scale:")  
        scaleWidget.slider = CreateFrame("Slider", "myslider", scaleWidget,"OptionsSliderTemplate")
        scaleWidget.slider:SetPoint("CENTER",scaleWidget,"CENTER",0,-30);
        scaleWidget.slider:SetWidth(100)
        scaleWidget.slider:SetHeight(15)
        scaleWidget.slider:SetMinMaxValues(0.5,1.5)
        scaleWidget.slider:SetValue(trackedActionsFrameScale)
        scaleWidget.slider:SetStepsPerPage(10)      
        scaleWidget.slider:SetScript("OnValueChanged", function (self) 
        for i=1,#frames do
        frames[i]:SetScale(self:GetValue())  
        trackedActionsFrameScale = self:GetValue()
        end    
      end)
     
      return scaleWidget
      end
      function AlphaSlider()           
        local alphaWidget = CreateFrame("Frame", "dasd")
        alphaWidget.title = alphaWidget:CreateFontString(nil,defaultLayer);
        alphaWidget.title:SetPoint("LEFT",alphaWidget,"CENTER",-50,0);
        alphaWidget.title:SetFontObject("GameFontHighlight")
        alphaWidget.title:SetText("Transparency:")  
        alphaWidget.slider = CreateFrame("Slider", "myslider", alphaWidget,"OptionsSliderTemplate")
        alphaWidget.slider:SetPoint("CENTER",alphaWidget,"CENTER",0,-30);
        alphaWidget.slider:SetWidth(100)
        alphaWidget.slider:SetHeight(15)
        alphaWidget.slider:SetMinMaxValues(0.3,1)
        alphaWidget.slider:SetValue(trackedActionsFrameAlpha)
        alphaWidget.slider:SetStepsPerPage(10)             
        alphaWidget.slider:SetScript("OnValueChanged", function (self) 
        for i=1,#frames do   
        frames[i]:SetAlpha(self:GetValue())   
        end    
      end)
    
      return alphaWidget
      end
      function ColumnsWidgets()
      local columnsWidget = CreateFrame("Frame","BS_Options_Columns") 
      columnsWidget.text = columnsWidget:CreateFontString(nil,defaultLayer);
      columnsWidget.text:SetPoint("LEFT",columnsWidget,"CENTER",-50,0);
      columnsWidget.text:SetFontObject(defaultFont)
      columnsWidget.text:SetText("Columns: ");
      columnsWidget.text2 = columnsWidget:CreateFontString(nil,defaultLayer);
      columnsWidget.text2:SetPoint("CENTER",columnsWidget,"CENTER",35,0);
      columnsWidget.text2:SetFontObject(defaultFont)
      columnsWidget.text2:SetText(trackedActionsColumnCount);    
      columnsWidget.minusButton = CreateFrame("Button", "bs_minus", columnsWidget,"UIPanelButtonTemplate")
      columnsWidget.minusButton:SetPoint("CENTER", columnsWidget, "CENTER", 0, -30)
      columnsWidget.minusButton:SetSize(35,35)
      columnsWidget.minusButton:SetText("-")
      columnsWidget.minusButton:SetNormalFontObject(defaultFont)    
      columnsWidget.minusButton:SetScript("OnClick", function ()
      if trackedActionsColumnCount>= 2 then
        trackedActionsColumnCount = trackedActionsColumnCount -1
        columnsWidget.text2:SetText(trackedActionsColumnCount)
      end
      end)   
      columnsWidget.plusButton = CreateFrame("Button", "bs_plus", columnsWidget,"UIPanelButtonTemplate")
      columnsWidget.plusButton:SetPoint("CENTER", columnsWidget, "CENTER", 35, -30)
      columnsWidget.plusButton:SetSize(35,35)
      columnsWidget.plusButton:SetText("+")
      columnsWidget.plusButton:SetNormalFontObject(defaultFont)    
      columnsWidget.plusButton:SetScript("OnClick", function ()
      if trackedActionsColumnCount<= 12 then
        trackedActionsColumnCount = trackedActionsColumnCount +1
        columnsWidget.text2:SetText(trackedActionsColumnCount)
      end
      end)
      return columnsWidget
      end
      function BarsWidget()
        local barsWidget = CreateFrame("Frame","BS_Options_Bars") 
        barsWidget.textStatic = barsWidget:CreateFontString(nil,defaultFont);
        barsWidget.textStatic:SetPoint("LEFT",barsWidget,"CENTER",-50,0);
        barsWidget.textStatic:SetFontObject(defaultFont)
        barsWidget.textStatic:SetText("Tracked bars: ");
        barsWidget.textValue = barsWidget:CreateFontString(nil,defaultFont);
        barsWidget.textValue:SetPoint("CENTER",barsWidget,"CENTER",35,0);
        barsWidget.textValue:SetFontObject(defaultFont)
        barsWidget.textValue:SetText(trackedActionsFrameCount);

        barsWidget.minusButton = CreateFrame("Button", "bs_minus", barsWidget,"UIPanelButtonTemplate")
        barsWidget.minusButton :SetPoint("CENTER", barsWidget, "CENTER", 0, -30)
        barsWidget.minusButton :SetSize(35,35)
        barsWidget.minusButton :SetText("-")
        barsWidget.minusButton :SetNormalFontObject(defaultFont)    
        barsWidget.minusButton :SetScript("OnClick", function ()
        UI:RemoveLastActionBar()
        barsWidget.textValue:SetText(trackedActionsFrameCount);
        end) 

        barsWidget.plusButton  = CreateFrame("Button", "bs_plus", barsWidget,"UIPanelButtonTemplate")
        barsWidget.plusButton:SetPoint("CENTER", barsWidget, "CENTER", 35, -30)
       barsWidget.plusButton:SetSize(35,35)
        barsWidget.plusButton:SetText("+")
        barsWidget.plusButton:SetNormalFontObject(defaultFont)    
        barsWidget.plusButton:SetScript("OnClick", function ()        
  
          UI:AddActionBar()                                     
          barsWidget.textValue:SetText(trackedActionsFrameCount)
          UI:ToggleWidgets(true)           
           
        end)
        return barsWidget
  
  
  
      end
      function RestZoneWidget()
      local restZoneWidget = CreateFrame("Frame","BS_ActionsTracker.Primary") 
      restZoneWidget.checkBox = CreateFrame("CheckButton",nil, restZoneWidget, "UICheckButtonTemplate")
      restZoneWidget.checkBox:SetChecked(trackedActionsHideInRestZone)
      restZoneWidget.checkBox:SetSize(35,35)
      restZoneWidget.checkBox:SetPoint("RIGHT",restZoneWidget,"CENTER",50,-30);
      restZoneWidget.checkBox:SetScript("OnClick",function (self)
        local restState = self:GetChecked()
        trackedActionsHideInRestZone = restState
      end)  
      restZoneWidget.title = restZoneWidget:CreateFontString(nil,defaultLayer);
      restZoneWidget.title:SetPoint("LEFT",restZoneWidget,"CENTER",-50,0);
      restZoneWidget.title:SetFontObject("GameFontHighlight")
      restZoneWidget.title:SetText("Hide in rest zone:")   
      return restZoneWidget
      end
      local primaryFrame = Frame()
      primaryFrame.titles = StaticTitles(primaryFrame)
      local optionsWidgets = {ResetButton(),ScaleSlider(),AlphaSlider(),ColumnsWidgets(),BarsWidget(),RestZoneWidget()}   
      local xOfs =50
      for k in pairs(optionsWidgets) do
        optionsWidgets[k]:SetPoint("CENTER", primaryFrame.TitleBg, "CENTER", 150, (xOfs)*-1)
        optionsWidgets[k]:SetParent(primaryFrame)
        optionsWidgets[k]:SetSize(100,100)
        xOfs = xOfs+60   
        primaryFrameMinimuHeight = xOfs +50   
      end
      return primaryFrame
  end
  function SecondaryFrame()
    secondaryFrame = CreateFrame("Frame","BS_ActionsTracker.secondaryFrame",UIParent);
    secondaryFrame:SetPoint("LEFT",UIParent,"LEFT",0,0);
    secondaryFrame:SetSize(100,100)
    secondaryFrame:SetScript("OnUpdate", function ()
      local tA = Actions:GetTracked()
       UI:UpdateBars(tA)
  
     local frameIndex = 1
    while frames[frameIndex] do
      UI:SortTrackedActions(tA,frameIndex)
      frameIndex = frameIndex +1 
     end
  
      end)
      return secondaryFrame
  end
 primaryFrame = PrimaryFrame()
 secondaryFrame = SecondaryFrame()

end
function UI:CreateActionBar(index)
    local function SecondaryFrame()
    SecondaryFrame = CreateFrame("Frame","BS_ActionsTracker.Secondary",UIParent);
    function Frame()
    SecondaryFrame:SetScale(trackedActionsFrameScale)
    SecondaryFrame:SetAlpha(trackedActionsFrameAlpha)
    UI:SetFrameMoveable(SecondaryFrame)
    SecondaryFrame:SetMovable(true)
    SecondaryFrame:SetSize(150,75);
    end
    function Title()
    SecondaryFrame.title = SecondaryFrame:CreateFontString(nil,"ARTWORK");
    SecondaryFrame.title:SetPoint("LEFT",SecondaryFrame,"LEFT",0,-1);
    SecondaryFrame.title:SetFontObject("GameFontHighlight")
    if Config:IsCurrentPatch() then
    SecondaryFrame.title:SetText("BAR: "..index)
    else
    SecondaryFrame.title:SetText("BAR: "..index) 
    end   
    SecondaryFrame.title:SetAlpha(0)
     --SECONDARY FRAME -EVENTS   
    end
    function Info()
      SecondaryFrame.info = CreateFrame("Button",nill,SecondaryFrame,"UIPanelButtonTemplate","ARTWORK");
      SecondaryFrame.info:SetPoint("LEFT",SecondaryFrame,"Center",0,-1);   
      SecondaryFrame.info:SetSize(20,20)    
      if Config:IsCurrentPatch() then
      SecondaryFrame.info.tooltipText = "Move - Drag BAR.\nEdit - Set text inside icon.\nChange bar: Use buttons +-.\nDisplay only when spell is boosted: Check checkbox."
      else
        SecondaryFrame.info.tooltipText ="Move - Drag BAR.\nEdit - Set text inside icon.\nChange bar: Use buttons +-"
      end   
      SecondaryFrame.info:SetAlpha(0)
      SecondaryFrame.info.text = SecondaryFrame.info:CreateFontString(nil,"BORDER");
      SecondaryFrame.info.text:SetPoint("CENTER",SecondaryFrame.info,"CENTER",0,0);
      SecondaryFrame.info.text:SetFontObject("GameFontHighlight")
      SecondaryFrame.info.text:SetText("i")
    end
    Frame()
    Title()
    Info()
    return SecondaryFrame
    end 
    frames[index] = SecondaryFrame()
   
end
function UI:PositionActionBar(frameIndex)
   local i = frameIndex 
   local rowCount =5
 
  if not trackedSpellsFramePosition[i]  then
    local xOffset = 0   
    local yOffset = 400 - (#frames*100)
    local point = "CENTER"
    local relativePoint = "CENTER"
    if i>rowCount then
      xOffset=300
      yOffset=400 - ((#frames-rowCount)*100)    
    end
    frames[frameIndex]:SetPoint(point,UIParent,relativePoint,xOffset,yOffset)
  else
    local xOffset = trackedSpellsFramePosition[i][1] 
    local yOffset = trackedSpellsFramePosition[i][2]
    local point = trackedSpellsFramePosition[i][3]
    local relativePoint = trackedSpellsFramePosition[i][4]
    frames[i]:SetPoint(point,UIParent,relativePoint,xOffset,yOffset)
  end 
end
function UI:RemoveLastActionBar()
  if frames then 
    if #frames >1 then
      local lastIndex = #frames
      frames[#frames]:Hide()  
      frames[#frames] = nill
      local tA = Actions:GetTracked()
      for k,v in pairs(tA) do
        local barNumber = tA[k][6]
        if barNumber>1 and barNumber==lastIndex then         
        UI:MoveActionWidgets(tA[k],-1)
        end  
      end
      trackedActionsFrameCount = trackedActionsFrameCount-1
    end
  end  
end
function UI:AddActionBar()
  if #frames < trackedBarsMaximum then
  UI:CreateActionBar(#frames+1)
  UI:PositionActionBar(#frames)
  UI:ToggleWidgets(true)
  trackedActionsFrameCount = trackedActionsFrameCount +1
  end
end
function UI:MoveActionWidgets(trackedAction,value)
  trackedAction[6] = trackedAction[6] +(value)
  trackedAction[3]:SetParent(frames[trackedAction[6]])
  trackedAction[3].group.barNumberText:SetText(trackedAction[6])  
end
function UI:SetFrameMoveable(frame)
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart",function ()
  frame:StartMoving()
  end)
  frame:SetScript("OnDragStop",function ()
  frame:StopMovingOrSizing()
  Config:SaveConfig()
  end)
end
function UI:CalculateFramePosition(frameIndex)  --return frame from table "frames" [1]primary [2]secondary
  local point, relativeTo, relativePoint, xOfs, yOfs = frames[frameIndex]:GetPoint(1)
  local function round2(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
  end
  return {round2(xOfs,2),round2(yOfs,2),point,relativePoint}
  
end
--UI:Widgets-------------------------------
function UI:CreateActionWidget(action,parentFrame,isTracked,isEnabled)--Return widget with correct size and textures
 local actionWidget = CreateFrame("CheckButton",nil, parentFrame, "UICheckButtonTemplate", "ARTWORK")
 actionWidget:SetPoint("LEFT",parentFrame,"LEFT",0,0)
 actionWidget:SetWidth(50)
 actionWidget:SetHeight(50)
 actionWidget.tooltipText = "test"
 local newTexture= API:GetActionTexture(action[1])
 if isTracked then
  actionWidget:SetHighlightTexture(nill)
  actionWidget:SetPushedTexture(nill)  
 else
  actionWidget:SetHighlightTexture(newTexture)
  actionWidget:SetPushedTexture(newTexture)
 end
 actionWidget:SetNormalTexture(newTexture)
 return actionWidget
end
function UI:CreateEditBox(parentWidget,valueToSave,isEnabled)--Add editbox with desired text on frame 
  local edit = CreateFrame("EditBox",nil, parentWidget, "UICheckButtonTemplate","ARTWORK")
  edit:SetPoint("CENTER",parentWidget,"CENTER",2,0)
  edit:SetSize(50,50)
  edit:SetText(valueToSave[4])
  edit:SetAutoFocus(false)
  edit:SetMaxLetters(3)
  edit:SetEnabled(isEnabled)
  edit:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
  edit:SetScript("OnEditFocusLost", function (self)             
  valueToSave[4] = self:GetText() 
  end)
  return edit
end
function UI:CreateFontString(parentWidget,valueToSave,isEnabled)
local fontString =parentWidget:CreateFontString(nil,"ARTWORK");
fontString:SetPoint("CENTER",parentWidget,"CENTER",17,-17);
fontString:SetFont("Fonts\\FRIZQT__.TTF", 15,nil)
fontString:SetText("Test");
return fontString
end
function UI:CreateGroupLayout(parentWidget,valueToSave,isDisplayed)
local xOfs = 0
local yOfs = -15
local defaultFont = "GameFontHighlight"
local newWidget = CreateFrame("Frame", "bs_newpg", parentWidget)
newWidget:SetPoint("CENTER",parentWidget,"CENTER",0,0);

newWidget.barNumberText =newWidget:CreateFontString(nil,"ARTWORK");
newWidget.barNumberText:SetPoint("CENTER",parentWidget,"CENTER",17,-17);
newWidget.barNumberText:SetFont("Fonts\\FRIZQT__.TTF", 15,"OUTLINE")
newWidget.barNumberText:SetText(valueToSave[6]);
if Config:IsCurrentPatch() then
newWidget.showWhenBoosted = CreateFrame("CheckButton", nil, newWidget,"UICheckButtonTemplate")
newWidget.showWhenBoosted:SetPoint("CENTER", parentWidget, "CENTER", 18,18)
newWidget.showWhenBoosted:SetSize(20,20)
newWidget.showWhenBoosted:SetChecked(valueToSave[8])
newWidget.showWhenBoosted:SetNormalFontObject(defaultFont)   
newWidget.showWhenBoosted:SetScript("OnClick", function (self) 
valueToSave[8]=self:GetChecked()
end)
end



newWidget.minusButton = CreateFrame("Button", "bs_minus2", newWidget,"UIPanelButtonTemplate")
newWidget.minusButton:SetPoint("CENTER", parentWidget, "CENTER", -15,yOfs)
newWidget.minusButton:SetSize(20,20)
newWidget.minusButton:SetText("-")
newWidget.minusButton:SetNormalFontObject(defaultFont)    
newWidget.minusButton:SetScript("OnClick", function () 
  if  valueToSave[6]>1 then
  UI:MoveActionWidgets(valueToSave,-1)
  end
end)
newWidget.plusButton = CreateFrame("Button", "bs_plus2", newWidget,"UIPanelButtonTemplate")
newWidget.plusButton:SetPoint("CENTER", parentWidget, "CENTER", 0, yOfs)
newWidget.plusButton:SetSize(20,20)
newWidget.plusButton:SetText("+")
newWidget.plusButton:SetNormalFontObject(defaultFont)    
newWidget.plusButton:SetScript("OnClick", function ()
  if valueToSave[6]< trackedActionsFrameCount then
    UI:MoveActionWidgets(valueToSave,1)
  end  
end)
if not isDisplayed then
  newWidget:Hide()
end
return newWidget
end
function UI:ToggleWidgets(value)--Toggle edit boxes for edit in tracked actions
  for k,v in pairs(Actions:GetTracked()) do
   if v[3]~=nill then
   v[3].edit:SetEnabled(value) 
   if value == true then
    v[3].group:Show()
    v[3].charges:Hide()
   else
    v[3].group:Hide()
    v[3].charges:Show()
   end
  end
  
  end
  for i=1,#frames do
    frames[i]:SetMovable(value) 
    frames[i]:EnableMouse(value) 
    
      if value == true then
        frames[i].title:SetAlpha(1) 
        frames[i].info:SetAlpha(1) 
      else
        frames[i].title:SetAlpha(0) 
        frames[i].info:SetAlpha(0) 
      end
  end

end
--UI:Update-------------------------------
function UI:UpdateUI() ---update all dynamic variables in UI
local trackedSpellsCount =0
local usedSpellsCount = Config:GetTableCount(API:GetUserActions());
local trackedActions = Actions:GetTracked()

for actionID in pairs(trackedActions) do 
  if trackedActions[actionID][5] == Config:GetSpec() then
    trackedSpellsCount = trackedSpellsCount +1
  end
end


  --Header Primary frame dynamic values
  primaryFrame.titles.usedValue:SetText(usedSpellsCount)
  primaryFrame.titles.trackedValue:SetText(trackedSpellsCount)
  --Primary Frame size
if usedSpellsCount<12 then
  primaryFrame:SetHeight(primaryFrameMinimuHeight)
else
  local actionsHeight = usedSpellsCount/6*60+165
  if primaryFrameMinimuHeight < actionsHeight then
    primaryFrame:SetHeight(actionsHeight)
  else
    primaryFrame:SetHeight(primaryFrameMinimuHeight)
  end
  
end
  function RefreshTrackedIcons()
  for k,v in pairs(trackedActions) do
    if v[3]~=nill then
      local newTexture= API:GetActionTexture(v[1])
      v[3]:SetNormalTexture(newTexture)   
    end
  end
  end
--RefreshTrackedIcons()
end
function UI:UpdateBars(barsToupdate) --parameter list of table of tracked actions  
  local actions = barsToupdate
  local configMode = Config:IsConfigMode()
  local userSpec = Config:GetSpec()
  local isResting = Config:GetResting()
  
if barsToupdate ~=nill then
  for actionID in pairs(actions) do  ---Handle tracked actions visibility
    local slotID = actions[actionID][1]
    local spellID = actions[actionID][2]
    local widget = actions[actionID][3]
    local actionSpec = actions[actionID][5]
    local isBoosted = actions[actionID][7]   
    local displayOnlyWhenBoosted =actions[actionID][8]
     
    if Config:IsValueSame(actionSpec,userSpec)  then       
      local chargesText = API:GetActionCharges(slotID) 
      local isUsable,notEnoughMana = API:IsUsableAction(slotID)  
      local start, duration, onCooldown = API:GetActionCooldown(slotID)        
      widget.charges:SetText(chargesText)          
      if configMode or isBoosted and isUsable==true and notEnoughMana==false  then 
        widget:Show()
       
      else             
        if isResting and trackedActionsHideInRestZone or displayOnlyWhenBoosted  then  
          widget:Hide()  
        else                 
          local inRange = IsActionInRange(slotID)
          if notEnoughMana or onCooldown>0 and duration>1.5 or inRange==false or not isUsable then
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

  
    else
      widget:Hide()
    end
  end
  end   
end
function UI:SortTrackedActions(trackedActions,sortNumber)
  local startxOffset = 0
  local startyOffset =-37
  local count = 0
 
  for k,v in pairs(trackedActions) do
    local actionID = k 
    local frameNumber = trackedActions[actionID][6]
    local widget = trackedActions[actionID][3]
    if frameNumber == sortNumber then
      if widget:IsVisible() == true then    ----Sort tracked actions
        widget:SetPoint("LEFT",frames[frameNumber],"LEFT",startxOffset,startyOffset)
        startxOffset = startxOffset +50
        count = count + 1
          if(startxOffset== trackedActionsColumnCount*50) then
      startxOffset =0
      startyOffset  = startyOffset-50
          end
      end
    end
  end
end
--Getters & Setters-----------------------------
function UI:Get()                         
  local returnTable =
         {                         
             ActionBar = function(self,barIndex)             
                return frames[barIndex]                             
             end,        
             ColumnCount = function(self)                                                             
                return trackedActionsColumnCount
             end,
             CurrentSpec = function(self)                                                                                    
                return  currentSpecialization
             end,
             ActionBarCount = function(self)                                                                                    
              return  trackedActionsFrameCount
             end,
             ActionBarsPositions = function(self) 
              for i=1,#frames do
                trackedSpellsFramePosition[i]=UI:CalculateFramePosition(i)
                end
                return trackedSpellsFramePosition         
             end,
             HideInSaveZone = function(self)                                                                                    
              return  trackedActionsHideInRestZone
             end,
             PrimaryFrame = function(self)                                                                                    
              return  primaryFrame
             end            
         }
 return returnTable
end
function UI:SetSavedVariables(framePosition,columnCount,frameScale,frameCount,hiddenInRestZone,frameAlpha)
  trackedActionsColumnCount = columnCount
  trackedSpellsFramePosition = framePosition
  trackedActionsFrameCount = frameCount
  trackedActionsFrameScale = frameScale
  trackedActionsHideInRestZone = hiddenInRestZone
  trackedActionsFrameAlpha = frameAlpha
end
-- Revision version v0.8.5 ---


