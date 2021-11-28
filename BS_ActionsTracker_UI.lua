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
--UI:Frames-------------------------------
function UI:CreateFrames()  --create and assign frames to table "frames" [1]primary [2]secondary
  local function PrimaryFrame()   
    local UIConfig = CreateFrame("Frame","BS_ActionsTracker.Primary",UIParent,"BasicFrameTemplateWithInset");
    UIConfig:RegisterEvent("ADDON_LOADED")
    UI:SetFrameMoveable(UIConfig)
    UIConfig:Hide()
    UIConfig:SetSize(630,50);
    UIConfig:SetPoint("CENTER",UIParent,"CENTER",0,100);
    UIConfig.CloseButton:SetScript("OnClick", function ()     
    Config:ToggleConfigMode()
    Actions:SetIsConfigMode(false)
    frames[2]:SetMovable(false)  
    frames[2].title:SetText("")
    for k,v in pairs(Actions.GetTrackedActions()) do
      
      v[3].edit:SetEnabled(false)
  end  
    end)
    -- MAIN FRAME - TITLE - 
       UIConfig.title = UIConfig:CreateFontString(nil,"OVERLAY");
       UIConfig.title:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",5,-2);
       UIConfig.title:SetFontObject("GameFontHighlight")
       UIConfig.title:SetText("BS_ActionTracker");          
      -- MAIN FRAME - HEADERTEXT -  Number of used actions 
      UIConfig.titleUsed = UIConfig:CreateFontString(nil,"OVERLAY");
      UIConfig.titleUsed:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-40);
      UIConfig.titleUsed:SetFontObject("GameFontHighlight")
      UIConfig.titleUsed:SetText("Used actions:");   
           -- MAIN FRAME - HEADERTEXT -  Number of unused actions
    UIConfig.titleUsedValue = UIConfig:CreateFontString(nil,"OVERLAY");
    UIConfig.titleUsedValue:SetPoint("LEFT",UIConfig.titleUsed,"LEFT",100,0);
    UIConfig.titleUsedValue:SetFontObject("GameFontHighlight")
    UIConfig.titleUsedValue:SetText(""); 
    -- MAIN FRAME - HEADERTEXT -  Number of unused actions
    UIConfig.titleTrackedStatic = UIConfig:CreateFontString(nil,"OVERLAY");
    UIConfig.titleTrackedStatic:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-60);
    UIConfig.titleTrackedStatic:SetFontObject("GameFontHighlight")
    UIConfig.titleTrackedStatic:SetText("Tracked actions:");   
    -- MAIN FRAME - HEADERTEXT -  Number of unused actions
    UIConfig.titleTrackedValue = UIConfig:CreateFontString(nil,"OVERLAY");
    UIConfig.titleTrackedValue:SetPoint("LEFT",UIConfig.titleTrackedStatic,"LEFT",100,0);
    UIConfig.titleTrackedValue:SetFontObject("GameFontHighlight")
    UIConfig.titleTrackedValue:SetText(""); 
      -- MAIN FRAME - SPELLSTITLE 
      UIConfig.spellsTitle = UIConfig:CreateFontString(nil,"ARTWORK");
      UIConfig.spellsTitle:SetPoint("LEFT",UIConfig.TitleBg,"LEFT",10,-80);
      UIConfig.spellsTitle:SetFontObject("GameFontHighlight")
      UIConfig.spellsTitle:SetText("Used actions in action bars:");  
      -- RESET ACTION BUTTON ---
     
      local resetButton = CreateFrame("Button", "only_for_testing", UIConfig,"UIPanelButtonTemplate")
      resetButton:SetPoint("CENTER", UIConfig.TitleBg, "CENTER", 0, -40)
      resetButton:SetWidth(70)
      resetButton:SetHeight(35)  
      resetButton:SetText("Reset all")
      resetButton:SetNormalFontObject("GameFontNormalSmall")  
      resetButton:SetScript("OnClick", function ()    
      Actions:ResetActions()
      end)              
     -- UIConfig.resetButton:SetText("Reset All")
      
      
   
    
       return UIConfig
  end
  local function SecondaryFrame()    
    SecondaryFrame = CreateFrame("Frame","BS_ActionsTracker.Secondary",UIParent);
    UI:SetFrameMoveable(SecondaryFrame)
  --  UI:SetFrameLockable(SecondaryFrame)    
    SecondaryFrame:SetSize(75,75);
    SecondaryFrame:SetPoint("CENTER",UIParent,"CENTER",0,-200);
  
    --SECONDARY FRAME-TITLE
    SecondaryFrame.title = SecondaryFrame:CreateFontString(nil,"OVERLAY");
    SecondaryFrame.title:SetPoint("CENTER",SecondaryFrame,"LEFT",5,-2);
    SecondaryFrame.title:SetFontObject("GameFontHighlight")
    SecondaryFrame.title:SetText("");  
    SecondaryFrame:SetMovable(false)
    SecondaryFrame:SetScript("OnUpdate", function ()
      UI:UpdateTrackedActions(Actions.GetTrackedActions())
    end)
             
    return SecondaryFrame
  end
  frames[1] = PrimaryFrame()
  frames[2] = SecondaryFrame()
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
--UI:Actions-------------------------------
function UI:DisplayActions(actions,frame) --Create widgets for selected actions under selected frame parent   
  local xOffstet = 0;
  local yOffset = -20;
  local count = 0 
  for k,v in pairs(actions) do 
    local actionWidget=UI:CreateActionWidget(actions[k],frame)   
  
    
    for q,v in pairs(Actions:GetTrackedActions()) do
    
     if actions[k][2] == v[2] then      
        actionWidget:SetChecked(true)
     end
    end
     actionWidget:SetScript("OnClick",function () Actions:AddTrackedAction(actions[k]) end) 
     actionWidget:SetPoint("LEFT",frame.TitleBg,"LEFT",xOffstet+10,yOffset-100);            
     xOffstet = xOffstet+50; 
     count = count +1  
     --Next line after 12 spells
     if(count==12) then 
     yOffset = yOffset -75;
     xOffstet = 0;
     count=0  
    end
    frame:SetSize(630,yOffset+yOffset-40)
  end  
 UI:UpdateUI()
end    
function UI:CreateActionWidget(action,parentFrame) 
 local actionWidget = CreateFrame("CheckButton",nil, parentFrame, "UICheckButtonTemplate")
 actionWidget:SetWidth(50)
 actionWidget:SetHeight(50)       
 local newTexture= GetActionTexture(action[1])              
 actionWidget:SetNormalTexture(newTexture)
 actionWidget:SetHighlightTexture(newTexture)
 actionWidget:SetPushedTexture(newTexture)   
 return actionWidget     
end
function UI:CreateEditBox(parentFrame,editboxText)

  parentFrame.edit = CreateFrame("EditBox",nil, parentFrame, "UICheckButtonTemplate")
  parentFrame.edit:SetPoint("CENTER",parentFrame,"CENTER",0,0);
  parentFrame.edit:SetSize(50,50)
  parentFrame.edit:SetText(editboxText)
  parentFrame.edit:SetAutoFocus(false)  
  parentFrame.edit:SetMaxLetters(2)  
  parentFrame.edit:SetEnabled(false)
  parentFrame.edit:SetFont("Fonts\\FRIZQT__.TTF", 26, "OUTLINE")
  parentFrame.edit:SetPoint("LEFT",parentFrame,"LEFT",5,0)

  
  return parentFrame.edit
end
       
--UI:Update-----------------------------------
function UI:UpdateUI() ---update all dynamic variables in UI
--variables
local trackedSpellsCount = Actions:GetUserActions().GetTracked()[2];
local usedSpellsCount = Actions:GetUserActions().GetUsed()[2];

  --Header Primary frame dynamic values
  frames[1].titleUsedValue:SetText(usedSpellsCount) 
  frames[1].titleTrackedValue:SetText(trackedSpellsCount)
  
  --Secondary Frame size
  frames[2]:SetSize(55*trackedSpellsCount,80) 
  if trackedSpellsCount ==0 then
    frames[2]:Hide()  
  else 
    frames[2]:Show()  
  end
end
function UI:UpdateTrackedActions(trackedActionsTable) --parameter list of table of tracked actions
  local actions = trackedActionsTable
  local configMode = IsActionsTrackerConfigMode
if actions ~=nill then
  for actionID,v in pairs(actions) do  ---Handle tracked actions visibility
    local start, duration, enable = GetActionCooldown(actions[actionID][1])    
    local isUsable, notEnoughMana = IsUsableAction(actions[actionID][1]) 
      if not configMode then
        if actions[actionID][3].edit ~=nil then  
        if enable>0 and duration>1.5 or notEnoughMana then                       
      actions[actionID][3]:SetAlpha(0) 
      actions[actionID][3].edit:SetAlpha(0) 
        elseif duration<1.5 then
        actions[actionID][3]:SetAlpha(1)                  
        actions[actionID][3].edit:SetAlpha(1)
        else       
        actions[actionID][3]:SetAlpha(1)  
        actions[actionID][3].edit:SetAlpha(1)
        end             
      end
      else       
        actions[actionID][3]:SetAlpha(1)  
        actions[actionID][3].edit:SetAlpha(1) 
      end
  end
  end


UI:SortTrackedActions(actions)
end
--Getters & Setters-----------------------------
function UI:GetFrame(frameIndex)  --return frame from table "frames" [1]primary [2]secondary
  return frames[frameIndex]
  end
--Unused---------------------------------------
function UI:SetFrameLockable(frame)
    -- MAIN FRAME - LOCK BUTTON -
     
    frame.lockText = frame:CreateFontString(nil,"OVERLAY");
    frame.lockText:SetParent(frame)
    frame.lockText:SetPoint("CENTER", frame,"LEFT",0,20);
    frame.lockText:SetFontObject("GameFontHighlight")
    frame.lockText:SetText("Lock");      
    frame.lockButton = CreateFrame("CheckButton",nil, UIParent, "UICheckButtonTemplate")
    frame.lockButton:SetPoint("LEFT", frame,"LEFT",20,20);
    frame.lockButton:SetParent(frame)
    frame.lockButton:SetScript("OnClick",function ()
  if frame.lockButton:GetChecked() then
    frame:SetMovable(false)
  else
    frame:SetMovable(true)
  end
  end)            
end
function UI:SortTrackedActions(trackedActions)
  local startOffset =0
  local count = 0
  for k,v in pairs(trackedActions) do
  if v[3]:GetAlpha()>0 then    ----Sort tracked actions
    v[3]:SetPoint("LEFT",UI:GetFrame(2).title,"LEFT",startOffset,-40)
    startOffset = startOffset +50
    count = count + 1
  end
  Actions:SetLastOffset(count*50)
end
end

