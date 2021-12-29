--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.UI ={};
local UI=SmartBars.UI;
local Actions
local Core
local Config
--Init------------------------------------
function UI:Init()
Actions = SmartBars.Actions
Core = SmartBars.Core
Config = SmartBars.Config
end
--Variables-------------------------------
local primaryFrame   
local frames = {};  
local trackedActionsColumnCount=0 --SV
local trackedSpellsFramePosition ={};--SV
local trackedActionsFrameScale =0--SV
local trackedActionsFrameCount = 1--SV
local trackedActionsFrameAlpha =0--SV
local trackedActionsHideInRestZone --SV
local primaryFrameMinimuHeight
local trackedBarsMaximum = 10

--new
local framesPosition = {}
local framesScale = {}
local framesAlpha = {}
local framesColumn ={}
local framesHideRest = {}

local primaryFrameHeight
local actionBarsCount = 0
local globalHideRest = false
local optionWidgets = {}


--UI:Frames-------------------------------
function UI:CreateFrames()  
  local function PrimaryFrame()
    local defaultFont = "GameFontHighlight"
    local defaultLayer = "OVERLAY"
   
      function Frame()
    local frame = CreateFrame("Frame",nill,UIParent,"BasicFrameTemplateWithInset");
    UI:SetFrameMoveable(frame)  
    frame:Hide()
    frame:SetSize(450,0);
    frame:SetPoint("CENTER",UIParent,"CENTER",-500,100);
    frame.CloseButton:SetScript("OnClick", function ()
    Config:ToggleConfigMode()
    end)
    return frame
      end     
      function StaticTitles(parentFrame)
       UIConfig = parentFrame
       local titles = CreateFrame("Frame",nill,UIConfig) 
       titles.frame = titles:CreateFontString(nil,defaultLayer);
       titles.frame:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",5,-2);
       titles.frame:SetFontObject(defaultFont)
       titles.frame:SetText("SmartBars " ..SmartBarsVersion);

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
       titles.actionsStatic:SetText("Used spells and items in action bars:");
       
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
      function ResetAll()
      local resetWidget = CreateFrame("Frame",nil)
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
        local scaleWidget = CreateFrame("Frame",nil)
        scaleWidget.title = scaleWidget:CreateFontString(nil,defaultLayer);
        scaleWidget.title:SetPoint("LEFT",scaleWidget,"CENTER",-50,0);
        scaleWidget.title:SetFontObject("GameFontHighlight")
        scaleWidget.title:SetText("Scale:")  
        scaleWidget.slider = CreateFrame("Slider",nil, scaleWidget,"OptionsSliderTemplate")
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
        trackedActionsFrameAlpha = self:GetValue() 
        end    
      end)
    
      return alphaWidget
      end
      function ColumnsWidgets()
      local columnsWidget = CreateFrame("Frame",nil) 
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
      columnsWidget.plusButton = CreateFrame("Button",nil, columnsWidget,"UIPanelButtonTemplate")
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
        local barsWidget = CreateFrame("Frame",nil) 
        barsWidget.textStatic = barsWidget:CreateFontString(nil,defaultFont);
        barsWidget.textStatic:SetPoint("LEFT",barsWidget,"CENTER",-50,0);
        barsWidget.textStatic:SetFontObject(defaultFont)
        barsWidget.textStatic:SetText("Tracked bars: ");
        barsWidget.textValue = barsWidget:CreateFontString(nil,defaultFont);
        barsWidget.textValue:SetPoint("CENTER",barsWidget,"CENTER",35,0);
        barsWidget.textValue:SetFontObject(defaultFont)
        barsWidget.textValue:SetText(actionBarsCount);

        barsWidget.minusButton = CreateFrame("Button",nil, barsWidget,"UIPanelButtonTemplate")
        barsWidget.minusButton :SetPoint("CENTER", barsWidget, "CENTER", 0, -30)
        barsWidget.minusButton :SetSize(35,35)
        barsWidget.minusButton :SetText("-")
        barsWidget.minusButton :SetNormalFontObject(defaultFont)    
        barsWidget.minusButton :SetScript("OnClick", function ()
        UI:RemoveLastActionBar()
        UI:UpdateUI()
        barsWidget.textValue:SetText(actionBarsCount);
        end) 

        barsWidget.plusButton  = CreateFrame("Button",nil, barsWidget,"UIPanelButtonTemplate")
        barsWidget.plusButton:SetPoint("CENTER", barsWidget, "CENTER", 35, -30)
       barsWidget.plusButton:SetSize(35,35)
        barsWidget.plusButton:SetText("+")
        barsWidget.plusButton:SetNormalFontObject(defaultFont)    
        barsWidget.plusButton:SetScript("OnClick", function ()        
  
          UI:AddActionBar()                                     
          barsWidget.textValue:SetText(actionBarsCount)
          UI:ToggleWidgets(true)           
          UI:UpdateUI()
        end)
        return barsWidget
  
  
  
      end
      function RestZoneWidget()
      local restZoneWidget = CreateFrame("Frame",nil) 
      restZoneWidget.checkBox = CreateFrame("CheckButton",nil, restZoneWidget, "UICheckButtonTemplate")
      restZoneWidget.checkBox:SetChecked(globalHideRest)
      restZoneWidget.checkBox:SetSize(35,35)
      restZoneWidget.checkBox:SetPoint("RIGHT",restZoneWidget,"CENTER",50,-30);
      restZoneWidget.checkBox:SetScript("OnClick",function (self)
      globalHideRest = self:GetChecked()
      end)  
      restZoneWidget.title = restZoneWidget:CreateFontString(nil,defaultLayer);
      restZoneWidget.title:SetPoint("LEFT",restZoneWidget,"CENTER",-50,0);
      restZoneWidget.title:SetFontObject("GameFontHighlight")
      restZoneWidget.title:SetText("Hide in rest zone:")   
      return restZoneWidget
      end
      primaryFrame = Frame()
      primaryFrame.titles = StaticTitles(primaryFrame)
      local optionsWidgets = {ResetAll(),BarsWidget(),RestZoneWidget()}   
      local xOfs =50
      for k in pairs(optionsWidgets) do
        optionsWidgets[k]:SetPoint("CENTER", primaryFrame.TitleBg, "CENTER", 165, (xOfs)*-1)
        optionsWidgets[k]:SetParent(primaryFrame)
        optionsWidgets[k]:SetSize(100,100)
        xOfs = xOfs+60   
        primaryFrameMinimuHeight = xOfs +50   
      end
      return primaryFrame
  end
  function SecondaryFrame()
    local frameholder = CreateFrame("Frame",nil,UIParent);
    frameholder:SetPoint("LEFT",UIParent,"LEFT",0,0);
    frameholder:SetSize(100,100)
    frameholder:SetScript("OnUpdate", function ()
    local tA = Actions:GetTracked()
    UI:UpdateBars(tA)
  
    local frameIndex = 1
    while frames[frameIndex] do
    UI:SortBars(tA,frameIndex)
    frameIndex = frameIndex +1 
    end
  
    end)
  return frameholder
  end
 primaryFrame = PrimaryFrame()
 SecondaryFrame()

end
function UI:CreateActionBar(index)
    local function ActionBar()
    local actionBar = CreateFrame("Frame","BS_ActionsTracker.Secondary",UIParent);
    function Frame()
    actionBar:SetScale(1)
    actionBar:SetAlpha(1)
    UI:SetFrameMoveable(actionBar)
    actionBar:SetMovable(true)
    actionBar:SetSize(150,75);
    end
    function Title()
      actionBar.title = actionBar:CreateFontString(nil,"ARTWORK");
      actionBar.title:SetPoint("LEFT",actionBar,"LEFT",0,-1);
      actionBar.title:SetFontObject("GameFontHighlight")
    if Config:IsCurrentPatch() then
      actionBar.title:SetText("BAR: "..index)
    else
      actionBar.title:SetText("BAR: "..index) 
    end   
    actionBar.title:SetAlpha(0)
     --SECONDARY FRAME -EVENTS   
    end
    function Info()
      actionBar.info = CreateFrame("Button",nill,actionBar,"UIPanelButtonTemplate","ARTWORK");
      actionBar.info:SetPoint("LEFT",actionBar,"Center",0,-1);   
      actionBar.info:SetSize(20,20)    
      if Config:IsCurrentPatch() then
        actionBar.info.tooltipText = "Move - Drag BAR.\nEdit - Set text inside icon.\nChange bar: Use buttons +-.\nDisplay only when spell is boosted: Check checkbox."
      else
        actionBar.info.tooltipText ="Move - Drag BAR.\nEdit - Set text inside icon.\nChange bar: Use buttons +-"
      end   
      actionBar.info:SetAlpha(0)
      actionBar.info.text = actionBar.info:CreateFontString(nil,"BORDER");
      actionBar.info.text:SetPoint("CENTER",actionBar.info,"CENTER",0,0);
      actionBar.info.text:SetFontObject("GameFontHighlight")
      actionBar.info.text:SetText("i")
    end
    function Edit()
      actionBar.edit = CreateFrame("Button",nill,actionBar,"UIPanelButtonTemplate","ARTWORK");
      actionBar.edit:SetPoint("LEFT",actionBar,"Center",-35,-1);   
      actionBar.edit:SetSize(40,20)         
      actionBar.edit:SetAlpha(0)
      actionBar.edit.text = actionBar.edit:CreateFontString(nil,"BORDER");
      actionBar.edit.text:SetPoint("CENTER",actionBar.edit,"CENTER",0,0);
      actionBar.edit.text:SetFontObject("GameFontHighlight")
      actionBar.edit.text:SetText("Edit")
      actionBar.edit:SetScript("OnClick",function ()
      UI:HideOptionPanels()
       if frames[index].optionWidget:IsVisible() then
        frames[index].optionWidget:Hide()
       else
        frames[index].optionWidget:Show()
       end
      end)
      
    end
    function OptionWidget()
      actionBar.optionWidget = CreateFrame("Frame",nill,actionBar,"BasicFrameTemplateWithInset","ARTWORK");
      actionBar.optionWidget:SetPoint("LEFT",primaryFrame,"RIGHT",0,0);   
      actionBar.optionWidget:SetSize(150,primaryFrame:GetHeight())         
      actionBar.optionWidget:Hide() 
      actionBar.optionWidget:SetParent(primaryFrame)
     -- UI:SetFrameMoveable(actionBar.optionWidget)  
    
      local defaultFont = "GameFontHighlight"
      local defaultLayer = "OVERLAY"
      
      
       function ScaleSlider()           
         local scaleWidget = CreateFrame("Frame",nil)
         scaleWidget.title = scaleWidget:CreateFontString(nil,defaultLayer);
         scaleWidget.title:SetPoint("LEFT",scaleWidget,"CENTER",-50,0);
         scaleWidget.title:SetFontObject("GameFontHighlight")
         scaleWidget.title:SetText("Scale:")  
         scaleWidget.slider = CreateFrame("Slider",nil, scaleWidget,"OptionsSliderTemplate")
         scaleWidget.slider:SetPoint("CENTER",scaleWidget,"CENTER",0,-30);
         scaleWidget.slider:SetWidth(100)
         scaleWidget.slider:SetHeight(15)
         scaleWidget.slider:SetMinMaxValues(0.5,1.5)
         if framesScale[index] then          
          scaleWidget.slider:SetValue(framesScale[index])
         end
         scaleWidget.slider:SetStepsPerPage(10)      
         scaleWidget.slider:SetScript("OnValueChanged", function (self) 
        
         frames[index]:SetScale(self:GetValue())  
         framesScale[index] = self:GetValue()
         
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
         if framesAlpha[index] then
          alphaWidget.slider:SetValue(framesAlpha[index])           
         end
         alphaWidget.slider:SetStepsPerPage(10)             
         alphaWidget.slider:SetScript("OnValueChanged", function (self)  
         frames[index]:SetAlpha(self:GetValue()) 
         framesAlpha[index] = self:GetValue() 
            
       end)
     
       return alphaWidget
       end
       function ColumnsWidgets()
       local columnsWidget = CreateFrame("Frame",nil) 
       columnsWidget.text = columnsWidget:CreateFontString(nil,defaultLayer);
       columnsWidget.text:SetPoint("LEFT",columnsWidget,"CENTER",-50,0);
       columnsWidget.text:SetFontObject(defaultFont)
       columnsWidget.text:SetText("Columns: ");
       columnsWidget.text2 = columnsWidget:CreateFontString(nil,defaultLayer);
       columnsWidget.text2:SetPoint("CENTER",columnsWidget,"CENTER",35,0);
       columnsWidget.text2:SetFontObject(defaultFont)
      -- columnsWidget.text2:SetText(framesColumn[index][1]);    
       columnsWidget.minusButton = CreateFrame("Button", "bs_minus", columnsWidget,"UIPanelButtonTemplate")
       columnsWidget.minusButton:SetPoint("CENTER", columnsWidget, "CENTER", 0, -30)
       columnsWidget.minusButton:SetSize(35,35)
       columnsWidget.minusButton:SetText("-")
       columnsWidget.minusButton:SetNormalFontObject(defaultFont)    
       columnsWidget.minusButton:SetScript("OnClick", function ()
       if framesColumn[index]>= 2 then
        framesColumn[index] = framesColumn[index] -1
        columnsWidget.text2:SetText(framesColumn[index])
       end
       end)   
       columnsWidget.plusButton = CreateFrame("Button",nil, columnsWidget,"UIPanelButtonTemplate")
       columnsWidget.plusButton:SetPoint("CENTER", columnsWidget, "CENTER", 35, -30)
       columnsWidget.plusButton:SetSize(35,35)
       columnsWidget.plusButton:SetText("+")
       columnsWidget.plusButton:SetNormalFontObject(defaultFont)    
       columnsWidget.plusButton:SetScript("OnClick", function ()
       
         framesColumn[index] = framesColumn[index] +1
         columnsWidget.text2:SetText(framesColumn[index])
       
       end)
       return columnsWidget
       end      
       function RestZoneWidget()
       local restZoneWidget = CreateFrame("Frame",nil) 
       restZoneWidget.checkBox = CreateFrame("CheckButton",nil, restZoneWidget, "UICheckButtonTemplate")
       restZoneWidget.checkBox:SetChecked(framesHideRest[index])
       restZoneWidget.checkBox:SetSize(35,35)
       restZoneWidget.checkBox:SetPoint("RIGHT",restZoneWidget,"CENTER",50,-30);
       restZoneWidget.checkBox:SetScript("OnClick",function (self)
        framesHideRest[index] = self:GetChecked()
       end)  
       restZoneWidget.title = restZoneWidget:CreateFontString(nil,defaultLayer);
       restZoneWidget.title:SetPoint("LEFT",restZoneWidget,"CENTER",-50,0);
       restZoneWidget.title:SetFontObject("GameFontHighlight")
       restZoneWidget.title:SetText("Hide in rest zone:")   
       return restZoneWidget
       end
       function Title()
        local title = actionBar.optionWidget:CreateFontString(nil,"ARTWORK");
        title:SetPoint("LEFT",actionBar.optionWidget.TitleBg,"LEFT",0,-2);
        title:SetFontObject("GameFontHighlight")
        title:SetText(" BAR: "..index)       
      return title   
      end
      optionWidgets[index] = {ScaleSlider(),AlphaSlider(),ColumnsWidgets(),RestZoneWidget(),Title()}   
       local yOfs =60
       for k in pairs(optionWidgets[index]) do
        optionWidgets[index][k]:SetPoint("CENTER", actionBar.optionWidget, "TOP", 0, (yOfs)*-1)
        optionWidgets[index][k]:SetParent(actionBar.optionWidget)
        optionWidgets[index][k]:SetSize(50,50)
        yOfs = yOfs+60    
      end
    end
    Frame()
    Title()
    Info()
    Edit()
    OptionWidget()
    return actionBar
    end 
    frames[index] = ActionBar()   
end
function UI:SetupSettings(i)

  local rowCount =5
 ---Position
 if not framesPosition[i]  then
   local xOffset = 0   
   local yOffset = 400 - (#frames*100)
   local point = "CENTER"
   local relativePoint = "CENTER"
   if i>rowCount then
     xOffset=300
     yOffset=400 - ((#frames-rowCount)*100)    
   end
   frames[i]:SetPoint(point,UIParent,relativePoint,xOffset,yOffset)
   framesPosition[i] = {xOffset,yOffset,point,relativePoint}
 else
   local xOffset = framesPosition[i][1] 
   local yOffset = framesPosition[i][2]
   local point = framesPosition[i][3]
   local relativePoint = framesPosition[i][4]
   frames[i]:SetPoint(point,UIParent,relativePoint,xOffset,yOffset)
 end 
 --Scale
 if not framesScale[i]  then
  framesScale[i]=1
  frames[i]:SetScale(framesScale[i])
  optionWidgets[i][1].slider:SetValue(framesScale[i])
else
  local scale = framesScale[i] 
  frames[i]:SetScale(scale)
  optionWidgets[i][1].slider:SetValue(scale)
end 
--Alpha
if not framesAlpha[i]  then
  framesAlpha[i]=1
  frames[i]:SetAlpha(framesAlpha[i])
  optionWidgets[i][2].slider:SetValue(framesAlpha[i])
else
  local alpha = framesAlpha[i]
  frames[i]:SetAlpha(alpha)
  optionWidgets[i][2].slider:SetValue(alpha)
end 
--Columns
if not framesColumn[i]  then
  framesColumn[i] = 10
  optionWidgets[i][3].text2:SetText(framesColumn[i])
else
  optionWidgets[i][3].text2:SetText(framesColumn[i])
end
--Hide
if not framesHideRest[i]  then
 framesHideRest[i] = false
 optionWidgets[i][4].checkBox:SetChecked(framesHideRest[i])
else
  local value = framesHideRest[i]
  optionWidgets[i][4].checkBox:SetChecked(value)
end
end
function UI:RemoveLastActionBar()
  if frames then 
    if #frames >1 then
      local lastIndex = #frames
      frames[#frames]:Hide()  
      UI:HideOptionPanels()
      framesScale[#frames] = nill 
      framesPosition[#frames] = nill 
      framesAlpha[#frames] = nill 
      frames[#frames] = nill
     
      local tA = Actions:GetTracked()
      for k,v in pairs(tA) do
        local barNumber = tA[k][6]
        if barNumber>1 and barNumber==lastIndex then         
        UI:MoveActionWidgets(tA[k],-1)
        end  
      end
      actionBarsCount = actionBarsCount-1
    end
  end  
end
function UI:AddActionBar()
  if #frames < trackedBarsMaximum then
  UI:CreateActionBar(#frames+1)
  UI:SetupSettings(#frames)
  UI:ToggleWidgets(true)
  actionBarsCount = actionBarsCount +1
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
function UI:CalculateFramePosition(frameIndex)
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
 local spellID = action[2] 
 local newTexture= API:GetActionTexture(spellID,action[6],action[1])
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
fontString:SetPoint("RIGHT",parentWidget,"CENTER",22,-17);
fontString:SetFont("Fonts\\FRIZQT__.TTF", 15,nil)
fontString:SetText("");
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
  if valueToSave[6]< actionBarsCount then
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
        frames[i].edit:SetAlpha(1) 
      else
        frames[i].title:SetAlpha(0) 
        frames[i].info:SetAlpha(0) 
        frames[i].edit:SetAlpha(0) 
      end
  end

end
function UI:HideOptionPanels()
  for index in pairs(frames) do
    frames[index].optionWidget:Hide()
  end
end
--UI:Update-------------------------------
function UI:UpdateUI() ---update all dynamic variables in UI 
  --Get count of tracked actions for current spec
local trackedActions = Actions:GetTracked()
local trackedActionForSpecCount =0
for actionID in pairs(trackedActions) do 
  local actionSpec = trackedActions[actionID][5] 
  local currentSpec = Config:GetSpec()
  if Config:IsValueSame(actionSpec,currentSpec) then
    trackedActionForSpecCount = trackedActionForSpecCount +1
  end
end
primaryFrame.titles.trackedValue:SetText(trackedActionForSpecCount)
--Get count of user actions in action bars
local usedSpellsCount = Config:GetTableCount(API:GetUserActions());
primaryFrame.titles.usedValue:SetText(usedSpellsCount) 
--Count Primary frame height
local minimumHeight = primaryFrameMinimuHeight
if usedSpellsCount<12 then
  primaryFrame:SetHeight(minimumHeight)
else
  local actionsHeight = usedSpellsCount/6*60+165
  if minimumHeight < actionsHeight then
    primaryFrame:SetHeight(actionsHeight)
    primaryFrameHeight =actionsHeight
  else
    primaryFrame:SetHeight(minimumHeight)
    primaryFrameHeight = minimumHeight
  end  
end
for i in pairs(frames) do
  frames[i].optionWidget:SetHeight(primaryFrameHeight)
end

UI:RefreshTrackedIcons()
end
function UI:RefreshTrackedIcons()
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
function UI:UpdateBars(barsToupdate) --parameter list of table of tracked actions  
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
     
    if Config:IsValueSame(actionSpec,userSpec)then       
      local chargesText = API:GetActionCharges(spellID,actionType) 
      local isUsable,notEnoughMana = API:IsUsableAction(spellID,actionType)  
      local start, duration, onCooldown = API:GetActionCooldown(spellID,actionType,slotID)  
      local inRange = API:IsActionInRange(spellID,actionType)       
      widget.charges:SetText(chargesText)          
      if configMode or isBoosted and isUsable==true and notEnoughMana==false and duration <1.5 and inRange==true and globalHideRest==false then      
          widget:Show()                         
      else             
        if isResting and framesHideRest[frameIndex]==true or displayOnlyWhenBoosted or globalHideRest == true and isResting then  
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
    else
      widget:Hide()
    end
  end
  end   
end
function UI:SortBars(trackedActions,sortNumber)
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
              return actionBarsCount
             end,           
             HideInSaveZone = function(self)                                                                                    
              return  globalHideRest
             end,
             FramesScale = function(self)                                                                                                  
             return framesScale
             end,
             FramesPosition = function(self) 
              for i=1,#frames do
                framesPosition[i]=UI:CalculateFramePosition(i)              
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

function UI:SetSavedVariables(loadedFramesPosition,loadedFramesScale,loadedFramesAlpha,loadedFramesColumn,loadedFramesHideRest,loadedActionBarsCount,loadedGlobalHideRest)
 framesPosition = loadedFramesPosition
 framesScale =loadedFramesScale
 framesAlpha = loadedFramesAlpha
 framesColumn = loadedFramesColumn
 framesHideRest = loadedFramesHideRest
 actionBarsCount = loadedActionBarsCount
 globalHideRest = loadedGlobalHideRest
end
-- Revision version v0.9.0 ---


