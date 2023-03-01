-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- when onInit runs sType might be empty
-- so we attach handlers onFirstLayout instead.
function onFirstLayout()
	local nodeAction = getDatabaseNode();
	local nodeChar = CloseEncounters.getActorNodeFromActionNode(getDatabaseNode());
	local sType = DB.getValue(getDatabaseNode(), "type", "");

	if sType == "target" then
		-- Add handlers for updating the icon when stored targets exist
		CloseEncounters.addDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
		CloseEncounters.updateTargetIcon(nodeChar, button)
	end
end

function onClose()
	if super and super.onClose then
		super.onClose();
	end

	local nodeChar = CloseEncounters.getActorNodeFromActionNode(getDatabaseNode());
	local sType = DB.getValue(getDatabaseNode(), "type", "");

	if sType == "target" then
		CloseEncounters.removeDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
	end
end

function onStoredTargetsCreated(node)
	if not DB.getName(node) == "hasStoredTargets" then
		return
	end
	CloseEncounters.updateTargetIcon(node, button);
end

function onStoredTargetsRemoved(node)
	if not DB.getName(node) == "hasStoredTargets" then
		return
	end
	CloseEncounters.updateTargetIcon(node, button);
end