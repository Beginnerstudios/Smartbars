--NameSpaces------------------------------
local _,SmartBars = ...
SmartBars.Actions ={}
local Actions = SmartBars.Actions
local UI
local API
local Config
local Templates
local ActionBars
--Init------------------------------------
function Actions:Init()
    UI = SmartBars.UI
    API = SmartBars.API
    Config = SmartBars.Config
    Templates = SmartBars.Templates
    ActionBars = SmartBars.ActionBars
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
            Actions:Create(action,true,false)      
            end 
       
    end         
    UI:UpdateUI() 
end  
function Actions:Display(actions,frame)
    local xOffstet = 0
    local yOffset = -20
    local count = 0
  
    if displayedActions~=nil then
      for k in pairs(displayedActions) do
        if displayedActions[k]~=nil then
        displayedActions[k][3]:Hide()
        displayedActions[k][3] = nil      
        end
      end
      displayedActions = nil
    end
    for k in pairs(actions) do 
      actions[k][3]=Templates:CreateActionWidget(actions[k],frame,false)
      actions[k][3]:SetPoint("LEFT",frame.TitleBg,"LEFT",xOffstet+10,yOffset-100)
      actions[k][3]:SetHitRectInsets(0,0,0,0) 
      
   

  local actionType =actions[k][6]
  local actionID = actions[k][2]
  local actionName = API:GetDisplayedActionInfo(actionID,actionType)
  if actionType =="item" then
    actions[k][3].tooltipText = actionType.." - "..actionName
  else
    actions[k][3].tooltipText = actionName
  end




      xOffstet = xOffstet+50
       count = count +1
     --Next line after 12 spells
      if(count==6) then
      yOffset = yOffset -55
      xOffstet = 0
      count=0
      end
      --Compare widgets with tracked actions
      for _,v in pairs(Actions:Get()) do
      if Config:IsValueSame(actions[k][2],v[2]) and Config:IsValueSame(v[5],API:GetSpecialization()) then
        actions[k][3]:SetChecked(true)
       end
      end
      -- ACTION WIDGETS -- EVENTS
     
      actions[k][3]:SetScript("OnClick",function (self) 
      Actions:Add(actions[k]) end)
   
    end  
  displayedActions = actions
  UI:UpdateUI()
  end                                                               
function Actions:Load()
    local actions = trackedActions
    if actions ~=nil then                 
        for actionID in pairs(actions) do                     
        Actions:Create(actions[actionID],false,true,actionID)  
        end       
    end
    UI:UpdateUI()
end  
function Actions:Create(action,isEnabled,isExisting,key)
    local curretSpec    
    local actionID 
    local trackedFrame = nil
    local isBoosted = false
    local showOnlyWhenBoosted = nil
    local actionType = nil
    local a
    if isExisting==true then
        curretSpec = action[5]
        trackedFrame = action[6]
      
        showOnlyWhenBoosted = action[8]
        actionID = key  
        actionType = action[9]     
    else  
        actionID= Config:JoinNumber(action[2],Config:GetSpec())
        curretSpec= API:GetSpecialization()
        a,trackedFrame = ActionBars:Get():HighestFrameID()  
        showOnlyWhenBoosted = false
        actionType = action[6]
    end  
 
        trackedActions[actionID]= {action[1],action[2],Templates:CreateActionWidget(action,ActionBars:Get():ActionBar(trackedFrame),true),action[4],curretSpec,trackedFrame,isBoosted,showOnlyWhenBoosted,actionType} 
        trackedActions[actionID][3].edit = Templates:CreateEditBox(trackedActions[actionID][3],trackedActions[actionID],isEnabled)  
        trackedActions[actionID][3].group = Templates:CreateGroupLayout(trackedActions[actionID][3],trackedActions[actionID],isEnabled,actionID) 
        trackedActions[actionID][3].charges = Templates:CreateFontString(trackedActions[actionID][3],15)  
  
    

end
function Actions:Delete(actionID)
    trackedActions[actionID][3]:Hide() 
    trackedActions[actionID]=nil   
end  
--Getters & Setters,Reset-----------------------------
function Actions:Set(loadedTrackedActions)
    trackedActions = loadedTrackedActions
end
function Actions:Get()
    return trackedActions
end
-- Revision version v0.9.9 ---
