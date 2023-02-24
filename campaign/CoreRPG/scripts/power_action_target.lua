-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fUpdateDisplay;
local fUpdateViews;

function onInit()
	self.onDataChanged();
	DB.addHandler(getDatabaseNode(), "onChildUpdate", self.onDataChanged);
end

function onFirstLayout()
	local nodeChar = DB.getChild(getDatabaseNode(), ".....");
	CloseEncounters.addDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
	CloseEncounters.updateTargetIcon(nodeChar, targetbutton)
end

function onClose()
	local node = getDatabaseNode();
	local nodeChar = DB.getChild(node, ".....");
	CloseEncounters.removeDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
	DB.removeHandler(node, "onChildUpdate", self.onDataChanged);
end

function onStoredTargetsCreated(node)
	Debug.chat('onStoredTargetsCreated()');
	targetbutton.setIcons("button_clear", "button_clear_down");
end

function onStoredTargetsRemoved(node)
	Debug.chat('onStoredTargetsRemoved()');
	targetbutton.setIcons("button_targeting", "button_targeting_down");
end

function onDataChanged()
	local nodeAction = getDatabaseNode();
	local size = DB.getValue(nodeAction, "burstsize", 0);
	local faction = DB.getValue(nodeAction, "targetfaction", "");
	targetview.setValue(CloseEncounters.getActionText(faction, size))
end

function performAction(draginfo, sSubRoll)
	Debug.chat('power_action_target.performAction()', draginfo, sSubRoll)
	PowerActionsManagerCore.performAction(draginfo, getDatabaseNode(), { sSubroll = sSubroll })
end
