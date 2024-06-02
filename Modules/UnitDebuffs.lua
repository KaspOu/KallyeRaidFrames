local _, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end


local DEFAULT_MAXBUFFS = ns.DEFAULT_MAXBUFFS or 3
local DEFAULT_MAXDEBUFFS = DEFAULT_MAXBUFFS
--[[
! Manage buffs
- Scale buffs / debuffs
]]

local function FrameIsCompact(frame)
	local getName = frame:GetName();
	return getName ~=nil and strsub(getName, 0, 7) == "Compact"
end


local OrientationEnum = {
    LeftThenUp = "LeftThenUp",
    UpThenLeft = "UpThenLeft",
    RightThenUp = "RightThenUp",
    UpThenRight = "UpThenRight"
}

local function anchorPoints(frameIdx, lineSize, orientation)
	local newLine = (lineSize ~= nil) and (math.fmod(frameIdx-1, lineSize) == 0)
	local relatedIdx = newLine and (frameIdx-lineSize) or (frameIdx-1)

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
		(not newLine) and selectedAlignment[2] or selectedAlignment[3];
	return newLine, point, relatedIdx, relatedPoint
end

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
local function ManageUnitFrames(frame, frameChilds, frameType, defaultMax, maxCount, scale, lineSize, orientation, blizzardOrientation)
	if InCombatLockdown() or frame:IsForbidden() or not FrameIsCompact(frame) then
		return
	end
    local frameName = frame:GetName() .. frameType
	local maxProp = "max"..frameType.."s"
	-- Edit mode: try safe value before exit (do not work well :/)
	if EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive() then
		frame[maxProp] = 0
		return;
	end

	-- addSlots and setPoints
	if maxCount ~= frame[maxProp] then
		-- start loop at first icon not matching blizz positioning
		local loopStart = math.min(defaultMax + 1, lineSize + 1)
		if orientation ~= blizzardOrientation then
			loopStart = 2
		end
		for fId = loopStart, maxCount do
			local child = _G[frameName .. fId]
			if not _G[frameName .. fId] then
				child = CreateFrame("Button", frameName .. fId, frame, "Compact" .. frameType .. "Template")
				child:SetScale(scale)
			end
			local newLine, point, relativeId, relativePoint = anchorPoints(fId, lineSize, orientation)
			if newLine or orientation ~= blizzardOrientation then
				child:ClearAllPoints()
			end
			child:SetPoint(point, _G[frameName .. relativeId], relativePoint)
		end
		frame[maxProp] = maxCount
	end

	-- rescaling
    if scale ~= 1 and frame._lastScale ~= scale then
		for _, child in ipairs(frameChilds) do
			child:SetScale(scale);
		end
		frame._lastScale = scale
    end
end

function ns.Hook_ManageBuffs(frame)
    local max = _G[ns.OPTIONS_NAME].MaxBuffs
    local scale = _G[ns.OPTIONS_NAME].BuffsScale
	local slotsPerLine = _G[ns.OPTIONS_NAME].BuffsPerLine
	local orientation = not _G[ns.OPTIONS_NAME].BuffsVertical and OrientationEnum.LeftThenUp or OrientationEnum.UpThenLeft
	ManageUnitFrames(frame, frame.buffFrames, "Buff", DEFAULT_MAXBUFFS, max, scale, slotsPerLine, orientation, OrientationEnum.LeftThenUp)
end

function ns.Hook_ManageDebuffs(frame)
    local max = _G[ns.OPTIONS_NAME].MaxDebuffs
    local scale = _G[ns.OPTIONS_NAME].DebuffsScale
	local slotsPerLine = _G[ns.OPTIONS_NAME].DebuffsPerLine
	local orientation = not _G[ns.OPTIONS_NAME].DebuffsVertical and OrientationEnum.RightThenUp or OrientationEnum.UpThenRight
	ManageUnitFrames(frame, frame.debuffFrames, "Debuff", DEFAULT_MAXDEBUFFS, max, scale, slotsPerLine, orientation, OrientationEnum.RightThenUp)
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

local function determineAppropriateHook(hookName, lineSize, maxIcons, verticalAlign)
	if verticalAlign or lineSize < maxIcons then
		return "CompactUnitFrame_UpdateAll"
	end
	return hookName;
end
local function onSaveOptions(self, options)
    if not ns._UnitDebuffsHooked and isEnabled(options) then
        ns._UnitDebuffsHooked = true
		local buffsHook = determineAppropriateHook("CompactUnitFrame_SetMaxBuffs", options.BuffsPerLine, options.MaxBuffs, options.BuffsVertical)
		local debuffsHook = determineAppropriateHook("CompactUnitFrame_SetMaxDebuffs", options.DebuffsPerLine, options.MaxDebuffs, options.DebuffsVertical)
        hooksecurefunc(buffsHook, ns.Hook_ManageBuffs);
        hooksecurefunc(debuffsHook, ns.Hook_ManageDebuffs);
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
CompactUnitFrame_UpdateAll si repositionnement (multiligne, etc...)
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