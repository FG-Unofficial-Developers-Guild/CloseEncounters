-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fSetAbility;
local fAction;

function onInit()
	fSetAbility = super.setAbility;
	fAction = super.action;

	super.setAbility = setAbility;
	super.action = action;
end

function setAbility(sType, nodeAbility, sTooltip)
	if sType == "target" then
		button.setIcons("button_targeting", "button_targeting_down");
	end
	
	fSetAbility(sType, nodeAbility, sTooltip);
end

function action(draginfo)
	fAction(draginfo);

	local sType = abilitytype.getValue();
	local nodeAbility = DB.findNode(abilitynode.getValue());
	
	if sType == "target" then
		CharManager.onPowerAbilityAction(draginfo, nodeAbility);
	end
end
