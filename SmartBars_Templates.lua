--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Templates ={};
local Templates=SmartBars.Templates;
local Config
local UI
local Actions
local ActionBars
--Init------------------------------------
function Templates:Init()
Config = SmartBars.Config
UI = SmartBars.UI
Actions = SmartBars.Actions
ActionBars = SmartBars.ActionBars
end
--XML Variables
-----XML Templates Variables--------------
local defaultFont = "GameFontHighLight"
local defaultLayer = "OVERLAY"
local basicFrameWithInset = "BasicFrameTemplateWithInset"
local defaultButton = "UIPanelButtonTemplate"
local defaultCheckButton = "OptionsCheckButtonTemplate"
--Default values
local defaultFrameScale =0.75
local defaultFrameAlpha = 1
--Templates
function Templates:PrimaryFrame() 
    function Frame()
      local frame = CreateFrame("Frame",nill,nill,basicFrameWithInset,defaultLayer);
      Templates:SetFrameMoveable(frame)  
      frame:Hide()
      frame:SetSize(320,0);
      frame:SetScale(defaultFrameScale)
      frame:SetPoint("CENTER",nill,"CENTER",-450,100);        
      frame.resetButton = CreateFrame("Button", nill, frame,defaultButton)
      frame.resetButton:SetPoint("RIGHT",frame.TitleBg,"RIGHT",-50,0);
      frame.resetButton:SetSize(50,15)
      frame.resetButton:SetNormalFontObject(defaultFont)       
      frame.resetButton:SetText("ResetAll");

      frame.title = frame:CreateFontString(nil,defaultLayer);
      frame.title:SetPoint("LEFT",frame.TitleBg,"LEFT",5,-2);
      frame.title:SetFontObject(defaultFont)
      frame.title:SetText("SmartBars "..Config:GetSmartBarsInfo())
    return frame
    end     
    function StaticTitles()
      local titles = CreateFrame("Frame",nill,UIConfig) 
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
      barsWidget.textStatic:SetPoint("LEFT",barsWidget,"CENTER",-30,0);
      barsWidget.textStatic:SetFontObject(defaultFont)
      barsWidget.textStatic:SetText("Bars:  ");
      barsWidget.textValue = barsWidget:CreateFontString(nil,defaultFont);
      barsWidget.textValue:SetPoint("CENTER",barsWidget,"CENTER",25,0);
      barsWidget.textValue:SetFontObject(defaultFont)
     

      barsWidget.minusButton = CreateFrame("Button",nil, barsWidget,defaultButton,defaultLayer)
      barsWidget.minusButton :SetPoint("CENTER", barsWidget, "CENTER", 5, -25)
      barsWidget.minusButton :SetSize(25,25)
      barsWidget.minusButton :SetText("-")
      barsWidget.minusButton :SetNormalFontObject(defaultFont)  
      barsWidget.minusButton.tooltipText = "Remove last action bar."   
  
      barsWidget.plusButton  = CreateFrame("Button",nil, barsWidget,defaultButton,defaultLayer)
      barsWidget.plusButton:SetPoint("CENTER", barsWidget, "CENTER", 30, -25)
      barsWidget.plusButton:SetSize(25,25)
      barsWidget.plusButton:SetText("+")
      barsWidget.plusButton:SetNormalFontObject(defaultFont)    
      barsWidget.plusButton.tooltipText = "Create new action bar."   
      return barsWidget
    end
    function RestZoneWidget()
      local widget = CreateFrame("Frame",nil) 
      widget:SetSize(35,35)
      widget.checkBox = CreateFrame("CheckButton",nil, widget,defaultCheckButton,defaultLayer)
      widget.checkBox:SetChecked(UI:Get():GlobalHideRest())
      widget.checkBox:SetSize(35,35)
      widget.checkBox:SetPoint("CENTER",widget,"CENTER",30,-30);
      widget.checkBox:SetHitRectInsets(0,0,0,0) 
      widget.checkBox.tooltipText = "Hide all tracked actions in rest zone."    
      widget.title = widget:CreateFontString(nil,defaultLayer);
      widget.title:SetPoint("LEFT",widget,"CENTER",0,0);
      widget.title:SetFontObject(defaultFont)
      widget.title:SetText("Rest zone:")   
      return widget
    end
    local primaryFrame = Frame()
    local primaryOptionsWidgets = {StaticTitles(),RestZoneWidget(),BarsWidget()}   
    local xOfs =0
    for k in pairs(primaryOptionsWidgets) do
      primaryOptionsWidgets[k]:SetPoint("LEFT", primaryFrame.TitleBg, "LEFT",(xOfs), -30)
      primaryOptionsWidgets[k]:SetParent(primaryFrame)
      primaryOptionsWidgets[k]:SetSize(80,80)
        xOfs = xOfs+105
    end   
    return primaryFrame,primaryOptionsWidgets
end
function Templates:ActionBar(index)     
        local actionBar = CreateFrame("Frame",nill,nil);
        function Frame()
        Templates:SetFrameMoveable(actionBar)
        actionBar:SetMovable(true)
        actionBar:SetSize(150,75);
        return actionBar
        end
        function Title()
          local title = CreateFrame("Frame",nill,actionBar,nill,defaultLayer);
          title:SetPoint("CENTER",actionBar,"CENTER",0,-1);   
          title:SetSize(50,20)                         
          title.text = title:CreateFontString(nil,defaultLayer);
          title.text:SetPoint("CENTER",title,"CENTER",-60,0);
          title.text:SetFontObject(defaultFont)
          title.text:SetText("BAR: "..ActionBars:FindIndex(index)) 
        return title
        end
        function Info()
          local info = CreateFrame("Button",nill,actionBar,defaultButton,defaultLayer);
          info:SetPoint("LEFT",actionBar,"Center",10,-1);   
          info:SetSize(20,20)            
          info.tooltipText = "Move - Drag BAR.\nEdit - Set text inside icon.\n"                 
          info.text = info:CreateFontString(nil,defaultLayer);
          info.text:SetPoint("CENTER",info,"CENTER",0,0);
          info.text:SetFontObject(defaultFont)
          info.text:SetText("i")
          return info
        end
        function Edit()
          local edit = CreateFrame("Button",nill,actionBar,defaultButton,defaultLayer);
          edit:SetPoint("LEFT",actionBar,"Center",-40,-1);   
          edit:SetSize(40,20)                 
          edit.text = edit:CreateFontString(nil,defaultLayer);
          edit.text:SetPoint("CENTER",edit,"CENTER",0,0);
          edit.text:SetFontObject(defaultFont)
          edit.text:SetText("Edit")       
          return edit  
        end
        actionBar=Frame()       
        actionBar.configWidgets = {Title(),Edit()}
        for k in pairs(actionBar.configWidgets) do
          actionBar.configWidgets[k]:Hide()
        end
        return actionBar
end 
function Templates:OptionWidget(index)
    local optionWidget = CreateFrame("Frame",nill,nill,basicFrameWithInset,defaultLayer);
    optionWidget:SetPoint("LEFT",UI:Get():PrimaryFrame(),"RIGHT",0,0);   
    optionWidget:SetSize(150,400)         
    optionWidget:Hide() 
    optionWidget:EnableMouse(false)  
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
  
    barNavigator.plusButton = CreateFrame("Button",nil, barNavigator,defaultButton,defaultLayer)
    barNavigator.plusButton:SetPoint("CENTER", barNavigator, "CENTER", 35, 0)
    barNavigator.plusButton:SetSize(25,25)
    barNavigator.plusButton:SetText(">")
    barNavigator.plusButton:SetNormalFontObject(defaultFont)   
    
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
  

   return scaleWidget
   end
   function AlphaSlider()           
     local alphaWidget = CreateFrame("Frame",nill)
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

   columnsWidget.minusButton = CreateFrame("Button", "bs_minus", columnsWidget,defaultButton,defaultLayer)
   columnsWidget.minusButton:SetPoint("LEFT", columnsWidget, "CENTER", 0, -20)
   columnsWidget.minusButton:SetSize(25,25)
   columnsWidget.minusButton:SetText("-")
   columnsWidget.minusButton:SetNormalFontObject(defaultFont)    
   columnsWidget.minusButton.tooltipText = "Decrease horizontal count of actions in bar."   
   columnsWidget.plusButton = CreateFrame("Button",nil, columnsWidget,defaultButton,defaultLayer)
   columnsWidget.plusButton:SetPoint("LEFT", columnsWidget, "CENTER", 22, -20)
   columnsWidget.plusButton:SetSize(25,25)
   columnsWidget.plusButton:SetText("+")
   columnsWidget.plusButton:SetNormalFontObject(defaultFont) 
   columnsWidget.plusButton.tooltipText = "Increase horizontal count of actions in bar."    
   return columnsWidget
   end      
   function RestZoneWidget()
   local restZoneWidget = CreateFrame("Frame",nil) 
   restZoneWidget.checkBox = CreateFrame("CheckButton",nil,restZoneWidget,defaultCheckButton,defaultLayer)
   restZoneWidget.checkBox.tooltipText = "Hide actions in bar in rest zone."
   restZoneWidget.checkBox:SetHitRectInsets(0,0,0,0) 
   restZoneWidget.checkBox:SetSize(35,35)
   restZoneWidget.checkBox:SetPoint("RIGHT",restZoneWidget,"CENTER",50,00);
   restZoneWidget.title = restZoneWidget:CreateFontString(nil,defaultLayer);
   restZoneWidget.title:SetPoint("LEFT",restZoneWidget,"CENTER",-50,0);
   restZoneWidget.title:SetFontObject(defaultFont)
   restZoneWidget.title:SetText("Rest zone: ") 
   local hiderest =ActionBars:Get():FramesHideRest()
   restZoneWidget.checkBox:SetChecked(hiderest[index])
   return restZoneWidget
   end
   function Title()
    local title = optionWidget:CreateFontString(nil,"ARTWORK");
    title:SetPoint("LEFT",optionWidget.TitleBg,"LEFT",0,-2);
    title:SetFontObject(defaultFont)
    title:SetText("Settings")       
  return title   
   end
  optionWidget.settings = {BarNavigator(),ScaleSlider(),AlphaSlider(),ColumnsWidgets(),RestZoneWidget(),Title()}   
  local yOfs =60
  for k in pairs(optionWidget.settings) do
    optionWidget.settings[k]:SetPoint("CENTER", optionWidget, "TOP", 0, (yOfs)*-1)
    optionWidget.settings[k]:SetParent(optionWidget)
    optionWidget.settings[k]:SetSize(50,50)
    yOfs = yOfs+60    
  end
  return optionWidget
end
function Templates:CreateGroupLayout(parentWidget,valueToSave,isDisplayed,key)--Add group layout to desired widget
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
    if ActionBars:FindIndex(valueToSave[6])>1 then
    valueToSave[6] = valueToSave[6]-1
    end
  end)
  newWidget.plusButton = CreateFrame("Button",nill, newWidget,defaultButton,defaultLayer)
  newWidget.plusButton:SetPoint("CENTER", parentWidget, "CENTER", 0, yOfs)
  newWidget.plusButton:SetSize(20,20)
  newWidget.plusButton:SetText("+")
  newWidget.plusButton:SetNormalFontObject(defaultFont)  
  newWidget.plusButton.tooltipText ="Change bar."  
  newWidget.plusButton:SetScript("OnClick", function ()
    if ActionBars:FindIndex(valueToSave[6])< ActionBars:Get():ActionsSpecBarCount(API:GetSpecialization()) then
      valueToSave[6]=valueToSave[6] +1
    end  
  end)
  if not isDisplayed then
    newWidget:Hide()
  end
  return newWidget
end
function Templates:CreateEditBox(parentWidget,valueToSave,isEnabled)--Add editbox with desired text on frame 
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
function Templates:CreateFontString(parentWidget,fontSize,someText)--Add fontstring with desired parameters
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
function Templates:CreateActionWidget(action,parentFrame,isTracked,isEnabled)--Return widget with correct size and textures
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
function Templates:SetFrameMoveable(frame)
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

--Revision v 0.9.8 --
