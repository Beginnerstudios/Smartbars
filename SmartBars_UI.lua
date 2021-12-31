--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.UI ={};
local UI=SmartBars.UI;
local Actions
local Config
--Init------------------------------------
function UI:Init()
Actions = SmartBars.Actions
Config = SmartBars.Config
end
--Variables-------------------------------
--Primary frame
local primaryFrame   
local primaryOptionsWidgets = {}
local globalHideRest = false
local minimumHeight = 350
--ActionBars
local actionBarsCount = 1
local optionWidgets = {}
local frames = {};
local framesPosition = {}--sv
local framesScale = {}--sv
local framesAlpha = {}--sv
local framesColumn ={}--sv
local framesHideRest = {}
local defaultFrameScale =0.75
local defaultFrameAlpha = 1
-----XML Templates Variables--------------
local defaultFont = "GameFontHighLight"
local defaultLayer = "OVERLAY"
local basicFrameWithInset = "BasicFrameTemplateWithInset"
local defaultButton = "UIPanelButtonTemplate"
local defaultCheckButton = "OptionsCheckButtonTemplate"
--UI:Frames-------------------------------
function UI:CreateFrames()--Create primary frame + ActionUpdater frame
  local function PrimaryFrame() 
    function Frame()
      local frame = CreateFrame("Frame",nill,nill,basicFrameWithInset,defaultLayer);
      UI:SetFrameMoveable(frame)  
      frame:Hide()
      frame:SetSize(320,0);
      frame:SetScale(defaultFrameScale)
      frame:SetPoint("CENTER",nill,"CENTER",-450,100);
      frame.CloseButton:SetScript("OnClick", function ()
      Config:ToggleConfigMode()
      end)    
      frame.resetButton = CreateFrame("Button", nill, frame,defaultButton)
      frame.resetButton:SetPoint("RIGHT",frame.TitleBg,"RIGHT",-50,0);
      frame.resetButton:SetSize(50,15)
      frame.resetButton:SetNormalFontObject(defaultFont)       
      frame.resetButton:SetText("ResetAll");
      frame.resetButton:SetScript("OnClick", function ()
        StaticPopup_Show ("SMARTBARS_RESETCONFIRM")  
      end)
   

    return frame
    end     
    function StaticTitles()
      local titles = CreateFrame("Frame",nill,UIConfig) 
      titles.frame = titles:CreateFontString(nil,defaultLayer);
      titles.frame:SetPoint("LEFT",primaryFrame.TitleBg,"LEFT",5,-2);
      titles.frame:SetFontObject(defaultFont)
      local version = Config:GetSmartBarsInfo()
      titles.frame:SetText("SmartBars "..version)

      titles.usedStatic = titles:CreateFontString(nil,defaultLayer);
      titles.usedStatic:SetPoint("LEFT",titles,"LEFT",10,0);
      titles.usedStatic:SetFontObject(defaultFont)
      titles.usedStatic:SetText("Used actions:");
    
      titles.trackedStatic = titles:CreateFontString(nil,defaultLayer);
      titles.trackedStatic:SetPoint("LEFT",titles,"LEFT",10,-20);
      titles.trackedStatic:SetFontObject(defaultFont)
      titles.trackedStatic:SetText("Tracked actions:");

      titles.actionsStatic = titles:CreateFontString(nil,defaultLayer);
      titles.actionsStatic:SetPoint("LEFT",titles,"LEFT",10,-54);
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
    function BarsWidget()
      local barsWidget = CreateFrame("Frame",nil) 
      barsWidget.textStatic = barsWidget:CreateFontString(nil,defaultFont);
      barsWidget.textStatic:SetPoint("LEFT",barsWidget,"CENTER",-10,0);
      barsWidget.textStatic:SetFontObject(defaultFont)
      barsWidget.textStatic:SetText("Bars:  ");
      barsWidget.textValue = barsWidget:CreateFontString(nil,defaultFont);
      barsWidget.textValue:SetPoint("CENTER",barsWidget,"CENTER",25,0);
      barsWidget.textValue:SetFontObject(defaultFont)
      barsWidget.textValue:SetText(actionBarsCount);

      barsWidget.minusButton = CreateFrame("Button",nil, barsWidget,defaultButton,defaultLayer)
      barsWidget.minusButton :SetPoint("CENTER", barsWidget, "CENTER", 0, -30)
      barsWidget.minusButton :SetSize(35,35)
      barsWidget.minusButton :SetText("-")
      barsWidget.minusButton :SetNormalFontObject(defaultFont)  
      barsWidget.minusButton.tooltipText = "Remove last action bar."   
      barsWidget.minusButton :SetScript("OnClick", function ()
      UI:RemoveLastActionBar()
      UI:UpdateUI()
      barsWidget.textValue:SetText(actionBarsCount);
      end) 
      barsWidget.plusButton  = CreateFrame("Button",nil, barsWidget,defaultButton,defaultLayer)
      barsWidget.plusButton:SetPoint("CENTER", barsWidget, "CENTER", 35, -30)
      barsWidget.plusButton:SetSize(35,35)
      barsWidget.plusButton:SetText("+")
      barsWidget.plusButton:SetNormalFontObject(defaultFont)    
      barsWidget.plusButton.tooltipText = "Create new action bar."   
      barsWidget.plusButton:SetScript("OnClick", function ()         
      UI:AddActionBar()                                     
      barsWidget.textValue:SetText(actionBarsCount)
      UI:ToggleWidgets(true)           
      UI:UpdateUI()
      end)
      return barsWidget
    end
    function RestZoneWidget()
      local widget = CreateFrame("Frame",nil) 
      widget:SetSize(35,35)
      widget.checkBox = CreateFrame("CheckButton",nil, widget,defaultCheckButton,defaultLayer)
      widget.checkBox:SetChecked(globalHideRest)
      widget.checkBox:SetSize(35,35)
      widget.checkBox:SetPoint("CENTER",widget,"CENTER",30,-30);
      widget.checkBox:SetHitRectInsets(0,0,0,0) 
      widget.checkBox.tooltipText = "Hide all tracked actions in rest zone." 
      widget.checkBox:SetScript("OnClick",function (self)
      globalHideRest = self:GetChecked()
      UI:UpdateUI()
      end)  
      widget.title = widget:CreateFontString(nil,defaultLayer);
      widget.title:SetPoint("LEFT",widget,"CENTER",0,0);
      widget.title:SetFontObject(defaultFont)
      widget.title:SetText("Rest zone:")   
      return widget
    end
    primaryFrame = Frame()
    primaryOptionsWidgets = {StaticTitles(),RestZoneWidget(),BarsWidget()}   
    local xOfs =0
    for k in pairs(primaryOptionsWidgets) do
      primaryOptionsWidgets[k]:SetPoint("LEFT", primaryFrame.TitleBg, "LEFT",(xOfs), -30)
      primaryOptionsWidgets[k]:SetParent(primaryFrame)
      primaryOptionsWidgets[k]:SetSize(80,80)
        xOfs = xOfs+105
    end
    return primaryFrame
  end
  function ActionsUpdater()
    local frameholder = CreateFrame("Frame",nil,nil);
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
 ActionsUpdater()
end
function UI:CreateActionBar(index)--Create action bar + option widgets
    local function ActionBar()
    local actionBar = CreateFrame("Frame",nill,nil);
    function Frame()
    UI:SetFrameMoveable(actionBar)
    actionBar:SetMovable(true)
    actionBar:SetSize(150,75);
    end
    function Title()
      actionBar.title = actionBar:CreateFontString(nil,"ARTWORK");
      actionBar.title:SetPoint("LEFT",actionBar,"LEFT",0,-1);
      actionBar.title:SetFontObject(defaultFont)    
      actionBar.title:SetText("BAR: "..index)   
      actionBar.title:SetAlpha(0)  
    end
    function Info()
      actionBar.info = CreateFrame("Button",nill,actionBar,defaultButton,defaultLayer);
      actionBar.info:SetPoint("LEFT",actionBar,"Center",10,-1);   
      actionBar.info:SetSize(20,20)    
    
        actionBar.info.tooltipText = "Move - Drag BAR.\nEdit - Set text inside icon.\n"
      
      actionBar.info:SetAlpha(0)
      actionBar.info.text = actionBar.info:CreateFontString(nil,"BORDER");
      actionBar.info.text:SetPoint("CENTER",actionBar.info,"CENTER",0,0);
      actionBar.info.text:SetFontObject(defaultFont)
      actionBar.info.text:SetText("i")
    end
    function Edit()
      actionBar.edit = CreateFrame("Button",nill,actionBar,defaultButton,defaultLayer);
      actionBar.edit:SetPoint("LEFT",actionBar,"Center",-25,-1);   
      actionBar.edit:SetSize(40,20)         
      actionBar.edit:SetAlpha(0)
      actionBar.edit.text = actionBar.edit:CreateFontString(nil,"BORDER");
      actionBar.edit.text:SetPoint("CENTER",actionBar.edit,"CENTER",0,0);
      actionBar.edit.text:SetFontObject(defaultFont)
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
      actionBar.optionWidget = CreateFrame("Frame",nill,actionBar,basicFrameWithInset,defaultLayer);
      actionBar.optionWidget:SetPoint("LEFT",primaryFrame,"RIGHT",0,107);   
      actionBar.optionWidget:SetSize(150,minimumHeight)         
      actionBar.optionWidget:Hide() 
      actionBar.optionWidget:SetParent(primaryFrame)
      actionBar.optionWidget:EnableMouse(false)
      actionBar.optionWidget.CloseButton:SetScript("OnClick", function ()
        Config:ToggleConfigMode()
        end) 
     
    
  
      
      function BarNavigator()
        local barNavigator = CreateFrame("Frame",nil,nil,nil,defaultLayer)       
        barNavigator.text = barNavigator:CreateFontString(nil,defaultLayer);
        barNavigator.text:SetPoint("CENTER",barNavigator,"CENTER",0,0);
        barNavigator.text:SetFontObject(defaultFont)
        barNavigator.text:SetText("Bar: "..index);
        barNavigator.text2 = barNavigator:CreateFontString(nil,defaultLayer);
        barNavigator.text2:SetPoint("CENTER",barNavigator,"CENTER",-15,0);
        barNavigator.text2:SetFontObject(defaultFont)
       -- columnsWidget.text2:SetText(framesColumn[index][1]);    
       barNavigator.minusButton = CreateFrame("Button", "bs_minus", barNavigator,defaultButton,defaultLayer)
       barNavigator.minusButton:SetPoint("CENTER", barNavigator, "CENTER", -35, 0)
       barNavigator.minusButton:SetSize(25,25)
       barNavigator.minusButton:SetText("<")
       barNavigator.minusButton:SetNormalFontObject(defaultFont)    
       barNavigator.minusButton:SetScript("OnClick", function ()
       if index>=2 then
         UI:HideOptionPanels()
         frames[index-1].optionWidget:Show()
         optionWidgets[index-1][1].text:SetText("Bar: "..index-1);
       elseif index ==1 then
        UI:HideOptionPanels()
         frames[#frames].optionWidget:Show()
         optionWidgets[#frames][1].text:SetText("Bar: "..#frames);

       end
        end)   
        barNavigator.plusButton = CreateFrame("Button",nil, barNavigator,defaultButton,defaultLayer)
        barNavigator.plusButton:SetPoint("CENTER", barNavigator, "CENTER", 35, 0)
        barNavigator.plusButton:SetSize(25,25)
        barNavigator.plusButton:SetText(">")
        barNavigator.plusButton:SetNormalFontObject(defaultFont)   
        barNavigator.plusButton:SetScript("OnClick", function ()
          if index<#frames then
            UI:HideOptionPanels()
            frames[index+1].optionWidget:Show()
            optionWidgets[index+1][1].text:SetText("Bar: "..index+1);
          elseif index==#frames then
            UI:HideOptionPanels()
            frames[1].optionWidget:Show()
            optionWidgets[1][1].text:SetText("Bar: 1");
          end
        end)
        return barNavigator
      end
       function ScaleSlider()           
         local scaleWidget = CreateFrame("Frame",nil)
         scaleWidget.title = scaleWidget:CreateFontString(nil,defaultLayer);
         scaleWidget.title:SetPoint("LEFT",scaleWidget,"CENTER",-50,0);
         scaleWidget.title:SetFontObject(defaultFont)
         scaleWidget.title:SetText("Scale:")  
         scaleWidget.slider = CreateFrame("Slider",nil, scaleWidget,"OptionsSliderTemplate")
         scaleWidget.slider:SetPoint("CENTER",scaleWidget,"CENTER",0,-20);
         scaleWidget.slider:SetWidth(100)
         scaleWidget.slider:SetHeight(15)
         scaleWidget.slider:SetMinMaxValues(0.5,1.5)
         scaleWidget.text = scaleWidget:CreateFontString(nil,defaultLayer);
         scaleWidget.text:SetPoint("CENTER",scaleWidget.title,"CENTER",75,0);
         scaleWidget.text:SetFontObject(defaultFont)
         scaleWidget.slider:SetStepsPerPage(10)      
         scaleWidget.slider:SetScript("OnValueChanged", function (self) 
         frames[index]:SetScale(self:GetValue())  
         framesScale[index] = self:GetValue()      
         scaleWidget.text:SetText(Config:RoundNumber(framesScale[index],2));      
       end)   
   
       return scaleWidget
       end
       function AlphaSlider()           
         local alphaWidget = CreateFrame("Frame", "dasd")
         alphaWidget.title = alphaWidget:CreateFontString(nil,defaultLayer);
         alphaWidget.title:SetPoint("LEFT",alphaWidget,"CENTER",-50,0);
         alphaWidget.title:SetFontObject(defaultFont)
         alphaWidget.title:SetText("Alpha:  ")  
         alphaWidget.slider = CreateFrame("Slider", "myslider", alphaWidget,"OptionsSliderTemplate")
         alphaWidget.slider:SetPoint("CENTER",alphaWidget,"CENTER",0,-20);
         alphaWidget.slider:SetWidth(100)
         alphaWidget.slider:SetHeight(15)
         alphaWidget.slider:SetMinMaxValues(0.3,1)
         alphaWidget.text = alphaWidget:CreateFontString(nil,defaultLayer);
         alphaWidget.text:SetPoint("CENTER",alphaWidget.title,"CENTER",70,0);
         alphaWidget.text:SetFontObject(defaultFont)
         
         
         alphaWidget.slider:SetStepsPerPage(10)             
         
         alphaWidget.slider:SetScript("OnValueChanged", function (self)  
         frames[index]:SetAlpha(self:GetValue()) 
         framesAlpha[index] = self:GetValue() 
         alphaWidget.text:SetText(Config:RoundNumber(framesAlpha[index],2));    
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

       columnsWidget.minusButton = CreateFrame("Button", "bs_minus", columnsWidget,defaultButton,defaultLayer)
       columnsWidget.minusButton:SetPoint("LEFT", columnsWidget, "CENTER", 0, -20)
       columnsWidget.minusButton:SetSize(25,25)
       columnsWidget.minusButton:SetText("-")
       columnsWidget.minusButton:SetNormalFontObject(defaultFont)    
       columnsWidget.minusButton.tooltipText = "Decrease horizontal count of actions in bar."  
       columnsWidget.minusButton:SetScript("OnClick", function ()
       if framesColumn[index]>= 2 then
        framesColumn[index] = framesColumn[index] -1
        columnsWidget.text2:SetText(framesColumn[index])
       end
       end)   
       columnsWidget.plusButton = CreateFrame("Button",nil, columnsWidget,defaultButton,defaultLayer)
       columnsWidget.plusButton:SetPoint("LEFT", columnsWidget, "CENTER", 22, -20)
       columnsWidget.plusButton:SetSize(25,25)
       columnsWidget.plusButton:SetText("+")
       columnsWidget.plusButton:SetNormalFontObject(defaultFont) 
       columnsWidget.plusButton.tooltipText = "Increase horizontal count of actions in bar."    
       columnsWidget.plusButton:SetScript("OnClick", function ()
       
         framesColumn[index] = framesColumn[index] +1
         columnsWidget.text2:SetText(framesColumn[index])
       
       end)
       return columnsWidget
       end      
       function RestZoneWidget()
       local restZoneWidget = CreateFrame("Frame",nil) 
       restZoneWidget.checkBox = CreateFrame("CheckButton",nil,restZoneWidget,defaultCheckButton,defaultLayer)
       restZoneWidget.checkBox.tooltipText = "Hide actions in bar in rest zone."
       restZoneWidget.checkBox:SetHitRectInsets(0,0,0,0) 
       restZoneWidget.checkBox:SetChecked(framesHideRest[index])
       restZoneWidget.checkBox:SetSize(35,35)
       restZoneWidget.checkBox:SetPoint("RIGHT",restZoneWidget,"CENTER",50,00);
      
       restZoneWidget.checkBox:SetScript("OnClick",function (self)
        framesHideRest[index] = self:GetChecked()
        UI:UpdateUI()
       end)  
       restZoneWidget.title = restZoneWidget:CreateFontString(nil,defaultLayer);
       restZoneWidget.title:SetPoint("LEFT",restZoneWidget,"CENTER",-50,0);
       restZoneWidget.title:SetFontObject(defaultFont)
       restZoneWidget.title:SetText("Rest zone: ")   
       return restZoneWidget
       end
       function Title()
        local title = actionBar.optionWidget:CreateFontString(nil,"ARTWORK");
        title:SetPoint("LEFT",actionBar.optionWidget.TitleBg,"LEFT",0,-2);
        title:SetFontObject(defaultFont)
        title:SetText("Settings")       
      return title   
      end
      optionWidgets[index] = {BarNavigator(),ScaleSlider(),AlphaSlider(),ColumnsWidgets(),RestZoneWidget(),Title()}   
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
function UI:SetupSettings(i)--Setup variables for action bar position,scale etc..
  ---Position
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
      optionWidgets[i][2].slider:SetValue(defaultFrameScale)
      optionWidgets[i][2].text:SetText(Config:RoundNumber(defaultFrameScale,2))
    else
      local scale = framesScale[i] 
      frames[i]:SetScale(scale)
      optionWidgets[i][2].slider:SetValue(scale)
      optionWidgets[i][2].text:SetText(Config:RoundNumber(scale,2))
    end 
  end
  function Alpha()
    if not framesAlpha[i]  then
      frames[i]:SetAlpha(defaultFrameAlpha)
      optionWidgets[i][3].slider:SetValue(defaultFrameAlpha)
      optionWidgets[i][3].text:SetText(Config:RoundNumber(defaultFrameAlpha,2))
    else
      local alpha = framesAlpha[i]
      frames[i]:SetAlpha(alpha)
      optionWidgets[i][3].slider:SetValue(alpha)
      optionWidgets[i][3].text:SetText(Config:RoundNumber(alpha,2))
    end 
  end
  function Columns()
    if not framesColumn[i]  then
      framesColumn[i] = 10
      optionWidgets[i][4].text2:SetText(framesColumn[i])
    else
      optionWidgets[i][4].text2:SetText(framesColumn[i])
    end
  end
  function Hide()
    if not framesHideRest[i]  then    
      optionWidgets[i][5].checkBox:SetChecked(false)
     else
       local value = framesHideRest[i]
       optionWidgets[i][5].checkBox:SetChecked(value)
     end
  end
  Position()
  Scale()
  Alpha()
  Columns()
  Hide()
end
function UI:RemoveLastActionBar()
  if frames then 
    if #frames >1 then
      local lastIndex = #frames
      frames[#frames]:Hide()  
      UI:HideOptionPanels()
      frames[#frames-1].optionWidget:Show()
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
  if #frames < 30 then
  UI:CreateActionBar(#frames+1)
  UI:SetupSettings(#frames)
  UI:ToggleWidgets(true)
  actionBarsCount = actionBarsCount +1
  end
end
function UI:MoveActionWidgets(trackedAction,value)
  trackedAction[6] = trackedAction[6] +(value)
  trackedAction[3]:SetParent(frames[trackedAction[6]])
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
 local actionWidget = CreateFrame("CheckButton",nil, parentFrame, defaultCheckButton,defaultLayer)
 actionWidget:SetPoint("LEFT",parentFrame,"LEFT",0,0)
 actionWidget:SetHitRectInsets(0,0,0,0) 
 actionWidget:SetWidth(50)
 actionWidget:SetHeight(50) 
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
  local edit = CreateFrame("EditBox",nil, parentWidget,nill,defaultLayer)
  edit:SetPoint("CENTER",parentWidget,"CENTER",2,0)
  edit:SetSize(50,50)
  edit:SetText(valueToSave[4])
  edit:SetAutoFocus(false)
  edit:SetMaxLetters(3)
  edit.tooltipText ="Change bar."  
  edit:SetEnabled(isEnabled)
  edit:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE")
  edit:SetScript("OnEditFocusLost", function (self)             
  valueToSave[4] = self:GetText() 
  end)
  return edit
end
function UI:CreateFontString(parentWidget,fontSize,someText)--Add fontstring with desired parameters
local fontString =parentWidget:CreateFontString(nil,defaultLayer);
fontString:SetPoint("RIGHT",parentWidget,"CENTER",22,-17);
fontString:SetFont("Fonts\\FRIZQT__.TTF",fontSize,nil)
if not someText then
  fontString:SetText("");
else
  fontString:SetText(someText) 
end
return fontString
end
function UI:CreateGroupLayout(parentWidget,valueToSave,isDisplayed)--Add group layout to desired widget
local yOfs = -15
local newWidget = CreateFrame("Frame",nill, parentWidget)
newWidget:SetPoint("CENTER",parentWidget,"CENTER",0,0);

newWidget.barNumberText =newWidget:CreateFontString(nil,defaultLayer);
newWidget.barNumberText:SetPoint("CENTER",parentWidget,"CENTER",17,-17);
newWidget.barNumberText:SetFont("Fonts\\FRIZQT__.TTF", 15,"OUTLINE")
--newWidget.barNumberText:SetText(valueToSave[6]);
if Config:IsCurrentPatch() then
newWidget.showWhenBoosted = CreateFrame("CheckButton", nil, newWidget,defaultCheckButton,defaultLayer)
newWidget.showWhenBoosted:SetHitRectInsets(0,0,0,0) 
newWidget.showWhenBoosted:SetPoint("CENTER", parentWidget, "CENTER", 18,18)
newWidget.showWhenBoosted:SetSize(20,20)
newWidget.showWhenBoosted:SetChecked(valueToSave[8])
newWidget.showWhenBoosted:SetNormalFontObject(defaultFont)
newWidget.showWhenBoosted.tooltipText = "Check if you want display this spell only when BOOSTED."   
newWidget.showWhenBoosted:SetScript("OnClick", function (self) 
valueToSave[8]=self:GetChecked()
end)
end



newWidget.minusButton = CreateFrame("Button",nill, newWidget,defaultButton,defaultLayer)
newWidget.minusButton:SetPoint("CENTER", parentWidget, "CENTER", -15,yOfs)
newWidget.minusButton:SetSize(20,20)
newWidget.minusButton:SetText("-")
newWidget.minusButton.tooltipText ="Change bar."
newWidget.minusButton:SetNormalFontObject(defaultFont)    
newWidget.minusButton:SetScript("OnClick", function () 
  if  valueToSave[6]>1 then
  UI:MoveActionWidgets(valueToSave,-1)
  end
  UI:UpdateUI()
end)
newWidget.plusButton = CreateFrame("Button",nill, newWidget,defaultButton,defaultLayer)
newWidget.plusButton:SetPoint("CENTER", parentWidget, "CENTER", 0, yOfs)
newWidget.plusButton:SetSize(20,20)
newWidget.plusButton:SetText("+")
newWidget.plusButton:SetNormalFontObject(defaultFont)  
newWidget.plusButton.tooltipText ="Change bar."  
newWidget.plusButton:SetScript("OnClick", function ()
  if valueToSave[6]< actionBarsCount then
    UI:MoveActionWidgets(valueToSave,1)
  end  
  UI:UpdateUI()
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
    UI:HideOptionPanels()
   end
  end
  
  end
  for i=1,#frames do
    frames[i]:SetMovable(value) 
    frames[i]:EnableMouse(value) 
    
      if value == true then
        frames[i].title:SetAlpha(1) 
        frames[i].info:Show() 
        frames[i].info:SetAlpha(1) 
        frames[i].edit:SetAlpha(1)         
      else
        frames[i].title:SetAlpha(0) 
        frames[i].info:Hide() 
        frames[i].info:SetAlpha(0) 
        frames[i].edit:SetAlpha(0) 
      end
  end
  UI:HideOptionPanels()
  frames[#frames].optionWidget:Show()
end
function UI:HideOptionPanels()
  for index in pairs(frames) do
    frames[index].optionWidget:Hide()
  end
end
function UI:CreatePopUp()
end
--UI:Update-------------------------------
function UI:UpdateUI() ---update all dynamic variables in UI 
UI:SetupPrimaryFrame()
UI:RefreshTrackedIcons()
Config:SaveConfig()
end
function UI:SetupPrimaryFrame() --handle height of primary frame and primary options widgets + update values for used/tracked actions
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
    primaryFrameHeight = minimumHeight
    else 
    primaryFrameHeight = actionsHeight  
  end
  primaryFrame:SetHeight(primaryFrameHeight)

end
function UI:RefreshTrackedIcons()--update icons on tracked actions
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
function UI:SetSavedVariables(loadedFramesPosition,loadedFramesScale,loadedFramesAlpha,loadedFramesColumn,loadedFramesHideRest,loadedActionBarsCount,loadedGlobalHideRest)--set saved variables
 framesPosition = loadedFramesPosition
 framesScale =loadedFramesScale
 framesAlpha = loadedFramesAlpha
 framesColumn = loadedFramesColumn
 framesHideRest = loadedFramesHideRest
 actionBarsCount = loadedActionBarsCount
 globalHideRest = loadedGlobalHideRest
end
-- Revision version v0.9.6 ---


