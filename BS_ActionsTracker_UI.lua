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
local displayedActions={};
local trackedActionsColumnCount=0 --SV
local trackedSpellsFramePosition ={};--SV
local trackedActionsFrameScale =0--SV
local trackedActionsFrameCount = 1--SV
local maximumTrackedBars =5

--UI:Frames-------------------------------
function UI:CreatePrimaryFrame()  --create primary/secondary frame config/trackedaction bars 
  local function PrimaryFrame()
    local defaultFont = "GameFontHighlight"
   
      function Frame()
    local primaryFrame = CreateFrame("Frame","BS_ActionsTracker.Primary",UIParent,"BasicFrameTemplateWithInset");
    UI:SetFrameMoveable(primaryFrame)  
    primaryFrame:Hide()
    primaryFrame:SetSize(630,0);
    primaryFrame:SetPoint("CENTER",UIParent,"CENTER",-200,100);
    primaryFrame.CloseButton:SetScript("OnClick", function ()
    Config:ToggleConfigMode()
    end)
    return primaryFrame
      end
      
      function StaticTitles(parentFrame)
       UIConfig = parentFrame
       local titles = CreateFrame("Frame","BS_ActionsTracker.Primary",UIConfig) 
       titles.frame = titles:CreateFontString(nil,"OVERLAY");
       titles.frame:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",5,-2);
       titles.frame:SetFontObject(defaultFont)
       titles.frame:SetText("BS_ActionsTracker");

       titles.usedStatic = titles:CreateFontString(nil,"OVERLAY");
       titles.usedStatic:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-40);
       titles.usedStatic:SetFontObject(defaultFont)
       titles.usedStatic:SetText("Used actions:");
    
       titles.trackedStatic = titles:CreateFontString(nil,"OVERLAY");
       titles.trackedStatic:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-60);
       titles.trackedStatic:SetFontObject(defaultFont)
       titles.trackedStatic:SetText("Tracked actions:");

       titles.actionsStatic = titles:CreateFontString(nil,"ARTWORK");
       titles.actionsStatic:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-80);
       titles.actionsStatic:SetFontObject(defaultFont)
       titles.actionsStatic:SetText("Used actions in action bars:");
       
       titles.trackedValue = titles:CreateFontString(nil,"OVERLAY");
       titles.trackedValue:SetPoint("LEFT",titles.trackedStatic,"LEFT",100,0);
       titles.trackedValue:SetFontObject(defaultFont)
       titles.trackedValue:SetText("0");
       
       titles.usedValue = titles:CreateFontString(nil,"OVERLAY");
       titles.usedValue:SetPoint("LEFT",titles.usedStatic,"LEFT",100,0);
       titles.usedValue:SetFontObject(defaultFont)
       titles.usedValue:SetText("0");
       return titles
      end
      function ResetButton(parentFrame)
      -- RESET ACTION BUTTON ---
      UIConfig = parentFrame
      local resetButton = CreateFrame("Button", "only_for_testing", UIConfig,"UIPanelButtonTemplate")
      resetButton:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", -120, -60)
      resetButton:SetWidth(70)
      resetButton:SetHeight(35)
      resetButton:SetText("Reset all")
      resetButton:SetNormalFontObject(defaultFont)
      --Reset button events----
      resetButton:SetScript("OnClick", function ()
      Config:ResetAll()
      end)
      return resetButton
      end
      function ScaleSlider(parentFrame)
        UIConfig = parentFrame
      local slider = CreateFrame("Slider", "myslider", UIConfig,"OptionsSliderTemplate")
      slider:SetPoint("RIGHT", UIConfig.TitleBg, "RIGHT", 00, -50)
      slider:SetWidth(100)
      slider:SetHeight(15)
      slider:SetMinMaxValues(0.5,1.5)
      slider:SetValue(trackedActionsFrameScale)
      slider:SetStepsPerPage(10)      
      slider:SetScript("OnValueChanged", function (self) 
        for i=1,#frames do
      frames[i]:SetScale(self:GetValue())   
        end    
      end)
      getglobal(slider:GetName() .. 'Low'):SetText('0,5'); --Sets the left-side slider text (default is "Low").
      getglobal(slider:GetName() .. 'High'):SetText('1,5'); --Sets the right-side slider text (default is "High").
      getglobal(slider:GetName() .. 'Text'):SetText('Scale'); --Sets the "title" text (top-centre of slider).
      return slider
      end
      function ColumnsWidgets(parentFrame)
        UIConfig = parentFrame
      local columnsWidget = CreateFrame("Frame","BS_ActionsTracker.Primary",UIConfig) 
      columnsWidget.text = columnsWidget:CreateFontString(nil,"ARTWORK");
      columnsWidget.text:SetPoint("CENTER",UIConfig.TitleBg,"CENTER",-30,-30);
      columnsWidget.text:SetFontObject(defaultFont)
      columnsWidget.text:SetText("Columns: ");
      columnsWidget.text = UIConfig:CreateFontString(nil,"ARTWORK");
      columnsWidget.text:SetPoint("CENTER",UIConfig.TitleBg,"CENTER",10,-30);
      columnsWidget.text:SetFontObject(defaultFont)
      columnsWidget.text:SetText(trackedActionsColumnCount);
     
      columnsWidget.minusButton = CreateFrame("Button", "bs_minus", UIConfig,"UIPanelButtonTemplate")
      columnsWidget.minusButton:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", -35, -60)
      columnsWidget.minusButton:SetSize(35,35)
      columnsWidget.minusButton:SetText("-")
      columnsWidget.minusButton:SetNormalFontObject(defaultFont)    
      columnsWidget.minusButton:SetScript("OnClick", function ()
      if trackedActionsColumnCount>= 2 then
        trackedActionsColumnCount = trackedActionsColumnCount -1
        columnsWidget.text:SetText(trackedActionsColumnCount)
      end
      end)
     
      columnsWidget.plusButton = CreateFrame("Button", "bs_plus", UIConfig,"UIPanelButtonTemplate")
      columnsWidget.plusButton:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", 0, -60)
      columnsWidget.plusButton:SetSize(35,35)
      columnsWidget.plusButton:SetText("+")
      columnsWidget.plusButton:SetNormalFontObject(defaultFont)    
      columnsWidget.plusButton:SetScript("OnClick", function ()
      if trackedActionsColumnCount<= 12 then
        trackedActionsColumnCount = trackedActionsColumnCount +1
        columnsWidget.text:SetText(trackedActionsColumnCount)
      end
      end)
      return columnsWidget
      end
      function BarsWidget(parentFrame)
        UIConfig = parentFrame
        local barsWidget = CreateFrame("Frame","BS_ActionsTracker.Primary",UIConfig) 
        barsWidget.textStatic = barsWidget:CreateFontString(nil,"ARTWORK");
        barsWidget.textStatic:SetPoint("CENTER",UIConfig.TitleBg,"CENTER",120,-30);
        barsWidget.textStatic:SetFontObject(defaultFont)
        barsWidget.textStatic:SetText("Tracked bars: ");
        barsWidget.textValue = UIConfig:CreateFontString(nil,"ARTWORK");
        barsWidget.textValue:SetPoint("CENTER",UIConfig.TitleBg,"CENTER",170,-30);
        barsWidget.textValue:SetFontObject(defaultFont)
        barsWidget.textValue:SetText(trackedActionsFrameCount);
        barsWidget.minusButton = CreateFrame("Button", "bs_minus", UIConfig,"UIPanelButtonTemplate")
        barsWidget.minusButton :SetPoint("CENTER", UIConfig.TitleBg, "CENTER", 115, -60)
        barsWidget.minusButton :SetSize(35,35)
        barsWidget.minusButton :SetText("-")
        barsWidget.minusButton :SetNormalFontObject(defaultFont)    
        barsWidget.minusButton :SetScript("OnClick", function ()
        if trackedActionsFrameCount>= 2 then
          trackedActionsFrameCount = trackedActionsFrameCount -1  
          UI:RemoveLastSecondaryFrame()
          barsWidget.textValue:SetText(trackedActionsFrameCount)      
        end
        end)
  
        barsWidget.plusButton  = CreateFrame("Button", "bs_plus", UIConfig,"UIPanelButtonTemplate")
        barsWidget.plusButton:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", 155, -60)
        barsWidget.plusButton:SetSize(35,35)
        barsWidget.plusButton:SetText("+")
        barsWidget.plusButton:SetNormalFontObject(defaultFont)    
        barsWidget.plusButton:SetScript("OnClick", function ()
        
          if trackedActionsFrameCount<maximumTrackedBars then
            trackedActionsFrameCount = trackedActionsFrameCount+1        
            UI:CreateTrackedActionBar(#frames+1) 
            UI:SetFrameFramePosition(#frames)                                        
            barsWidget.textValue:SetText(#frames)
            UI:ShowSecondaryFrames()           
          end
       
        end)
  
  
  
      end
     
      local primaryFrame = Frame()
      primaryFrame.titles = StaticTitles(primaryFrame)
      primaryFrame.resetButton =ResetButton(primaryFrame)
      primaryFrame.scaleSlider =ScaleSlider(primaryFrame)
      primaryFrame.columnsWidget =ColumnsWidgets(primaryFrame)
      primaryFrame.barsWidget = BarsWidget(primaryFrame)        
      return primaryFrame
  end
  primaryFrame = PrimaryFrame()
  secondaryFrame = CreateFrame("Frame","BS_ActionsTracker.secondaryFrame",UIParent);
  secondaryFrame:SetPoint("CENTER",primaryFrame,"CENTER",0,-200);
  secondaryFrame:SetScript("OnUpdate", function ()
    UI:UpdateTrackedActions(Actions:GetTrackedActions())
    end)
end
function UI:CreateTrackedActionBar(index)
  local function SecondaryFrame()
    SecondaryFrame = CreateFrame("Frame","BS_ActionsTracker.Secondary",UIParent);
    function Frame()
    SecondaryFrame:SetScale(trackedActionsFrameScale)
    UI:SetFrameMoveable(SecondaryFrame)
    SecondaryFrame:SetMovable(false)
    SecondaryFrame:SetSize(150,75);
    SecondaryFrame:SetPoint("CENTER",secondaryFrame,"CENTER",0,-200);
    end
    function Title()
    SecondaryFrame.title = SecondaryFrame:CreateFontString(nil,"OVERLAY");
    SecondaryFrame.title:SetPoint("CENTER",SecondaryFrame,"CENTER",25,0);
    SecondaryFrame.title:SetFontObject("GameFontHighlight")
    SecondaryFrame.title:SetText("BAR: "..index .." - move ,edit text,change bar")   
    SecondaryFrame.title:SetAlpha(0)
     --SECONDARY FRAME -EVENTS   
    end
    Frame()
    Title()
    return SecondaryFrame
  end 
  frames[#frames+1] = SecondaryFrame()
end
function UI:RemoveLastSecondaryFrame()
local actions = Actions:GetTrackedActions()
if frames[#frames] ~=nill then
frames[#frames]:Hide()  
end
for k,v in pairs(Actions:GetTrackedActions()) do
  if actions[k][6] == #frames then
    actions[k][6]= trackedActionsFrameCount
    actions[k][3]:SetParent(UI:GetActionBar(trackedActionsFrameCount))
    actions[k][3].group.columnsText2:SetText(Actions:GetTrackedActions()[k][6])
  end
end
frames[trackedActionsFrameCount+1] = nill
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
function UI:ShowSecondaryFrames()
  for i=1,#frames do
  UI:GetActionBar(i):SetMovable(true) 
  UI:GetActionBar(i):EnableMouse(true) 
  UI:GetActionBar(i).title:SetAlpha(1)    
  UI:GetActionBar(i):Show()
  end
end
function UI:HideSecondaryFrames()
  for i=1,#frames do
  UI:GetActionBar(i):SetMovable(false) 
  UI:GetActionBar(i):EnableMouse(false) 
  UI:GetActionBar(i).title:SetAlpha(0)    
  end
end
--UI:Actions-------------------------------
function UI:DisplayActions(actions,frame) --Create widgets for selected actions under selected frame parent
  local xOffstet = 0;
  local yOffset = -20;
  local count = 0

  if displayedActions~=nill then
    for k,v in pairs(displayedActions) do
      if displayedActions[k]~=nill then
      displayedActions[k][3]:Hide()
      displayedActions[k][3] = nill
      end
    end
  end
  for k,v in pairs(actions) do
   
    actions[k][3]=UI:CreateActionWidget(actions[k],frame,false)
    actions[k][3]:SetPoint("LEFT",frame.TitleBg,"LEFT",xOffstet+10,yOffset-100);
    xOffstet = xOffstet+50;
     count = count +1
   --Next line after 12 spells
    if(count==12) then
    yOffset = yOffset -75;
    xOffstet = 0;
    count=0
    end
    --Compare widgets with tracked actions
    for q,v in pairs(Actions:GetActions():Tracked()[1]) do
    if actions[k][2] == v[2] and v[5] == Actions:GetCurrentSpecialization() then
      actions[k][3]:SetChecked(true)
     end
    end
    -- ACTION WIDGETS -- EVENTS
    actions[k][3]:SetScript("OnClick",function (self) 
    Actions:AddTrackedAction(actions[k]) end)
  end  
displayedActions = actions
 UI:UpdateUI()
end
--UI:Widgets-------------------------------
function UI:CreateActionWidget(action,parentFrame,isTracked)--Return widget with correct size and textures
 local actionWidget = CreateFrame("CheckButton",nil, parentFrame, "UICheckButtonTemplate")
 actionWidget:SetWidth(50)
 actionWidget:SetHeight(50)
 local newTexture= API:GetActionTexture(action[1])
 if isTracked then
  actionWidget:SetWidth(50)
  actionWidget:SetHeight(50)
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
  local edit = CreateFrame("EditBox",nil, parentWidget, "UICheckButtonTemplate")
  edit:SetPoint("CENTER",UIParent,"CENTER",0,0)
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
function UI:CreateGroupLayout(parentWidget,valueToSave,isDisplayed)
local xOfs = 0
local yOfs = -25
local defaultFont = "GameFontHighlight"
local newWidget = CreateFrame("Frame", "bs_newpg", parentWidget)
newWidget:SetPoint("CENTER",parentWidget,"CENTER",0,0);

newWidget.columnsText2 =newWidget:CreateFontString(nil,"ARTWORK");
newWidget.columnsText2:SetPoint("CENTER",parentWidget,"CENTER",15,yOfs);
newWidget.columnsText2:SetFontObject(defaultFont)
newWidget.columnsText2:SetText(valueToSave[6]);

newWidget.minusButton = CreateFrame("Button", "bs_minus2", newWidget,"UIPanelButtonTemplate")
newWidget.minusButton:SetPoint("CENTER", parentWidget, "CENTER", -15,yOfs)
newWidget.minusButton:SetSize(20,20)
newWidget.minusButton:SetText("-")
newWidget.minusButton:SetNormalFontObject(defaultFont)    
newWidget.minusButton:SetScript("OnClick", function () 
  if  valueToSave[6]>1 then
  valueToSave[6] = valueToSave[6]-1
  newWidget.columnsText2:SetText(valueToSave[6]);
  end
end)
newWidget.plusButton = CreateFrame("Button", "bs_plus2", newWidget,"UIPanelButtonTemplate")
newWidget.plusButton:SetPoint("CENTER", parentWidget, "CENTER", 0, yOfs)
newWidget.plusButton:SetSize(20,20)
newWidget.plusButton:SetText("+")
newWidget.plusButton:SetNormalFontObject(defaultFont)    
newWidget.plusButton:SetScript("OnClick", function ()
  if valueToSave[6]< trackedActionsFrameCount then
  valueToSave[6] = valueToSave[6]+1
  newWidget.columnsText2:SetText(valueToSave[6]);
  end  
end)
if not isDisplayed then
  newWidget:Hide()
end
return newWidget
end
function UI:ToggleEditbox(value)--Toggle edit boxes for edit in tracked actions
  for k,v in pairs(Actions:GetActions():Tracked()[1]) do
   if v[3]~=nill then
   v[3].edit:SetEnabled(value) 
   if value == true then
    v[3].group:Show()
   else
    v[3].group:Hide()
   end
  end
end
  

end
--UI:Update-----------------------------------
function UI:UpdateUI() ---update all dynamic variables in UI
local trackedSpellsCount = Actions:GetActions().Tracked()[2];
local usedSpellsCount = Actions:GetActions().Used()[2];
  --Header Primary frame dynamic values
  primaryFrame.titles.usedValue:SetText(usedSpellsCount)
  primaryFrame.titles.trackedValue:SetText(trackedSpellsCount)
  --Secondary Frame size
  for i=1,#frames do
  UI:SetFrameFramePosition(i)
  end


if usedSpellsCount<12 then
  primaryFrame:SetHeight(400)
else
  primaryFrame:SetHeight(usedSpellsCount/12+3*140)
end



 UI:RefreshTrackedIcons(Actions:GetTrackedActions())
end
function UI:SetFrameFramePosition(frameIndex)
local i = frameIndex  
local xOffset = trackedSpellsFramePosition[i][1] 
local yOffset = trackedSpellsFramePosition[i][2]
local point = trackedSpellsFramePosition[i][3]
local relativePoint = trackedSpellsFramePosition[i][4]
frames[i]:SetPoint(point,UIParent,relativePoint,xOffset,yOffset)
end
function UI:UpdateTrackedActions(trackedActionsTable) --parameter list of table of tracked actions
  
  local actions = trackedActionsTable
  local configMode = Config:IsConfigMode()
if actions ~=nill then
  for actionID,v in pairs(actions) do  ---Handle tracked actions visibility
    if actions[actionID][5] == Actions:GetCurrentSpecialization() then   
      actions[actionID][3]:Show()
      local start, duration, enable = API:GetActionCooldown(actions[actionID][1])
      local notEnoughMana = API:IsUsableAction(actions[actionID][1])      
      if not configMode then
        if actions[actionID][3].edit ~=nil then
        if enable>0 and duration>1.5 or notEnoughMana then
         actions[actionID][3]:Hide()
        elseif duration<1.5 then      
       actions[actionID][3]:Show()
        else      
        actions[actionID][3]:Show()
        end
      end
      else      
       actions[actionID][3]:Show()
      end
    else
    actions[actionID][3]:Hide()
    end
  end
  end

  for i=1,#frames do
  --if i~=nill then
  UI:SortTrackedActions(actions,i)
  --end
  end
end
function UI:SortTrackedActions(trackedActions,sortNumber)
  local startxOffset =0
  local startyOffset =-40
  local count = 0
 
  for k,v in pairs(trackedActions) do
  local actionID = k 
  local frameNumber = trackedActions[actionID][6]
  if frameNumber == sortNumber then
  if trackedActions[actionID][3]:IsVisible() == true then    ----Sort tracked actions
  trackedActions[actionID][3]:SetPoint("LEFT",UI:GetActionBar(frameNumber),"LEFT",startxOffset,startyOffset)
  trackedActions[actionID][3].edit:SetPoint("CENTER",trackedActions[actionID][3],"CENTER",2,0)
  startxOffset = startxOffset +50
  count = count + 1
  if(startxOffset== trackedActionsColumnCount*50) then
  startxOffset =0
  startyOffset  = startyOffset-52
  end
end
end
end
end
function UI:RefreshTrackedIcons(trackedActions)
  for k,v in pairs(trackedActions) do
    if v[3]~=nill then
      local newTexture= API:GetActionTexture(v[1])
      v[3]:SetNormalTexture(newTexture)   
    end
  end
end
--Getters & Setters-----------------------------
function UI:GetActionBar(frameIndex)  --return frame from table "frames" [1]primary [2]secondary
return frames[frameIndex]
end
function UI:GetFramePosition(frameIndex)  --return frame from table "frames" [1]primary [2]secondary
  local point, relativeTo, relativePoint, xOfs, yOfs = frames[frameIndex]:GetPoint(1)
  local function round2(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
  end
  return {round2(xOfs,2),round2(yOfs,2),point,relativePoint}
  
end
--Saved Variables------
function UI:GetTrackedActionsColumnCount()
return trackedActionsColumnCount
end
function UI:GetTrackedActionsFrameCount()  
 return trackedActionsFrameCount 
end
function UI:GetTrackedActionsFramesPosition()
  for i=1,#frames do
  trackedSpellsFramePosition[i] =UI:GetFramePosition(i)
  end
  return trackedSpellsFramePosition
end
function UI:GetPrimaryFrame()
return primaryFrame
end
function UI:GetSecondaryFrame()
  return secondaryFrame
end
function UI:SetSavedVariables(framePosition,columnCount,frameScale,frameCount)
  trackedActionsColumnCount = columnCount
  trackedSpellsFramePosition = framePosition
  trackedActionsFrameCount = frameCount
  trackedActionsFrameScale = frameScale
end
-- Revision version Build 0006 --


