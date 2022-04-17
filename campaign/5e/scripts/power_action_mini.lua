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
    super.updateViews = updateViews;

	super.onInit();
end

function updateDisplay()
    fUpdateDisplay();
	local sType = DB.getValue(getDatabaseNode(), "type", "");
	if sType == "target" then
		button.setIcons("button_targeting", "button_targeting_down");
	end
end

function updateViews()
	fUpdateViews();
	
	local sType = DB.getValue(getDatabaseNode(), "type", "");
	if sType == "target" then
		onTargetingChanged();
	end
end

function onTargetingChanged()
	local s = PowerManager.getPCPowerTargetActionText(getDatabaseNode());
	button.setTooltipText(s);
end
