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


local function anchorPoints(type, frameIdx, lineSize)
	local newLine = (lineSize ~= nil) and (math.fmod(frameIdx-1, lineSize) == 0)
	if type == "Buff" then
		if not newLine then
			return false, "BOTTOMRIGHT", frameIdx-1, "BOTTOMLEFT"
		else
			return true, "BOTTOMRIGHT", frameIdx-lineSize, "TOPRIGHT"
		end
	else
		if not newLine then
			return false, "BOTTOMLEFT", frameIdx-1, "BOTTOMRIGHT"
		else
			return true, "BOTTOMLEFT", frameIdx-lineSize, "TOPLEFT"
		end
	end
end

--- Manage the display and scaling of buffs & debuffs on group frames.
--- @param frame frame The parent frame on which buffs or debuffs are displayed.
--- @param frameChilds table Table containing child frames (buffs/debuffs).
--- @param frameType string Type of frames to manage ('Buff', 'Debuff', 'DispelDebuff').
--- @param defaultMax number Blizzard max default.
--- @param maxCount Maximum number of buffs/debuffs to display.
--- @param scale number Scale factor for the buffs/debuffs.
--- @param lineSize number Number of slots per line
local function ManageUnitFrames(frame, frameChilds, frameType, defaultMax, maxCount, scale, lineSize)
	if InCombatLockdown() or frame:IsForbidden() or not FrameIsCompact(frame) then
		return
	end

    local frameName = frame:GetName() .. frameType
	local maxProp = "max"..frameType.."s"

	-- addSlots and setPoints
	if maxCount ~= frame[maxProp] then
		local loopStart = math.min(defaultMax + 1, lineSize + 1)
		for fId = loopStart, maxCount do
			local child = _G[frameName .. fId]
			if not _G[frameName .. fId] then
				child = CreateFrame("Button", frameName .. fId, frame, "Compact" .. frameType .. "Template")
				child:SetScale(scale)
			end
			local newLine, point, relativeId, relativePoint = anchorPoints(frameType, fId, lineSize)
			if newLine then
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
	ManageUnitFrames(frame, frame.buffFrames, "Buff", DEFAULT_MAXBUFFS, max, scale, slotsPerLine)
end

function ns.Hook_ManageDebuffs(frame)
    local max = _G[ns.OPTIONS_NAME].MaxDebuffs
    local scale = _G[ns.OPTIONS_NAME].DebuffsScale
	local slotsPerLine = _G[ns.OPTIONS_NAME].DebuffsPerLine
	ManageUnitFrames(frame, frame.debuffFrames, "Debuff", DEFAULT_MAXDEBUFFS, max, scale, slotsPerLine)
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
			or options.DebuffsScale ~= 1
			or options.MaxDebuffs   ~= DEFAULT_MAXDEBUFFS
			or options.DebuffsPerLine < DEFAULT_MAXDEBUFFS
		)
end

local function onSaveOptions(self, options)
    if not ns._UnitDebuffsHooked and isEnabled(options) then
        ns._UnitDebuffsHooked = true
        hooksecurefunc(options.BuffsPerLine < options.MaxBuffs     and "CompactUnitFrame_UpdateAll" or "CompactUnitFrame_SetMaxBuffs", ns.Hook_ManageBuffs);
        hooksecurefunc(options.DebuffsPerLine < options.MaxDebuffs and "CompactUnitFrame_UpdateAll" or "CompactUnitFrame_SetMaxDebuffs", ns.Hook_ManageDebuffs);
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