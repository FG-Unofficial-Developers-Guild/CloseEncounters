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
	local nodeChar = DB.getChild(getDatabaseNode(), ".........");
	local sType = DB.getValue(getDatabaseNode(), "type", "");
	if sType == "target" then
		DB.addHandler(DB.getPath(nodeChar, "storedtargets"), "onAdd", onStoredTargetsCreated)
		DB.addHandler(DB.getPath(nodeChar, "storedtargets"), "onDelete", onStoredTargetsRemoved)

		if nodeChar.getChild("storedtargets") then
			button.setIcons("button_clear", "button_clear_down");
		end
	end
end

function onClose()
	local nodeChar = DB.getChild(getDatabaseNode(), ".....");
	local sType = DB.getValue(getDatabaseNode(), "type", "");
	if sType == "target" then
		DB.removeHandler(DB.getPath(nodeChar, "storedtargets"), "onAdd", onStoredTargetsCreated)
		DB.removeHandler(DB.getPath(nodeChar, "storedtargets"), "onDelete", onStoredTargetsRemoved)
	end
end

function onStoredTargetsCreated(node)
	button.setIcons("button_clear", "button_clear_down");
end

function onStoredTargetsRemoved(node)
	button.setIcons("button_targeting", "button_targeting_down");
end

function updateDisplay()
    fUpdateDisplay();

    local sType = DB.getValue(getDatabaseNode(), "type", "");
    if sType == "target" then
        button.setIcons("button_targeting", "button_targeting_down");
    end
end

function updateViews()
    local sType = DB.getValue(getDatabaseNode(), "type", "");
    if sType == "target" then
        local node = getDatabaseNode();
        local size = DB.getValue(node, "burstsize", 0);
        local faction = DB.getValue(node, "targetfaction", "");
        button.setTooltipText(CloseEncounters.getActionText(faction, size));
    end
end