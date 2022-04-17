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
end

function onTargetChanged()
	local s = PowerManager.getPowerAbilityString("target", getDatabaseNode());
	attackview.setValue(s);
end
