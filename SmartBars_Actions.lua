--NameSpaces------------------------------
local _,SmartBars = ...;
SmartBars.Actions ={};
local Actions = SmartBars.Actions;
--Init------------------------------------
function Actions:Init()
    UI = SmartBars.UI
    API = SmartBars.API
end
--Variables--------------------------------
local trackedActions = {}
local displayedActions = {}
--Actions:Functions-----------------------
function Actions:Add(action) 
    if action[2]/action[2] ==1 then
        local actionID = Config:JoinNumber(action[2],API:GetSpecialization())
            if trackedActions[actionID]then              
                Actions:Delete(actionID)
            else  
            Actions:Create(action,true,false,false)      
            end 
        else
            print("Inncorect action.")
        end         
    UI:UpdateUI() 
end  
function Actions:Display(actions,frame) --Create widgets for selected actions under selected frame parent
    local xOffstet = 0;
    local yOffset = -10;
    local count = 0
  
    if displayedActions~=nill then
      for k,v in pairs(displayedActions) do
        if displayedActions[k]~=nill then
        displayedActions[k][3]:Hide()
        displayedActions[k][3] = nill      
        end
      end
      displayedActions = nill
    end
    for k,v in pairs(actions) do 
      actions[k][3]=UI:CreateActionWidget(actions[k],frame,false)
      actions[k][3]:SetPoint("LEFT",frame.TitleBg,"LEFT",xOffstet+10,yOffset-100);
      xOffstet = xOffstet+50;
       count = count +1
     --Next line after 12 spells
      if(count==6) then
      yOffset = yOffset -55;
      xOffstet = 0;
      count=0
      end
      --Compare widgets with tracked actions
      for q,v in pairs(Actions:GetTracked()) do
      if Config:IsValueSame(actions[k][2],v[2]) and Config:IsValueSame(v[5],API:GetSpecialization()) then
        actions[k][3]:SetChecked(true)
       end
      end
      -- ACTION WIDGETS -- EVENTS
     
      actions[k][3]:SetScript("OnClick",function (self) 
      Actions:Add(actions[k]) end)
      actions[k][3]:SetScript("OnEnter",function ()
    --    actions[k][3].tooltip:Show()
      end)
      actions[k][3]:SetScript("OnEnter",function ()
     --   actions[k][3].tooltip:Hide()
       end)
    end  
  displayedActions = actions
  UI:UpdateUI()
  end                                                               
function Actions:Load()
    local actions = trackedActions
    if actions ~=nill then                 
        for actionID,v in pairs(actions) do                     
        Actions:Create(actions[actionID],false,true,true,actionID)  
        end       
    end
    UI:UpdateUI()
end  
function Actions:Create(action,isEnabled,isExisting,isDisplayed,key)
    local curretSpec    
    local actionID 
    local trackedFrame = nill
    local isBoosted = false
    local showOnlyWhenBoosted = nill
    if isExisting==true then
        curretSpec = action[5]
        trackedFrame = action[6]
        showOnlyWhenBoosted = action[8]
        actionID = key       
    else  
        actionID= Config:JoinNumber(action[2],Config:GetSpec())
        curretSpec= API:GetSpecialization()
        trackedFrame = 1   
        showOnlyWhenBoosted = false
    end  
 
        trackedActions[actionID]= {action[1],action[2],UI:CreateActionWidget(action,UI:Get():ActionBar(trackedFrame),true,isEnabled),action[4],curretSpec,trackedFrame,isBoosted,showOnlyWhenBoosted} 
        trackedActions[actionID][3].edit = UI:CreateEditBox(trackedActions[actionID][3],trackedActions[actionID],isEnabled)  
        trackedActions[actionID][3].group = UI:CreateGroupLayout(trackedActions[actionID][3],trackedActions[actionID],isEnabled) 
        trackedActions[actionID][3].charges = UI:CreateFontString(trackedActions[actionID][3],trackedActions[actionID],isDisplayed)  
  
    

end
function Actions:Delete(actionID)
    trackedActions[actionID][3]:Hide() 
    trackedActions[actionID]=nill
   
end  
--Getters & Setters,Reset-----------------------------  
function Actions:SetSavedVariables(tActions)
    trackedActions = tActions
end
function Actions:GetTracked()
    return trackedActions
end
-- Revision version v0.8.6 ---
