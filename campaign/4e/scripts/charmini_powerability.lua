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

	if super and super.onInit then
		super.onInit();
	end
end

-- abilitynode and abilitytype nodes don't have values when this is called from
-- onInit, so we have ot run it onFirstLayout instead.
function onFirstLayout()
	local nodeAbility = DB.findNode(abilitynode.getValue());
	local nodeChar = DB.getChild(nodeAbility, ".....");
	if abilitytype.getValue() == "target" then
		CloseEncounters.addDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
		CloseEncounters.updateTargetIcon(nodeChar, button)
	end
end

function onClose()
	local nodeAbility = DB.findNode(abilitynode.getValue());
	local nodeChar = DB.getChild(nodeAbility, ".....");
	if abilitytype.getValue() == "target" then
		CloseEncounters.removeDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
	end
end

function onStoredTargetsCreated(node)
	button.setIcons("button_clear", "button_clear_down");
end

function onStoredTargetsRemoved(node)
	button.setIcons("button_targeting", "button_targeting_down");
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
