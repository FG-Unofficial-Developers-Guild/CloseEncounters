-- Extension of CoreRPG's PowerManager

function onInit()
	PowerActionManagerCore.calcNextActionTypeOrder = calcNextActionTypeOrder;
	PowerManagerCore.registerDefaultPowerMenu = registerDefaultPowerMenu;
	PowerManagerCore.onDefaultPowerMenuSelection = onDefaultPowerMenuSelection;

	local tTargetActionHandlers = {
		fnGetButtonIcons = getActionButtonIcons,
		fnGetText = getActionText,
		fnGetTooltip = getActionTooltip,
		fnPerform = CloseEncounters.performAction, -- I don't understand why this function isn't getting called
	};

	PowerActionManagerCore.registerActionType("target", tTargetActionHandlers);
end

--------------------------------------------------------------------
-- TARGET ACTION FUNCTIONS
--------------------------------------------------------------------

function getActionButtonIcons(node, tData)
	if tData.sType == "target" then
		return "button_action_resource", "button_action_resource_down";
	end
	return "", "";
end

function getActionText(node, tData)
	if tData.sType == "target" then
        local size = DB.getValue(node, "burstsize", 0);
        local faction = DB.getValue(node, "targetfaction", "");
        return CloseEncounters.getActionText(faction, size);
    end
	return "";
end

function getActionTooltip(node, tData)
	return getActionText(node, tData);
end

--------------------------------------------------------------------
-- MAKING RADIAL MENUS WORKABLE. TAKEN FROM CAPITAL GAINS
--------------------------------------------------------------------
function calcNextActionTypeOrder()
	return #PowerActionManagerCore.getSortedActionTypes();
end

function registerDefaultPowerMenu(w)
	w.registerMenuItem(Interface.getString("list_menu_deleteitem"), "delete", 6);
	w.registerMenuItem(Interface.getString("list_menu_deleteconfirm"), "delete", 6, 7);

	local aSubMenus = { 3 };
	local aTypes = PowerActionManagerCore.getSortedActionTypes();
	local nTypes = #aTypes;
	if nTypes > 0 then
		w.registerMenuItem(Interface.getString("power_menu_action_add"), "pointer", 3);
	end
	for nIndex = 1, nTypes do
		local sType = aTypes[nIndex];
		local nDepth = #aSubMenus - 1;
		local nPosition = nIndex - (nDepth * 6); -- Six actions per submenu.
		nPosition = nPosition + 1; -- Account for initial offset in each menu.
		if nPosition >= getDefaultPowerMenuSkipPosition(nIndex) then
			nPosition = nPosition + 1;
		end
		if nPosition == 9 then
			if nIndex == aTypes then
				-- Add the final action in the top slot.
				nPosition = 1;
			else
				-- Add another layer and start at the start.
				table.insert(aSubMenus, 1);
				w.registerMenuItem(Interface.getString("power_menu_extraactions"), "pointer", unpack(aSubMenus));
				nPosition = 2;
			end
		end

		table.insert(aSubMenus, nPosition);
		w.registerMenuItem(Interface.getString("power_menu_action_add_" .. sType), "radial_power_action_" .. sType, unpack(aSubMenus));
		table.remove(aSubMenus); -- The position needs to be there temporarily for unpacking, but nothing more.
	end

	if _tHandlers and _tHandlers.fnParse then
		w.registerMenuItem(Interface.getString("power_menu_action_reparse"), "textlist", 4);
	end
end

function onDefaultPowerMenuSelection(w, selection, ...)
	local aSubSelections = {...};
	if selection == 6 and aSubSelections[1] == 7 then
		DB.deleteNode(w.getDatabaseNode());
	elseif selection == 4 then
		PowerManagerCore.parsePower(w.getDatabaseNode());
		if w.activatedetail then
			w.activatedetail.setValue(1);
		end
	elseif selection == 3 then
		local nSubSelections = #aSubSelections;
		local nIndexOffset = 6 * (nSubSelections - 1); -- Six actions per submenu.
		local nFinalSelection = aSubSelections[nSubSelections];
		nFinalSelection = ((nFinalSelection + 6) % 8) + 1; -- Account for initial offset in each menu.
		if nFinalSelection > getDefaultPowerMenuSkipPosition(nIndexOffset + nFinalSelection) then
			nFinalSelection = nFinalSelection - 1;
		end

		local nActionIndex = nIndexOffset + nFinalSelection;
		local aTypes = PowerActionManagerCore.getSortedActionTypes();
		local sType = aTypes[nActionIndex];
		if sType then
			PowerManagerCore.createPowerAction(w, sType);
		end
	end
end

function getDefaultPowerMenuSkipPosition(nActionIndex)
	if nActionIndex > 7 then
		return 5;
	else
		return 7;
	end
end