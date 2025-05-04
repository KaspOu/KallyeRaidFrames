local _, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end


local DEFAULT_MAXBUFFS = ns.DEFAULT_MAXBUFFS or 3
local DEFAULT_MAXDEBUFFS = DEFAULT_MAXBUFFS
local MAX_RETRIES = 5
--[[
! Manage buffs
- Scale buffs / debuffs
]]
		-- ! Blizzard original method modified, from CompactUnitFrame
		function ns.CompactUnitFrame_UpdateAurasInternal(frame, unitAuraUpdateInfo)
			if frame.isLootObject then
				return;
			end

			local displayOnlyDispellableDebuffs = CompactUnitFrame_GetOptionDisplayOnlyDispellableDebuffs(frame, frame.optionTable);
			local ignoreBuffs = not frame.buffFrames or not frame.optionTable.displayBuffs or frame.maxBuffs == 0;
			local displayDebuffs = CompactUnitFrame_GetOptionDisplayDebuffs(frame, frame.optionTable);
			local ignoreDebuffs = not frame.debuffFrames or not displayDebuffs or frame.maxDebuffs == 0;
			local ignoreDispelDebuffs = ignoreDebuffs or not frame.dispelDebuffFrames or not frame.optionTable.displayDispelDebuffs or frame.maxDispelDebuffs == 0;

			-- modification start
			local maxBuffs = _G[ns.OPTIONS_NAME].MaxBuffs
    		local maxDebuffs = _G[ns.OPTIONS_NAME].MaxDebuffs
			local debuffsChanged = not ignoreBuffs;
			local buffsChanged = not ignoreDebuffs;
			-- modification end

			if debuffsChanged then
				local frameNum = 1;
				-- local maxDebuffs = frame.maxDebuffs; -- modification
				frame.debuffs:Iterate(function(auraInstanceID, aura)
					if frameNum > maxDebuffs then
						return true;
					end

					if CompactUnitFrame_IsAuraInstanceIDBlocked(frame, auraInstanceID) then
						return false;
					end

					local debuffFrame = frame.debuffFrames[frameNum];
					CompactUnitFrame_UtilSetDebuff(debuffFrame, aura);
					frameNum = frameNum + 1;

					if aura.isBossAura then
						-- Boss auras are about twice as big as normal debuffs, so we may need to display fewer buffs
						local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize;
						maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
					end

					return false;
				end);

				CompactUnitFrame_HideAllDebuffs(frame, frameNum);
				CompactUnitFrame_UpdatePrivateAuras(frame);
			end

			if buffsChanged then
				local frameNum = 1;
				-- local maxBuffs = frame.maxBuffs; -- modification
				frame.buffs:Iterate(function(auraInstanceID, aura)
					if frameNum > maxBuffs then
						return true;
					end
					local buffFrame = frame.buffFrames[frameNum];
					CompactUnitFrame_UtilSetBuff(buffFrame, aura);
					frameNum = frameNum + 1;

					return false;
				end);

				CompactUnitFrame_HideAllBuffs(frame, frameNum);
			end
			-- modification (remove dispelsChanged)
		end

local function FrameIsCompact(frame)
	local getName = frame:GetName();
	return getName ~=nil and strsub(getName, 0, 7) == "Compact"
end
local function FrameIsPet(frame)
	local getName = frame:GetName();
	return getName ~=nil and string.find(getName, "Pet") ~= nil
end


local OrientationEnum = {
    LeftThenUp = "LeftThenUp",
    UpThenLeft = "UpThenLeft",
    RightThenUp = "RightThenUp",
    UpThenRight = "UpThenRight"
}

local function anchorPoints(frameIdx, lineSize, orientation)
	local isNewLine = (lineSize ~= nil) and (math.fmod(frameIdx-1, lineSize) == 0)
	local relatedIdx = isNewLine and (frameIdx-lineSize) or (frameIdx-1)

	local alignments = {
		-- orientation =  point, relatedPoint, newLineRelatedPoint
		[OrientationEnum.LeftThenUp] = { "BOTTOMRIGHT", "BOTTOMLEFT", "TOPRIGHT" },
		[OrientationEnum.UpThenLeft] = { "BOTTOMRIGHT", "TOPRIGHT", "BOTTOMLEFT" },
		[OrientationEnum.RightThenUp]= { "BOTTOMLEFT", "BOTTOMRIGHT", "TOPLEFT" },
		[OrientationEnum.UpThenRight]= { "BOTTOMLEFT", "TOPLEFT", "BOTTOMRIGHT" },
	}
	local selectedAlignment = alignments[orientation] or alignments[OrientationEnum.LeftThenUp]

	local point, relatedPoint =
		selectedAlignment[1],
		(not isNewLine) and selectedAlignment[2] or selectedAlignment[3];
	return isNewLine, point, relatedIdx, relatedPoint
end

--[[
! ERREURS !
 *ClearAllPoints
 *frame[BLIZZARD_MAX_PROP] = maxCount

TODO Prévoir un message d'alerte qui s'affiche si on change le count (ns.WillTaint)
  * Une fois par session vous aurez une erreur à la mort d'un boss, c'est "normal"
--]]

--- Manage the display and scaling of buffs & debuffs on group frames.
--- @param frame frame The parent frame on which buffs or debuffs are displayed.
--- @param frameChilds table Table containing child frames (buffs/debuffs).
--- @param frameType string Type of frames to manage ('Buff', 'Debuff', 'DispelDebuff').
--- @param defaultMax number Blizzard max default.
--- @param maxCount number Maximum number of buffs/debuffs to display.
--- @param scale number Scale factor for the buffs/debuffs.
--- @param lineSize number Number of slots per line
--- @param orientation string OrientationEnum: Determines the alignment.
--- @param blizzardOrientation string OrientationEnum: Blizzard original alignment
--- @param useTaintMethod boolean Allow taints (maxBuffs, maxDebuffs)
--- @param retries number Number of retries (avoid combatlockdown after a boss kill)
local function ManageUnitFrames(frame, frameChilds, frameType, defaultMax, maxCount, scale, lineSize, orientation, blizzardOrientation, useTaintMethod, retries)
	if not FrameIsCompact(frame) or FrameIsPet(frame) then
		return
	end
	if InCombatLockdown() or frame:IsForbidden() then
		retries = retries or 0
		if retries <= MAX_RETRIES then
			local delayInSeconds = retries + 1 -- increases delay after each retry
			C_Timer.After(delayInSeconds, function()
				ManageUnitFrames(frame, frameChilds, frameType, defaultMax, maxCount, scale, lineSize, orientation, blizzardOrientation, useTaintMethod, retries + 1)
			end)
		end
		return
	end
    local frameName = frame:GetName() .. frameType

	local BLIZZARD_MAX_PROP = "max"..frameType.."s" -- frame.maxBuffs / .maxDebuffs / .maxDispelDebuff
	local defaultMaxProp = "defaultMax"..frameType.."s" -- save BLizzard MAX first time
	frame[defaultMaxProp] = frame[defaultMaxProp] or frame[BLIZZARD_MAX_PROP]

	if maxCount > frame[defaultMaxProp] or lineSize < maxCount or orientation ~= blizzardOrientation then
		-- add missing icons and re-SetPoints
		-- TODO reposition first icon
		-- start loop at first icon not matching blizz positioning
		local loopStart = math.min(defaultMax + 1, lineSize + 1)
		if orientation ~= blizzardOrientation then
			loopStart = 2
		end
		for childIdx = loopStart, maxCount do
			local isNewChild = false
			local child = _G[frameName .. childIdx]
			if not _G[frameName .. childIdx] then
				child = CreateFrame("Button", frameName .. childIdx, frame, "Compact" .. frameType .. "Template")
				child:SetScale(scale)
				isNewChild = true
			end
			local isNewLine, point, relativeIdx, relativePoint = anchorPoints(childIdx, lineSize, orientation)
			if isNewChild or isNewLine or orientation ~= blizzardOrientation then
				-- child:ClearAllPoints();
				child:SetPoint(point, _G[frameName .. relativeIdx], relativePoint)
			end
		end
	end
	if useTaintMethod and maxCount ~= frame[BLIZZARD_MAX_PROP] then
		frame[BLIZZARD_MAX_PROP] = maxCount -- ! Taints frame
	end

	-- rescaling
    local lastScale = frame:GetAttribute("_lastScale") or 1
    if lastScale ~= scale then
		for _, child in ipairs(frameChilds) do
			child:SetScale(scale);
		end
		frame:SetAttribute("_lastScale", scale)
    end
end

function ns.Hook_ManageBuffs(frame)
    local max = _G[ns.OPTIONS_NAME].MaxBuffs
    local scale = _G[ns.OPTIONS_NAME].BuffsScale
	local slotsPerLine = _G[ns.OPTIONS_NAME].BuffsPerLine
	local orientation = not _G[ns.OPTIONS_NAME].BuffsVertical and OrientationEnum.LeftThenUp or OrientationEnum.UpThenLeft
	local useTaintMethod = _G[ns.OPTIONS_NAME].UseTaintMethod
	ManageUnitFrames(frame, frame.buffFrames, "Buff", DEFAULT_MAXBUFFS, max, scale, slotsPerLine, orientation, OrientationEnum.LeftThenUp, useTaintMethod, 0)
end

function ns.Hook_ManageDebuffs(frame)
    local max = _G[ns.OPTIONS_NAME].MaxDebuffs
    local scale = _G[ns.OPTIONS_NAME].DebuffsScale
	local slotsPerLine = _G[ns.OPTIONS_NAME].DebuffsPerLine
	local orientation = not _G[ns.OPTIONS_NAME].DebuffsVertical and OrientationEnum.RightThenUp or OrientationEnum.UpThenRight
	local useTaintMethod = _G[ns.OPTIONS_NAME].UseTaintMethod
	ManageUnitFrames(frame, frame.debuffFrames, "Debuff", DEFAULT_MAXDEBUFFS, max, scale, slotsPerLine, orientation, OrientationEnum.RightThenUp, useTaintMethod, 0)
end

-- Will be used in standalone addon
local function getInfo(self)
    ns.AddMsg(l.MSG_LOADED);
end

local function isEnabled(options)
    return options.ActiveUnitDebuffs ~= false
		and (
			options.BuffsScale ~= 1
			or options.MaxBuffs   ~= DEFAULT_MAXBUFFS
			or options.BuffsPerLine < DEFAULT_MAXBUFFS
			or options.BuffsVertical
			or options.DebuffsScale ~= 1
			or options.MaxDebuffs   ~= DEFAULT_MAXDEBUFFS
			or options.DebuffsPerLine < DEFAULT_MAXDEBUFFS
			or options.DebuffsVertical
		)
end

-- Determine appropriate hook
-- If positions are modified, we have to hook reposition method instead
local function determineAppropriateHook(setMaxHookName, lineSize, maxIcons, defaultMaxIcons, verticalAlign)
	if verticalAlign or lineSize < maxIcons or lineSize < defaultMaxIcons then
		return "DefaultCompactUnitFrameSetup"
	end
	return setMaxHookName
end
local function onSaveOptions(self, options)
    if not ns._UnitDebuffsHooked and isEnabled(options) then
        ns._UnitDebuffsHooked = true
		local buffsHook = determineAppropriateHook("CompactUnitFrame_SetMaxBuffs", options.BuffsPerLine, options.MaxBuffs, DEFAULT_MAXBUFFS, options.BuffsVertical)
		local debuffsHook = determineAppropriateHook("CompactUnitFrame_SetMaxDebuffs", options.DebuffsPerLine, options.MaxDebuffs, DEFAULT_MAXDEBUFFS, options.DebuffsVertical)
        hooksecurefunc(buffsHook, ns.Hook_ManageBuffs)
        hooksecurefunc(debuffsHook, ns.Hook_ManageDebuffs)
		if not options.UseTaintMethod and (options.MaxBuffs ~= DEFAULT_MAXBUFFS or options.MaxDebuffs ~= DEFAULT_MAXDEBUFFS) then
			-- manage max buffs / debuffs changed, safer but experimental
			hooksecurefunc("CompactUnitFrame_UpdateAuras", ns.CompactUnitFrame_UpdateAurasInternal)
		end
    end
end

local function onInit(self, options)
    onSaveOptions(self, options);
end
local module = ns.Module:new(onInit, "UnitDebuffs");

module:SetOnSaveOptions(onSaveOptions);
module:SetGetInfo(getInfo);

--@do-not-package@
--[[
Hooks:
CompactUnitFrame_SetMaxBuffs si pas de repositionnement
DefaultCompactUnitFrameSetup si repositionnement (multiligne, etc...)
-- hooksecurefunc(options.DispelDebuffsPerLine < options.MaxDispelDebuffs and "CompactUnitFrame_UpdateAll" or "CompactUnitFrame_SetMaxDispelDebuffs", ns.Hook_ManageDispelDebuffs);

/dump KallyeRaidFramesOptions.MaxBuffs

/dump CompactPartyFrameMember1.maxBuffs
/dump CompactPartyFrameMember1.buffFrames
/dump CompactPartyFrameMember1Buff1

/dump CompactPartyFrameMember1Buff6

cata (before CompactBuffTemplate)
/dump CompactRaidFrame1Buff6

]]
--@end-do-not-package@