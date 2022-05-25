-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local fOnSpellAction;
local fGetSpellAction;

function onInit()
    SpellManager.getActionTargetText = getActionTargetText;

    fOnSpellAction = SpellManager.onSpellAction;
    SpellManager.onSpellAction = onSpellAction;

    fGetSpellAction = SpellManager.getSpellAction;
    SpellManager.getSpellAction = getSpellAction;
end

function getActionTargetText(nodeAction)
    local nodeActor = nodeAction.getChild(".........")
    local size = DB.getValue(nodeAction, "burstsize", 0);
	local faction = DB.getValue(nodeAction, "targetfaction", "");
	return CloseEncounters.getActionText(faction, size)
end

function onSpellAction(draginfo, nodeAction, sSubRoll)
    if not nodeAction then
		return;
	end

	-- If nodeAction has action children then it is two levels higher then the usual action record.  This occurs when the spell header applyalleffects button is pressed.
	-- Get the first cast action node as a placeholder.
	if DB.getChild(nodeAction,"actions") then
		local nodeActions = DB.getChildren(nodeAction,"actions");
		for _, action in pairs(DB.getChildren(nodeAction,"actions")) do
			if DB.getValue(action, "type", "") == "cast" then
				nodeAction = action;
				break;
			end
		end		
	end

	local rActor = ActorManager.resolveActor(nodeAction.getChild("........."));
	if not rActor then
		return;
	end

    local rAction = getSpellAction(rActor, nodeAction, sSubRoll);
    if rAction.type == "target" then
        CloseEncounters.toggleTargeting(rActor, rAction.nSize, rAction.sFaction);
    else
        fOnSpellAction(draginfo, nodeAction, sSubroll);
    end
end

function getSpellAction(rActor, nodeAction, sSubRoll)
    if not nodeAction then
		return;
	end
	
	local sType = DB.getValue(nodeAction, "type", "");
    
    if sType == "target" then
        local rAction = {};
        rAction.type = "target";
        rAction.label = DB.getValue(nodeAction, "...name", "");
        rAction.order = SpellManager.getSpellActionOutputOrder(nodeAction);
        rAction.nSize = DB.getValue(nodeAction, "burstsize", "0");
		rAction.sFaction = DB.getValue(nodeAction, "targetfaction", "foe");
		if rAction.sFaction == '' then
			rAction.sFaction = "foe";
		end

        return rAction;
    else
        return fGetSpellAction(rActor, nodeAction, sSubRoll)
    end
end