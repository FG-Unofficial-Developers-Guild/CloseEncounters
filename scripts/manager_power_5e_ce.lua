-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fPerformAction;
local fGetPCPowerAction;

function onInit()
	PowerManager.getPCPowerTargetActionText = getPCPowerTargetActionText;

	fPerformAction = PowerManager.performAction;
	PowerManager.performAction = performAction;

	fGetPCPowerAction = PowerManager.getPCPowerAction;
	PowerManager.getPCPowerAction = getPCPowerAction;
end

function getPCPowerTargetActionText(nodeAbility)
	local sTarget = "";

	local size = DB.getValue(nodeAbility, "burstsize", 0);
	local faction = DB.getValue(nodeAbility, "targetfaction", "");
	local sFaction = "enemies";
	if faction == "friend" then
		sFaction = "allies";
	elseif faction == "all" then
		sFaction = "everyone"
	end

	local sRange = "squares";
	if size == 1 then
		sRange = "square";
	end

	sTarget = "Target " .. sFaction  .. " within " .. size .. " " .. sRange;

	return sTarget;
end

function getPCPowerAction(nodeAction, sSubRoll)
	if not nodeAction then
		return;
	end
	local rActor = ActorManager.resolveActor(nodeAction.getChild("....."));
	if not rActor then
		return;
	end
	
	local rAction = {};
	rAction.type = DB.getValue(nodeAction, "type", "");
	rAction.label = DB.getValue(nodeAction, "...name", "");
	rAction.order = PowerManager.getPCPowerActionOutputOrder(nodeAction);
	
	if rAction.type == "target" then
		rAction.nSize = DB.getValue(nodeAction, "burstsize", "0");
		rAction.sFaction = DB.getValue(nodeAction, "targetfaction", "foe");
		if rAction.sFaction == '' then
			rAction.sFaction = "foe";
		end
	else
		return fGetPCPowerAction(nodeAction, sSubRoll);
	end
	
	return rAction, rActor;
end

function performAction(draginfo, rActor, rAction, nodePower)
	if rAction.type == "target" then
		CloseEncounters.toggleTargeting(rActor, rAction.nSize, rAction.sFaction);
		return true;
	end

	return fPerformAction(draginfo, rActor, rAction, nodePower);
end