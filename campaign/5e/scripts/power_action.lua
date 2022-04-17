-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fUpdateDisplay;
local fUpdateViews;

function onInit()
	fUpdateDisplay = super.updateDisplay;
	super.updateDisplay = updateDisplay;

    fUpdateViews = super.updateViews;
    super.updateViews = updateViews

	super.onInit()
end

function updateDisplay()
	fUpdateDisplay();

	local node = getDatabaseNode();
	local sType = DB.getValue(node, "type", "");
	local isTarget = sType == "target";

	targetbutton.setVisible(isTarget);
	targetlabel.setVisible(isTarget);
	burstsize.setVisible(isTarget);
	factionlabel.setVisible(isTarget);
	targetfaction.setVisible(isTarget);
end

function updateViews()
    fUpdateViews();
    local sType = DB.getValue(getDatabaseNode(), "type", "");
    if sType == "target" then
        onTargetingChanged();
    end
end

function onTargetingChanged()
	local s = PowerManager.getPowerAbilityString("target", getDatabaseNode());
	attackview.setValue(s);
end
