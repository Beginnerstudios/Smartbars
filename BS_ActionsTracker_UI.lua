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
local frames = {};
local displayedActions={};
local trackedActionsColumnCount=0 --SV
local trackedSpellsFramePosition ={};--SV
local trackedActionsFrameScale =0--SV
local trackedActionsFrameCount = 0
local maximumTrackedBars =5
local SecondaryHolder

--UI:Frames-------------------------------
function UI:CreatePrimaryFrame()  --create and assign frames to table "frames" [1]primary [2]secondary
  local function PrimaryFrame()
    local UIConfig = CreateFrame("Frame","BS_ActionsTracker.Primary",UIParent,"BasicFrameTemplateWithInset");
    local defaultFont = "GameFontHighlight"
    UI:SetFrameMoveable(UIConfig)  
    UIConfig:Hide()
    UIConfig:SetSize(630,0);
    UIConfig:SetPoint("CENTER",UIParent,"CENTER",0,100);
    -- PRIMARY FRAME EVENTS ---
    UIConfig.CloseButton:SetScript("OnClick", function ()
    Config:ToggleConfigMode()
    end)
    -- MAIN FRAME - TITLE -
  
       UIConfig.title = UIConfig:CreateFontString(nil,"OVERLAY");
       UIConfig.title:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",5,-2);
       UIConfig.title:SetFontObject(defaultFont)
       UIConfig.title:SetText("BS_ActionsTracker");
      -- MAIN FRAME - HEADERTEXT -  Number of used actions
      UIConfig.titleUsed = UIConfig:CreateFontString(nil,"OVERLAY");
      UIConfig.titleUsed:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-40);
      UIConfig.titleUsed:SetFontObject(defaultFont)
      UIConfig.titleUsed:SetText("Used actions:");
           -- MAIN FRAME - HEADERTEXT -  Number of unused actions
    UIConfig.titleUsedValue = UIConfig:CreateFontString(nil,"OVERLAY");
    UIConfig.titleUsedValue:SetPoint("LEFT",UIConfig.titleUsed,"LEFT",100,0);
    UIConfig.titleUsedValue:SetFontObject(defaultFont)
    UIConfig.titleUsedValue:SetText("");
    -- MAIN FRAME - HEADERTEXT -  Number of unused actions
    UIConfig.titleTrackedStatic = UIConfig:CreateFontString(nil,"OVERLAY");
    UIConfig.titleTrackedStatic:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-60);
    UIConfig.titleTrackedStatic:SetFontObject(defaultFont)
    UIConfig.titleTrackedStatic:SetText("Tracked actions:");
    -- MAIN FRAME - HEADERTEXT -  Number of unused actions
    UIConfig.titleTrackedValue = UIConfig:CreateFontString(nil,"OVERLAY");
    UIConfig.titleTrackedValue:SetPoint("LEFT",UIConfig.titleTrackedStatic,"LEFT",100,0);
    UIConfig.titleTrackedValue:SetFontObject(defaultFont)
    UIConfig.titleTrackedValue:SetText("");
      -- MAIN FRAME - SPELLSTITLE
      UIConfig.spellsTitle = UIConfig:CreateFontString(nil,"ARTWORK");
      UIConfig.spellsTitle:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-80);
      UIConfig.spellsTitle:SetFontObject(defaultFont)
      UIConfig.spellsTitle:SetText("Used actions in action bars:");
      -- RESET ACTION BUTTON ---
      UIConfig.resetButton = CreateFrame("Button", "only_for_testing", UIConfig,"UIPanelButtonTemplate")
      UIConfig.resetButton:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", -120, -60)
      UIConfig.resetButton:SetWidth(70)
      UIConfig.resetButton:SetHeight(35)
      UIConfig.resetButton:SetText("Reset all")
      UIConfig.resetButton:SetNormalFontObject(defaultFont)
      --Reset button events----
      UIConfig.resetButton:SetScript("OnClick", function ()
      Actions:ResetActions()
      end)
      
      UIConfig.slider = CreateFrame("Slider", "myslider", UIConfig,"OptionsSliderTemplate")
      UIConfig.slider:SetPoint("RIGHT", UIConfig.TitleBg, "RIGHT", 00, -50)
      UIConfig.slider:SetWidth(100)
      UIConfig.slider:SetHeight(15)
      UIConfig.slider:SetMinMaxValues(0.5,1.5)
      UIConfig.slider:SetValue(trackedActionsFrameScale)
      UIConfig.slider:SetStepsPerPage(10)      
      UIConfig.slider:SetScript("OnValueChanged", function (self) 
      frames[2]:SetScale(self:GetValue())     
      end)
      getglobal(UIConfig.slider:GetName() .. 'Low'):SetText('0,5'); --Sets the left-side slider text (default is "Low").
      getglobal(UIConfig.slider:GetName() .. 'High'):SetText('1,5'); --Sets the right-side slider text (default is "High").
      getglobal(UIConfig.slider:GetName() .. 'Text'):SetText('Scale'); --Sets the "title" text (top-centre of slider).


      UIConfig.columnsText = UIConfig:CreateFontString(nil,"ARTWORK");
      UIConfig.columnsText:SetPoint("CENTER",UIConfig.TitleBg,"CENTER",-30,-30);
      UIConfig.columnsText:SetFontObject(defaultFont)
      UIConfig.columnsText:SetText("Columns: ");
      UIConfig.columnsText2 = UIConfig:CreateFontString(nil,"ARTWORK");
      UIConfig.columnsText2:SetPoint("CENTER",UIConfig.TitleBg,"CENTER",10,-30);
      UIConfig.columnsText2:SetFontObject(defaultFont)
      UIConfig.columnsText2:SetText(trackedActionsColumnCount);



      UIConfig.minusButton = CreateFrame("Button", "bs_minus", UIConfig,"UIPanelButtonTemplate")
      UIConfig.minusButton:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", -35, -60)
      UIConfig.minusButton:SetSize(35,35)
      UIConfig.minusButton:SetText("-")
      UIConfig.minusButton:SetNormalFontObject(defaultFont)    
      UIConfig.minusButton:SetScript("OnClick", function ()
      if trackedActionsColumnCount>= 2 then
        trackedActionsColumnCount = trackedActionsColumnCount -1
        UIConfig.columnsText2:SetText(trackedActionsColumnCount)
      end
      end)

      UIConfig.plusButton = CreateFrame("Button", "bs_plus", UIConfig,"UIPanelButtonTemplate")
      UIConfig.plusButton:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", 0, -60)
      UIConfig.plusButton:SetSize(35,35)
      UIConfig.plusButton:SetText("+")
      UIConfig.plusButton:SetNormalFontObject(defaultFont)    
      UIConfig.plusButton:SetScript("OnClick", function ()
      if trackedActionsColumnCount<= 12 then
        trackedActionsColumnCount = trackedActionsColumnCount +1
        UIConfig.columnsText2:SetText(trackedActionsColumnCount)
      end
      end)

      ---Action bars count

      UIConfig.cT = UIConfig:CreateFontString(nil,"ARTWORK");
      UIConfig.cT:SetPoint("CENTER",UIConfig.TitleBg,"CENTER",120,-30);
      UIConfig.cT:SetFontObject(defaultFont)
      UIConfig.cT:SetText("Tracked bars: ");
      UIConfig.cT2 = UIConfig:CreateFontString(nil,"ARTWORK");
      UIConfig.cT2:SetPoint("CENTER",UIConfig.TitleBg,"CENTER",170,-30);
      UIConfig.cT2:SetFontObject(defaultFont)
      UIConfig.cT2:SetText(trackedActionsFrameCount);

      UIConfig.minusButton2 = CreateFrame("Button", "bs_minus", UIConfig,"UIPanelButtonTemplate")
      UIConfig.minusButton2:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", 115, -60)
      UIConfig.minusButton2:SetSize(35,35)
      UIConfig.minusButton2:SetText("-")
      UIConfig.minusButton2:SetNormalFontObject(defaultFont)    
      UIConfig.minusButton2:SetScript("OnClick", function ()
      if trackedActionsFrameCount>= 2 then
        UI:RemoveLastSecondaryFrame()
        trackedActionsFrameCount = trackedActionsFrameCount -1

        UIConfig.cT2:SetText(trackedActionsFrameCount)
     
      end
      end)

      UIConfig.plusButton2 = CreateFrame("Button", "bs_plus", UIConfig,"UIPanelButtonTemplate")
      UIConfig.plusButton2:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", 155, -60)
      UIConfig.plusButton2:SetSize(35,35)
      UIConfig.plusButton2:SetText("+")
      UIConfig.plusButton2:SetNormalFontObject(defaultFont)    
      UIConfig.plusButton2:SetScript("OnClick", function ()
      
        if trackedActionsFrameCount<maximumTrackedBars then
        trackedActionsFrameCount = trackedActionsFrameCount+1 
        UI:CreateSecondaryFrame(#frames+1)   
        UIConfig.cT2:SetText(trackedActionsFrameCount)
        end
     
      end)





      

       return UIConfig
  end
  frames[1] = PrimaryFrame()
  SecondaryHolder = CreateFrame("Frame","BS_ActionsTracker.SecondaryHolder",UIParent);
  SecondaryHolder:SetPoint("CENTER",frames[1],"CENTER",0,-200);
  SecondaryHolder:SetScript("OnUpdate", function ()
    UI:UpdateTrackedActions(Actions:GetTrackedActions())
    end)
end
function UI:CreateSecondaryFrame(index)
  local function SecondaryFrame()
    SecondaryFrame = CreateFrame("Frame","BS_ActionsTracker.Secondary",UIParent);
    SecondaryFrame:SetScale(trackedActionsFrameScale)
  
   
    UI:SetFrameMoveable(SecondaryFrame)
    SecondaryFrame:SetSize(150,75);
    SecondaryFrame:SetPoint("CENTER",SecondaryHolder,"CENTER",0,-200);
    --SECONDARY FRAME-TITLE
    SecondaryFrame.title = SecondaryFrame:CreateFontString(nil,"OVERLAY");
    SecondaryFrame.title:SetPoint("CENTER",SecondaryFrame,"CENTER",25,0);
    SecondaryFrame.title:SetFontObject("GameFontHighlight")
    SecondaryFrame.title:SetText("BAR: "..index .." BS_ActionsTracker - move frame,edit text")
    SecondaryFrame.title:SetAlpha(0)
    SecondaryFrame:SetMovable(false)
     --SECONDARY FRAME -EVENTS   

    return SecondaryFrame
  end

  frames[#frames+1] = SecondaryFrame()
 
end
function UI:RemoveLastSecondaryFrame()
local actions = Actions:GetTrackedActions()
frames[#frames]:Hide()  
for k,v in pairs(actions) do
  if actions[k][6] == #frames-1 then
    print("hit")
    actions[k][6]=actions[k][6]-1  
    actions[k][3].group.columnsText2:SetText(actions[k][6])
  end

end

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
  end)
end
function UI:ShowSecondaryFrames()
  for i=2,#frames do
  UI:GetFrame(i):SetMovable(true) 
  UI:GetFrame(i):EnableMouse(true) 
  UI:GetFrame(i).title:SetAlpha(1)    
  UI:GetFrame(i):Show()
  end
end
function UI:HideSecondaryFrames()
  for i=2,#frames do
  UI:GetFrame(i):SetMovable(false) 
  UI:GetFrame(i):EnableMouse(false) 
  UI:GetFrame(i).title:SetAlpha(0)    
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
print(valueToSave[6])
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
  frames[1].titleUsedValue:SetText(usedSpellsCount)
  frames[1].titleTrackedValue:SetText(trackedSpellsCount)
  --Secondary Frame size
  local xOffset = trackedSpellsFramePosition[1] 
  local yOffset = trackedSpellsFramePosition[2]
  local point = trackedSpellsFramePosition[3]
  local relativePoint = trackedSpellsFramePosition[4]
frames[2]:SetPoint(point,UIParent,relativePoint,xOffset,yOffset)


if usedSpellsCount<12 then
frames[1]:SetHeight(400)
else
frames[1]:SetHeight(usedSpellsCount/12+3*140)
end



 UI:RefreshTrackedIcons(Actions:GetTrackedActions())
end
function UI:UpdateTrackedActions(trackedActionsTable) --parameter list of table of tracked actions
  
  local actions = trackedActionsTable
  local configMode = Config:IsConfigMode()
if actions ~=nill then
  for actionID,v in pairs(actions) do  ---Handle tracked actions visibility
    if actions[actionID][5] == Actions:GetCurrentSpecialization() then   
      actions[actionID][3]:Show()
      local start, duration, enable = API:GetActionCooldown(actions[actionID][1])
      local isUsable, notEnoughMana = IsUsableAction(actions[actionID][1])      
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
 UI:SortTrackedActions(actions,i)
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
  if trackedActions[actionID][3]:GetAlpha()>0 and trackedActions[actionID][3]:IsVisible() == true then    ----Sort tracked actions
  trackedActions[actionID][3]:SetPoint("LEFT",UI:GetFrame(frameNumber+1),"LEFT",startxOffset,startyOffset)
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
function UI:GetFrame(frameIndex)  --return frame from table "frames" [1]primary [2]secondary
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
function UI:SetTrackedActionsFrameScale(savedScale)  
  trackedActionsFrameScale = savedScale
  end
function UI:SetTrackedActionsColumnCount(columnCount)  
  trackedActionsColumnCount = columnCount
  end
function UI:SetTrackedActionsFramePosition(framePosition)  
  trackedSpellsFramePosition = framePosition
end
function UI:GetTrackedActionsFrameCount()  
  return trackedActionsFrameCount 
end
function UI:SetTrackedActionsFrameCount(frameCount)  
  trackedActionsFrameCount = frameCount 
end
-- Revision version Build 0004 --


