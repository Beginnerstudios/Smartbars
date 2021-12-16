--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Actions ={};
local Actions = BS_ActionsTracker.Actions;
--Init------------------------------------
function Actions:Init()
    UI = BS_ActionsTracker.UI
    API = BS_ActionsTracker.API
end
--Variables--------------------------------
local trackedActions = {}
local currentSpecialization =0
--Actions:Functions-----------------------
function Actions:GetActions()                         
 local returnTable =
        {                         
            Used = function(self)
                local slotCount = 120
                local allSlotTable = {}
                for i=1,slotCount do
                local actionType,actionID,subType = API:GetActionInfo(i)
                if actionID ~=nil then
                allSlotTable[actionID] = {i,actionID,nil,"",currentSpecialization}           --- [1]slot id [2]spellID
            end
          end
          local count = 0
          for _ in pairs(allSlotTable) do count = count + 1 end    
         return {allSlotTable,count}
                               
            end,        
            Tracked = function(self)                                              
                local count = 0
                for _,v in pairs(trackedActions) do
                    if v[5] == API:GetSpecialization() then
                    count = count + 1 
                    end                  
                end                            
                return  {trackedActions,count}  
            end                                           
        }
return returnTable
end
function Actions:AddTrackedAction(action)
    local actionID = action[2]  
    if  trackedActions[actionID]then              
      Actions:DeleteTrackedAction(action)
    else  
      Actions:CreateTrackedAction(action,true,false,false)      
    end          
    UI:UpdateUI()    
end                                                               
function Actions:InitTrackedActions(actions)
    if actions ~=nill then                 
    for actionID,v in pairs(actions) do                     
    Actions:CreateTrackedAction(actions[actionID],false,true,true)
    end       
    end
    UI:UpdateUI()
end  
function Actions:CreateTrackedAction(action,isEnabled,isExisting,isDisplayed)
    local actionID = action[2] 
    local curretSpec = nill
    local trackedFrame = nill
    local isBoosted = false
    local showOnlyWhenBoosted = nill
    if isExisting==true then
        curretSpec = action[5]
        trackedFrame = action[6]
        showOnlyWhenBoosted = action[8]
    else  
        curretSpec = API:GetSpecialization()
        trackedFrame = 1   
        showOnlyWhenBoosted = false
    end  
    trackedActions[actionID]= {action[1],action[2],UI:CreateActionWidget(action,UI:GetActionBar(trackedFrame),true,isEnabled),action[4],curretSpec,trackedFrame,isBoosted,showOnlyWhenBoosted} 
    trackedActions[actionID][3].edit = UI:CreateEditBox(trackedActions[actionID][3],trackedActions[actionID],isEnabled)  
    trackedActions[actionID][3].group = UI:CreateGroupLayout(trackedActions[actionID][3],trackedActions[actionID],isEnabled)    
    trackedActions[actionID][3].charges = UI:CreateFontString(trackedActions[actionID][3],trackedActions[actionID],isDisplayed)    
end
function Actions:DeleteTrackedAction(action)
    local actionID = action[2]
    trackedActions[actionID][3]:Hide() 
    trackedActions[actionID]=nill
end  
--Getters & Setters,Reset-----------------------------
function Actions:GetCurrentSpecialization()
    return currentSpecialization
end  
function Actions:SetCurrentSpecialization()
    currentSpecialization = API:GetSpecialization()
end  
--Saved Variables-----------------------------
function Actions:SetTrackedActions(tActions)
    trackedActions = tActions
end   
function Actions:GetTrackedActions()
    return trackedActions
end 

-- Revision version v0.8 ---
