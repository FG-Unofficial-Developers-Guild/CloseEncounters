-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
-- 4e stuff
local fGetPowerAbilityString;
local fOnPowerAbilityAction

function onInit()
	fGetPowerAbilityString = PowerManager.getPowerAbilityString;
	PowerManager.getPowerAbilityString = getPowerAbilityString;

	fOnPowerAbilityAction = CharManager.onPowerAbilityAction;
	CharManager.onPowerAbilityAction = onPowerAbilityAction;
end

-- PERFORM ACTION 4E
function getPowerAbilityString(sType, nodeAbility)
	local s = fGetPowerAbilityString(sType, nodeAbility);

	if sType == "target" then
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


		s = "Target " .. sFaction  .. " within " .. size .. " " .. sRange;
	end

	return s;
end

function onPowerAbilityAction(draginfo, nodeAbility, subtype)
	-- if the original runs, then return true;
	if fOnPowerAbilityAction(draginfo, nodeAbility, subtype) then
		return true;
	end

	local sAbilityType = DB.getValue(nodeAbility, "type", "");
	if sAbilityType == "target" then
		local rActor = ActorManager.resolveActor(nodeAbility.getChild("....."))
		local rSourceNode = DB.findNode(rActor.sCreatureNode)
		local nodeCT = CombatManager.getCTFromNode(nodeAbility.getChild("....."));
		local nDistance = DB.getValue(nodeAbility, "burstsize", 0);
		local sFaction = DB.getValue(nodeAbility, "targetfaction", "foe");
		if sFaction == '' then
			sFaction = "foe";
		end

		CloseEncounters.toggleTargeting(rActor, nDistance, sFaction);
		return true;
	end	

	return false;
end