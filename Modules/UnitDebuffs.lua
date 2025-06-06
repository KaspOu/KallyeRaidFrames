local _, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end

ns.USE_MAXBUFFS_TAINT_METHOD = (CompactUnitFrame_GetOptionDisplayOnlyDispellableDebuffs == nil) -- maxBuffs only

local DEFAULT_MAXBUFFS = ns.DEFAULT_MAXBUFFS or 3
local DEFAULT_MAXDEBUFFS = DEFAULT_MAXBUFFS

--[[
! Manage buffs
- Scale buffs / debuffs
]]
		-- ! Blizzard original method modified, from CompactUnitFrame
		-- * alternative safe method (else maxBuffs taints frame)
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
			local cacheOptions = ns.Module.cacheOptions
			local maxBuffs = cacheOptions.MaxBuffs
    		local maxDebuffs = cacheOptions.MaxDebuffs
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

-- Store frames waiting for combat end
local pendingFrames = {}

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

--- Manage the display and scaling of buffs & debuffs on group frames.
--- @param param table Object containing all parameters
--- @meta param.frame frame Frame on which buffs and debuffs are displayed
--- @meta param.frameType string Frame type (e.g., "Buffs" or "Debuffs")
--- @meta param.maxCount number Maximum number of icons to display
--- @meta param.lineSize number Number of icons per line
--- @meta param.orientation string Icon orientation (e.g., "LeftThenUp")
--- @meta param.posX number Position X relative to the first icon
--- @meta param.posY number Position Y relative to the first icon
--- @meta param.blizzardOrientation string Blizzard's default orientation for buffs or debuffs
--- @meta param.defaultMax number Default maximum number of icons to display
local function ManageUnitFrames(param)
	if not FrameIsCompact(param.frame) or FrameIsPet(param.frame) or param.frame:IsForbidden() then
		return
	end
    local frameName = param.frame:GetName() .. param.frameType
	if InCombatLockdown() then
		pendingFrames[frameName] = param
		return
	end

	local BLIZZARD_MAX_PROP = "max"..param.frameType.."s" -- frame.maxBuffs / .maxDebuffs / .maxDispelDebuff
	local defaultMaxProp = "defaultMax"..param.frameType.."s" -- save BLizzard MAX first time
	param.frame[defaultMaxProp] = param.frame[defaultMaxProp] or param.frame[BLIZZARD_MAX_PROP]

	-- Reposition first icon if necessary
	if param.posX ~= 0 or param.posY ~= 0 then
		local firstChild = param.frameChilds[1]
		local attr = firstChild:GetAttribute("_firstPoint")
		if attr == nil then
			local point, relativeTo, relativePoint, xOfs, yOfs = firstChild:GetPoint()
			firstChild:SetAttribute("_firstPoint", {
				point = point,
				relativeTo = relativeTo,
				relativePoint = relativePoint,
				xOfs = xOfs,
				yOfs = yOfs
			})
			attr = firstChild:GetAttribute("_firstPoint")
		end
		firstChild:ClearAllPoints()
		firstChild:SetPoint(
			attr.point,
			attr.relativeTo,
			attr.relativePoint,
			attr.xOfs + param.posX,
			attr.yOfs + param.posY
		)
	end

	if param.maxCount > param.frame[defaultMaxProp] or param.lineSize < param.maxCount or param.orientation ~= param.blizzardOrientation then
		-- add missing icons and re-SetPoints
		-- start loop at first icon not matching blizz positioning
		local loopStart = math.min(param.defaultMax + 1, param.lineSize + 1)
		if param.orientation ~= param.blizzardOrientation or param.posX ~= 0 or param.posY ~= 0 then
			loopStart = 2
		end
		for childIdx = loopStart, param.maxCount do
			local isNewChild = false
			local child = _G[frameName .. childIdx]
			if not _G[frameName .. childIdx] then
				child = CreateFrame("Button", frameName .. childIdx, param.frame, "Compact" .. param.frameType .. "Template")
				child:SetScale(param.scale)
				if param.frameChilds[childIdx] == nil then
					param.frameChilds[childIdx] = child
				end
				isNewChild = true
			end
			local isNewLine, point, relativeIdx, relativePoint = anchorPoints(childIdx, param.lineSize, param.orientation)
			if isNewChild or isNewLine or param.orientation ~= param.blizzardOrientation then
				child:ClearAllPoints();
				child:SetPoint(point, _G[frameName .. relativeIdx], relativePoint)
			end
		end
	end

	if param.useTaintMethod and param.maxCount ~= param.frame[BLIZZARD_MAX_PROP] then
		param.frame[BLIZZARD_MAX_PROP] = param.maxCount -- ! Taints frame
	end

	-- rescaling
    local lastScale = param.frame:GetAttribute("_lastScale") or 1
    if lastScale ~= param.scale then
		for _, child in ipairs(param.frameChilds) do
			child:SetScale(param.scale);
		end
		param.frame:SetAttribute("_lastScale", param.scale)
    end
end

-- Event handler for combat end
function ns.OnCombatEnd()
	for frameName, param in pairs(pendingFrames) do
		ManageUnitFrames(param)
		pendingFrames[frameName] = nil
	end
end

function ns.Hook_ManageBuffs(frame)
    local cacheOptions = ns.Module.cacheOptions
    local max = cacheOptions.MaxBuffs
    local scale = cacheOptions.BuffsScale
	local slotsPerLine = cacheOptions.BuffsPerLine
	local useTaintMethod = ns.USE_MAXBUFFS_TAINT_METHOD or cacheOptions.UseTaintMethod
	local orientation = cacheOptions.BuffsOrientation or OrientationEnum.LeftThenUp
	local posX = cacheOptions.BuffsPosX or 0
	local posY = cacheOptions.BuffsPosY or 0

	ManageUnitFrames({
		frame = frame,
		frameChilds = frame.buffFrames,
		frameType = "Buff",
		defaultMax = DEFAULT_MAXBUFFS,
		maxCount = max,
		scale = scale,
		lineSize = slotsPerLine,
		useTaintMethod = useTaintMethod,
		blizzardOrientation = OrientationEnum.LeftThenUp,
		orientation = orientation,
		posX = posX,
		posY = posY,
		retries = 0
	})
end

function ns.Hook_ManageDebuffs(frame)
    local cacheOptions = ns.Module.cacheOptions
    local max = cacheOptions.MaxDebuffs
    local scale = cacheOptions.DebuffsScale
	local slotsPerLine = cacheOptions.DebuffsPerLine
	local useTaintMethod = ns.USE_MAXBUFFS_TAINT_METHOD or cacheOptions.UseTaintMethod
	local orientation = cacheOptions.DebuffsOrientation or OrientationEnum.RightThenUp
	local posX = cacheOptions.DebuffsPosX or 0
	local posY = cacheOptions.DebuffsPosY or 0

	ManageUnitFrames({
		frame = frame,
		frameChilds = frame.debuffFrames,
		frameType = "Debuff",
		defaultMax = DEFAULT_MAXDEBUFFS,
		maxCount = max,
		scale = scale,
		lineSize = slotsPerLine,
		useTaintMethod = useTaintMethod,
		blizzardOrientation = OrientationEnum.RightThenUp,
		orientation = orientation,
		posX = posX,
		posY = posY,
		retries = 0
	})
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
			or options.BuffsOrientation
			or options.BuffsPosX
			or options.BuffsPosY
			or options.DebuffsScale ~= 1
			or options.MaxDebuffs   ~= DEFAULT_MAXDEBUFFS
			or options.DebuffsPerLine < DEFAULT_MAXDEBUFFS
			or options.DebuffsOrientation
			or options.DebuffsPosX
			or options.DebuffsPosY
		)
end

-- Determine appropriate hook
-- If positions are modified, we have to hook reposition method instead
local function determineAppropriateHook(setMaxHookName, lineSize, maxIcons, defaultMaxIcons, notDefaultAlign, posX, posY)
	if notDefaultAlign or lineSize < maxIcons or lineSize < defaultMaxIcons or posX ~= 0 or posY ~= 0 then
		return "DefaultCompactUnitFrameSetup"
	end
	return setMaxHookName
end

function ns.isFlickerWarningShowed(options)
	local buffsHook = determineAppropriateHook("", options.BuffsPerLine, options.MaxBuffs, DEFAULT_MAXBUFFS, options.BuffsOrientation ~= "LeftThenUp", options.BuffsPosX, options.BuffsPosY)
	local debuffsHook = determineAppropriateHook("", options.DebuffsPerLine, options.MaxDebuffs, DEFAULT_MAXDEBUFFS, options.DebuffsOrientation ~= "RightThenUp", options.DebuffsPosX, options.DebuffsPosY)
	return buffsHook..debuffsHook ~= ""
end
local function onSaveOptions(self, options)
    if not ns._UnitDebuffsHooked and isEnabled(options) then
        ns._UnitDebuffsHooked = true
		local buffsHook = determineAppropriateHook("CompactUnitFrame_SetMaxBuffs", options.BuffsPerLine, options.MaxBuffs, DEFAULT_MAXBUFFS, options.BuffsOrientation ~= "LeftThenUp", options.BuffsPosX, options.BuffsPosY)
		local debuffsHook = determineAppropriateHook("CompactUnitFrame_SetMaxDebuffs", options.DebuffsPerLine, options.MaxDebuffs, DEFAULT_MAXDEBUFFS, options.DebuffsOrientation ~= "RightThenUp", options.DebuffsPosX, options.DebuffsPosY)
		local useTaintMethod = ns.USE_MAXBUFFS_TAINT_METHOD or options.UseTaintMethod
        hooksecurefunc(buffsHook, ns.Hook_ManageBuffs)
        hooksecurefunc(debuffsHook, ns.Hook_ManageDebuffs)
		if not useTaintMethod and (options.MaxBuffs ~= DEFAULT_MAXBUFFS or options.MaxDebuffs ~= DEFAULT_MAXDEBUFFS) then
			-- manage max buffs / debuffs changed, safer but experimental
			hooksecurefunc("CompactUnitFrame_UpdateAuras", ns.CompactUnitFrame_UpdateAurasInternal)
		end

		-- Register combat end event, callback out of combat
		local frame = CreateFrame("Frame")
		frame:RegisterEvent("PLAYER_REGEN_ENABLED")
		frame:SetScript("OnEvent", function(self, event)
			if event == "PLAYER_REGEN_ENABLED" then
				ns.OnCombatEnd()
			end
		end)
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
/dump issecurevariable(CompactPartyFrameMember1, "maxBuffs")
/dump CompactPartyFrameMember1.buffFrames
/dump CompactPartyFrameMember1Buff1

/dump CompactPartyFrameMember1Buff6

cata (before CompactBuffTemplate)
/dump CompactRaidFrame1Buff6

]]
--@end-do-not-package@