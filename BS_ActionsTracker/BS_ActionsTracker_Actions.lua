--NameSpaces------------------------------
local _,BS_ActionsTracker = ...;
BS_ActionsTracker.Actions ={};
local Actions = BS_ActionsTracker.Actions;
--Init------------------------------------
function Actions:Init()
    UI = BS_ActionsTracker.UI
end


--Variables--------------------------------
local trackedActions = {}
local lastOffset =0
--Actions:Functions-----------------------
function Actions:GetUserActions()---test                                
    local returnTable =
        {                         
            GetUsed = function(self)
                local slotCount = 120
                local allSlotTable = {}
                for i=1,slotCount do
                local actionType,actionID,subType = GetActionInfo(i)
                if actionID ~=nil then
                allSlotTable[actionID] = {i,actionID,nil,""}           --- [1]slot id [2]spellID
            end
          end
          local count = 0
          for _ in pairs(allSlotTable) do count = count + 1 end    
         return {allSlotTable,count}
                               
            end,        
            GetTracked = function(self)                                              
                local count = 0
                for _ in pairs(trackedActions) do count = count + 1 end                              
                return  {trackedActions,count}  
            end                                           
        }
return returnTable
end
function Actions:AddTrackedAction(action)    
    local actionID = action[2]  
    if  trackedActions[actionID]then              
        trackedActions[actionID][3]:Hide() 
        trackedActions[actionID]=nill
    else     
       trackedActions[actionID]= {action[1],action[2],UI:CreateActionWidget(action,UI:GetFrame(2)),action[4]} 
       UI:CreateEditBox(trackedActions[actionID][3],action[4])  
       trackedActions[actionID][3].edit:SetEnabled(true)       
       trackedActions[actionID][3]:SetCheckedTexture(nill) 
       trackedActions[actionID][3]:SetHighlightTexture(nill) 
    end       
    
    UI:UpdateUI()
    
end                                                               
function Actions:InitTrackedActions(actions)    
    if actions ~=nill then
    for k,v in pairs(actions) do              
        local actionID = k     
        actions[actionID]= {v[1],v[2],UI:CreateActionWidget(v,UI:GetFrame(2)),v[4]}               
        UI:CreateEditBox(actions[actionID][3],v[4]) 
        actions[actionID][3].edit:SetPoint("CENTER",UIParent,"CENTER",0,0)
        actions[actionID][3].edit:SetScript("OnEditFocusLost", function (self)             
        actions[actionID][4] = self:GetText()       
        end)      
        end       
    end
    UI:UpdateUI()
end     
--Getters & Setters,Reset-----------------------------
function Actions:GetTrackedActions()
    return trackedActions
end 
 function Actions:SetTrackedActions(tActions)
    trackedActions = tActions
end 
function Actions:SetLastOffset(value)
    lastOffset = value
end         
function Actions:ResetActions()
trackedActions = nill
UI:GetFrame(2):SetPoint("CENTER",UIParent,"CENTER",0,-200)
ReloadUI()
end
-- Revision version Build 0003 --
