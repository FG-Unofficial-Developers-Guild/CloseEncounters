-- Extension of CoreRPG's PowerManager

function onInit()
	PowerActionManagerCore.calcNextActionTypeOrder = calcNextActionTypeOrder;
	PowerManagerCore.registerDefaultPowerMenu = registerDefaultPowerMenu;
	PowerManagerCore.onDefaultPowerMenuSelection = onDefaultPowerMenuSelection;

	local tTargetActionHandlers = {
		fnGetButtonIcons = getActionButtonIcons,
		fnGetText = getActionText,
		fnGetTooltip = getActionTooltip,
		fnPerform = CloseEncounters.performAction,
	};

	PowerActionManagerCore.registerActionType("target", tTargetActionHandlers);
end

--------------------------------------------------------------------
-- TARGET ACTION FUNCTIONS
--------------------------------------------------------------------

function getActionButtonIcons(node, tData)
	if tData.sType == "target" then
		return CloseEncounters.getActionButtonIcon(node);
	end
	return "", "";
end

function getActionText(node, tData)
	if tData.sType == "target" then
        return CloseEncounters.getActionText(node);
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
    registerDefaultPowerMenuOriginal(w);
    local aSubMenus = { 3 };
    local aTypes = PowerActionManagerCore.getSortedActionTypes();
    local nTypes = #aTypes;
    if nTypes > 7 then
        w.registerMenuItem(Interface.getString("power_menu_extraactions"), "pointer", 3, 6);
        local nDepth = 1;
        for nIndex = 7, nTypes do
            local sType = aTypes[nIndex];
            local nDepth = #aSubMenus - 1;
            local nSubIndex = nIndex - (nDepth * 6); -- Six actions per submenu.
            local nPosition = resolveDefaultPowerMenuPosition(nDepth, nSubIndex);
            if (nSubIndex == 7) and (nIndex ~= nTypes) then
                table.insert(aSubMenus, nPosition);
                w.registerMenuItem(Interface.getString("power_menu_extraactions"), "pointer", unpack(aSubMenus));
                nDepth = nDepth + 1;
                nSubIndex = nSubIndex - 6;
                nPosition = resolveDefaultPowerMenuPosition(nDepth, nSubIndex);
            end
            table.insert(aSubMenus, nPosition);
            w.registerMenuItem(Interface.getString("power_menu_action_add_" .. sType), "radial_power_action_" .. sType, unpack(aSubMenus));
            table.remove(aSubMenus); -- The position needs to be there temporarily for unpacking, but nothing more.
        end
    end
end

function onDefaultPowerMenuSelection(w, selection, ...)
    local aSubSelections = {...};
    local nSubSelections = #aSubSelections;
    if (selection == 3) and (nSubSelections > 1) then
        local nIndexOffset = 6 * (nSubSelections - 1); -- Six actions per submenu.
        local nFinalSelection = aSubSelections[nSubSelections];
        local nIndex = nIndexOffset + resolveDefaultPowerMenuSelection(nDepth, nFinalSelection);
        local aTypes = PowerActionManagerCore.getSortedActionTypes();
        local sType = aTypes[nActionIndex];
        if sType then
            PowerManagerCore.createPowerAction(w, sType);
        end
    else
        onDefaultPowerMenuSelectionOriginal(w, selection, ...)
    end
end

function resolveDefaultPowerMenuPosition(nDepth, nSubIndex)
    -- The ruleset layer (depth 0) pivots around position 7 and each submenu moves forward by 3.
    -- 1 must be subtracted and re-added to account for 1-based indexing.
    return ((nSubIndex + 6 + (3 * nDepth)) % 8) + 1;
end

function resolveDefaultPowerMenuSelection(nDepth, nPosition)
    -- The ruleset layer (depth 0) pivots around position 7 and each submenu moves forward by 3.
    return 7 - ((6 + (3 * nDepth) - nPosition) % 8);
end