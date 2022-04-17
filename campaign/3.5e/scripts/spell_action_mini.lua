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