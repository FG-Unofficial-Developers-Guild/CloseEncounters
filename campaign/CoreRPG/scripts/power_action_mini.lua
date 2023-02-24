-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fOnDataChanged = nil;

function onInit()
	fOnDataChanged = super.onDataChanged;
	super.onDataChanged = onDataChanged;

	if super and super.onInit then
		super.onInit();
	end
end

-- when onInit runs sType might be empty
-- so we attach handlers onFirstLayout instead.
function onFirstLayout()
	local nodeAction = getDatabaseNode();
	local nodeChar = DB.getChild(nodeAction, ".....");
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

	local nodeChar = DB.getChild(getDatabaseNode(), ".....");
	local sType = DB.getValue(getDatabaseNode(), "type", "");

	if sType == "target" then
		CloseEncounters.removeDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
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

function onDataChanged()
	Debug.chat('onDataChanged()');
	fOnDataChanged();
end