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

    if super and super.onInit then
        super.onInit();
    end    
end

-- when onInit runs sType might be empty
-- so we attach handlers onFirstLayout instead.
function onFirstLayout()
	local nodeAction = getDatabaseNode();
	local nodeChar = CloseEncounters.getActorNodeFromActionNode(nodeAction);
	local sType = DB.getValue(nodeAction, "type", "");
	if sType == "target" then
		CloseEncounters.addDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
		CloseEncounters.updateTargetIcon(nodeChar, button)
	end
end

function onClose()
	local nodeAction = getDatabaseNode();
	local nodeChar = CloseEncounters.getActorNodeFromActionNode(nodeAction);
	local sType = DB.getValue(nodeAction, "type", "");
	
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

function updateDisplay()
    fUpdateDisplay();

	local node = getDatabaseNode();
    local sType = DB.getValue(node, "type", "");
    if sType == "target" then
        CloseEncounters.updateTargetIcon(node, button);
    end
end

function updateViews()
	fUpdateViews();
	
    local sType = DB.getValue(getDatabaseNode(), "type", "");
    if sType == "target" then
        local node = getDatabaseNode();
        local size = DB.getValue(node, "burstsize", 0);
        local faction = DB.getValue(node, "targetfaction", "");
        button.setTooltipText(CloseEncounters.getActionText(faction, size));
    end
end