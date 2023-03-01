-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
-- 4e stuff
local fGetPowerAbilityString;

function onInit()
	fGetPowerAbilityString = PowerManager.getPowerAbilityString;
	PowerManager.getPowerAbilityString = getPowerAbilityString;
end

function getPowerAbilityString(sType, nodeAbility)
	local s = "";

	if sType == "target" then		
		s = CloseEncounters.getActionText(nodeAbility)
	else
		s = fGetPowerAbilityString(sType, nodeAbility);
	end

	return s;
end