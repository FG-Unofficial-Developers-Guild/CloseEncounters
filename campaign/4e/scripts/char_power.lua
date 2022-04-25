-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
local fOnMenuSelection;

function onInit()
	if super and super.onMenuSelection then
		fOnMenuSelection = super.onMenuSelection;
		super.onMenuSelection = onMenuSelection;
	end

	if super and super.onInit then
		super.onInit();
	end

	registerMenuItem(Interface.getString("menu_poweraddtarget"), "pointer_square", 2, 1);
end

function onMenuSelection(selection, subselection)
	fOnMenuSelection(selection, subselection);
	if selection == 2 then
		if subselection == 1 then
			local wnd = abilities.createWindow();
			if wnd then
				DB.setValue(wnd.getDatabaseNode(), "type", "string", "target");
				activateabilities.setValue(1);
			end
		end
	end
end