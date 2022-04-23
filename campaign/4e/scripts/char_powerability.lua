-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fUpdateDisplay;

function onInit()
	fUpdateDisplay = super.updateDisplay;
	super.updateDisplay = updateDisplay;

	super.onInit()
end

function onFirstLayout()
	local nodeChar = DB.getChild(getDatabaseNode(), ".....");
	local sType = DB.getValue(getDatabaseNode(), "type", "");
	if sType == "target" then
		CloseEncounters.addDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
		CloseEncounters.updateTargetIcon(nodeChar, targetbutton)
	end
end

function onClose()
	local nodeChar = DB.getChild(getDatabaseNode(), ".....");
	local sType = DB.getValue(getDatabaseNode(), "type", "");
	if sType == "target" then
		CloseEncounters.removeDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
	end
end

function onStoredTargetsCreated(node)
	targetbutton.setIcons("button_clear", "button_clear_down");
end

function onStoredTargetsRemoved(node)
	targetbutton.setIcons("button_targeting", "button_targeting_down");
end

function updateDisplay()
	fUpdateDisplay();

	local node = getDatabaseNode();
	local sType = DB.getValue(node, "type", "");
	local isTarget = sType == "target"

	targetbutton.setVisible(isTarget);
	targetlabel.setVisible(isTarget);
	burstsize.setVisible(isTarget);
	factionlabel.setVisible(isTarget);
	targetfaction.setVisible(isTarget);
	storedtargets.setVisible(isTarget);
end

function onTargetChanged()
	local s = PowerManager.getPowerAbilityString("target", getDatabaseNode());
	attackview.setValue(s);
end
