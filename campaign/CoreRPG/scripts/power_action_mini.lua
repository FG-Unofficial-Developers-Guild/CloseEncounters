-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	DB.addHandler(getDatabaseNode(), "onChildUpdate", self.onTargetingChanged);
end

-- when onInit runs sType might be empty
-- so we attach handlers onFirstLayout instead.
function onFirstLayout()
	local nodeAction = getDatabaseNode();
	local nodeChar = DB.getChild(nodeAction, ".....");
	local sType = DB.getValue(getDatabaseNode(), "type", "");

	if sType == "target" then
		CloseEncounters.addDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
		CloseEncounters.updateTargetIcon(nodeChar, button)
	end
end

function onClose()
	local nodeChar = DB.getChild(getDatabaseNode(), ".....");
	local sType = DB.getValue(getDatabaseNode(), "type", "");

	if sType == "target" then
		CloseEncounters.removeDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
		DB.removeHandler(getDatabaseNode(), "onChildUpdate", self.onTargetingChanged);
	end
end

function onStoredTargetsCreated(node)
	Debug.chat('onStoredTargetsCreated()');
	button.setIcons("button_clear", "button_clear_down");
end

function onStoredTargetsRemoved(node)
	Debug.chat('onStoredTargetsRemoved()');
	button.setIcons("button_targeting", "button_targeting_down");
end


function onTargetingChanged()
	local s = PowerManager.getPCPowerTargetActionText(getDatabaseNode());
	button.setTooltipText(s);
end
