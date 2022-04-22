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

function createDisplay(sType)
    fCreateDisplay(sType);

    if sType == "target" then
        createControl("spell_action_targetbutton", "targetbutton");
        createControl("spell_action_targetlabel", "targetlabel");
        createControl("spell_action_burstsize", "burstsize");
        createControl("spell_action_factionlabel", "factionlabel");
        createControl("spell_action_targetfaction", "targetfaction");
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