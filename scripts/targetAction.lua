-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_SELECTTARGETS = "SELECT_TARGETS"
OOB_MSGTYPE_RESTORETARGETS = "RESTORE_TARGETS"

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_SELECTTARGETS, handleSelectTargets);
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_RESTORETARGETS, handleRestoreTargets);

	CombatManager.setCustomTurnEnd(onTurnEnd);
end

-- Handle DB watchers for stored targets
function addDbHandlers(charnode, callback)
	if charnode and callback then
		DB.addHandler(DB.getPath(charnode, "storedtargets"), "onUpdate", callback)
		return true;
	end

	return false;
end

function removeDbHandlers(charnode, callback)
	if charnode and callback then
		DB.removeHandler(DB.getPath(charnode, "storedtargets"), "onUpdate", callback)
		return true;
	end

	return false;
end

-- Automatically revert to stored targets on turn end
function onTurnEnd(nodeCT)
	if not nodeCT then
		return;
	end

	local rActor = ActorManager.resolveActor(nodeCT)
	local rSourceNode = DB.findNode(rActor.sCreatureNode)

	local stored = rSourceNode.getChild("storedtargets");
	if not stored then
		return;
	end

	if OptionsManager.isOption("CE_RTET", "off") then
		return;
	end

	CloseEncounters.clearAndRestore(rSourceNode);
end

function toggleTargeting(rActor, nDistance, sFaction)
	if not rActor then
		return;
	end
	
	local node = DB.findNode(rActor.sCreatureNode);
	if not node then
		return;
	end	

	if node.getChild("storedtargets") then
		CloseEncounters.sendRestoreTargetsMsg(rActor.sCreatureNode);
	else
		CloseEncounters.sendSelectTargetsMsg(rActor.sCreatureNode, nDistance, sFaction);
	end
end

function getActionText(faction, size)
	local sFaction = "enemies";
	if faction == "friend" then
		sFaction = "allies";
	elseif faction == "all" then
		sFaction = "everyone"
	end

	local sRange = "squares";
	if size == 1 then
		sRange = "square";
	end


	return "Target " .. sFaction  .. " within " .. size .. " " .. sRange;
end

------------------ TARGET ACTION ---------------------------
function sendSelectTargetsMsg(rSourceNode, nDistance, sFaction)
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_SELECTTARGETS;
	msgOOB.sourcenode = rSourceNode;
	msgOOB.nDistance = nDistance;
	msgOOB.sFaction = sFaction;

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleSelectTargets(msgOOB)
	local node = DB.findNode(msgOOB.sourcenode);
	if not node then
		return;
	end

	local nDistance = tonumber(msgOOB.nDistance) or 0;
	local sFaction = msgOOB.sFaction or "";

	storeAndTarget(node, nDistance, sFaction);
	
end

function storeAndTarget(node, nDistance, sFaction)
	local nodeCT = CombatManager.getCTFromNode(node);
	if not nodeCT then
		return;
	end

	CloseEncounters.storeExistingTargets(node);

	TargetingManager.clearCTTargets(nodeCT, tokenCT)

	CloseEncounters.targetAllWithinDistance(node, nDistance, sFaction);
end

function storeExistingTargets(node)
	if not node then
		return;
	end
	local nodeCT = CombatManager.getCTFromNode(node);
	if not nodeCT then
		return;
	end
	
	sourcepath = nodeCT.getPath() .. "." .. "targets";
	destinationpath = node.getPath() .. "." .. "storedtargets";

	if not DB.findNode(sourcepath) then
		-- If targets doesn't exist, create an empty node
		nodeCT.createChild("targets");
	end

	-- Store targets to the character sheet
	DB.copyNode(sourcepath, destinationpath);
end

function targetAllWithinDistance(node, nDistance, sFaction, bIgnoreVisible)
	local finaltargets = {};

	local nodeCT = CombatManager.getCTFromNode(node);

	if nodeCT then
		local tokenCT = CombatManager.getTokenFromCT(nodeCT);
		if tokenCT then
			local targets = Token.getTokensWithinDistance(tokenCT, nDistance);

			for _,token in ipairs(targets) do
				local targetCT = CombatManager.getCTFromToken(token);

				if sFaction == "all" or ActorManager.getFaction(targetCT) == sFaction then
					if bIgnoreVisible or token.isVisible() then
						table.insert(finaltargets, targetCT);
					end
				end
			end
		end
	end

	if #finaltargets > 0 then
		for _, targetCT in ipairs(finaltargets) do
			TargetingManager.addCTTarget(nodeCT, targetCT);
		end
	end
end

------------------ RESTORE ACTION ---------------------------
function sendRestoreTargetsMsg(rSourceNode)
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_RESTORETARGETS;
	msgOOB.sourcenode = rSourceNode;

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleRestoreTargets(msgOOB)
	local node = DB.findNode(msgOOB.sourcenode);
	if not node then
		return;
	end	

	CloseEncounters.clearAndRestore(node);
end

function clearAndRestore(node)
	if not node then
		return;
	end

	local nodeCT = CombatManager.getCTFromNode(node);
	if not nodeCT then
		return;
	end

	TargetingManager.clearCTTargets(nodeCT, tokenCT);

	CloseEncounters.restoreExistingTargets(node)
end

function restoreExistingTargets(node)
	if not node then
		return;
	end

	local nodeCT = CombatManager.getCTFromNode(node);
	if not nodeCT then
		return;
	end

	local stored = node.getChild("storedtargets");
	if not stored then
		return;
	end

	local targetnodes = stored.getChildren();
	for _,target in pairs(targetnodes) do
		local noderef = DB.getValue(target, "noderef", "");
		if noderef ~= "" then
			local targetNode = DB.findNode(noderef);
			if targetNode then
				TargetingManager.addCTTarget(nodeCT, targetNode);
			end
		end
	end

	stored.delete();
end

------------------ DEBUG ---------------------------

function printDebugTargets(node)
	if not node then
		return;
	end

	local targets = TargetingManager.getFullTargets(ActorManager.resolveActor(node));

	Debug.chat(targets);
end

function printDebugStoredTargets(node)
	if not node then
		return;
	end

	local stored = node.getChild("storedtargets");
	if not stored then
		return;
	end

	local storedTargets = {};
	local targetnodes = stored.getChildren();
	for _,target in pairs(targetnodes) do
		local noderef = DB.getValue(target, "noderef", "");
		if noderef ~= "" then
			local targetNode = DB.findNode(noderef);
			local targetActor = ActorManager.resolveActor(targetNode);
			if targetActor then
				table.insert(storedTargets, targetActor);
			end
		end
	end

	Debug.chat(storedTargets);
end