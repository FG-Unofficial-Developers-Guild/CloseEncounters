-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fUpdateDisplay;
local fUpdateViews;

function onInit()
	local nodeAction = getDatabaseNode();

	self.onDataChanged();

	DB.addHandler(nodeAction, "onChildUpdate", self.onDataChanged);
end

function onFirstLayout()
	local node = getDatabaseNode();
	local nodeChar = CloseEncounters.getActorNodeFromActionNode(node);
	CloseEncounters.addDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
	CloseEncounters.updateTargetIcon(nodeChar, targetbutton)
end

function onClose()
	local node = getDatabaseNode();
	local nodeChar = CloseEncounters.getActorNodeFromActionNode(node);

	CloseEncounters.removeDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
	DB.removeHandler(node, "onChildUpdate", self.onDataChanged);
end

function onStoredTargetsCreated(node)
	if not DB.getName(node) == "hasStoredTargets" then
		return
	end
	CloseEncounters.updateTargetIcon(node, targetbutton);
end

function onStoredTargetsRemoved(node)
	if not DB.getName(node) == "hasStoredTargets" then
		return
	end
	CloseEncounters.updateTargetIcon(node, targetbutton);
end

function onDataChanged()
	local nodeAction = getDatabaseNode();
	targetview.setValue(CloseEncounters.getActionText(nodeAction))
end

function performAction(draginfo, sSubRoll)
	PowerActionManagerCore.performAction(draginfo, getDatabaseNode(), { sSubroll = sSubroll })
end
