-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local fCreateDisplay;
local fUpdateViews;

function onInit()
    fCreateDisplay = super.createDisplay;
    super.createDisplay = createDisplay;

    fUpdateViews = super.updateViews;
    super.updateViews = updateViews;

    if super and super.onInit then
        super.onInit();
    end
end

function onFirstLayout()
	local nodeAction = getDatabaseNode();
	local nodeChar = CloseEncounters.getActorNodeFromActionNode(nodeAction);
	local sType = DB.getValue(nodeAction, "type", "");
	if sType == "target" then
		CloseEncounters.addDbHandlers(nodeChar, onStoredTargetsCreated, onStoredTargetsRemoved)
		CloseEncounters.updateTargetIcon(nodeChar, targetbutton)
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
	CloseEncounters.updateTargetIcon(node, targetbutton);
end

function onStoredTargetsRemoved(node)
	if not DB.getName(node) == "hasStoredTargets" then
		return
	end
	CloseEncounters.updateTargetIcon(node, targetbutton);
end

function createDisplay(sType)
    fCreateDisplay(sType);

    if sType == "target" then
        createControl("spell_action_targetbutton", "targetbutton");
        createControl("spell_action_targetlabel", "targetlabel");
        createControl("spell_action_burstsize", "burstsize");
        createControl("spell_action_factionlabel", "factionlabel");
        createControl("spell_action_faction", "faction");
        createControl("list_storedtargets", "storedtargets");
    end
end

function updateViews()
    fUpdateViews();

    if super.m_sType == "target" then
        onTargetChanged();
    end
end

function onTargetChanged()
    
end