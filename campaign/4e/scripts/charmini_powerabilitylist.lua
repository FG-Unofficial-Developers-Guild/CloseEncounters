-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fCreateEntries;

function onInit()
	fCreateEntries = super.createEntries;
	super.createEntries = createEntries;

	super.onInit();
end

function createEntries(nodeAbility)
	local sType = DB.getValue(nodeAbility, "type", "");
	if sType == "target" then
		super.createEntryWindow("target", nodeAbility);
	else
		fCreateEntries(nodeAbility);
	end
end
