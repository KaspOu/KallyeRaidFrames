local _, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end

-- Fallback if not set in globals
if ns.HAS_colorNameBySelection == nil then
    -- colorNameBySelection, Since BfA (7)
    ns.HAS_colorNameBySelection = ns.IS_RETAIL or (WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1));
end

local function getClassColors()
	return CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;
end

local function FrameIsCompact(frame)
	local getName = frame:GetName();
	return getName ~=nil and strsub(getName, 0, 7) == "Compact"
end

local function applyTextColor(name, useColorOption, color, customColor)
    if useColorOption == "1" and color then
        name:SetVertexColor(color.r, color.g, color.b, color.a)
        name:SetShadowColor(color.r, color.g, color.b, 0.2)
    elseif useColorOption == "2" then
        name:SetVertexColor(customColor.r, customColor.g, customColor.b, customColor.a)
        name:SetShadowColor(customColor.r, customColor.g, customColor.b, 0.2)
    end
end

local function applyBarColor(healthBar, useColorOption, color, customColor)
    if useColorOption == "1" then
        healthBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
    elseif useColorOption == "2" then
        healthBar:SetStatusBarColor(customColor.r, customColor.g, customColor.b, customColor.a)
    end
end

local function filterNameplateBarOption(option)
    if (ns.HAS_colorNameBySelection) then
        return "0"
    end
    return option
end

function ns.UpdateNameplateColor(frame)
    if frame:IsForbidden() or not UnitPlayerControlled(frame.displayedUnit) or FrameIsCompact(frame) then
        return
    end

    local cacheOptions = ns.Module.cacheOptions
    local r, g, b, a = UnitSelectionColor(frame.displayedUnit)
    local c = not UnitIsPlayer(frame.displayedUnit) and {r= r, g= g, b=b, a=a} or getClassColors()[select(2,UnitClass(frame.displayedUnit))]

    if UnitIsFriend(frame.displayedUnit, "player") then
        applyTextColor(frame.name, cacheOptions.FriendsNameplates_Txt_UseColor, c, cacheOptions.FriendsNameplates_Txt_Color)
        local optionBarUseColor = filterNameplateBarOption(cacheOptions.FriendsNameplates_Bar_UseColor)
        applyBarColor(frame.healthBar, optionBarUseColor, c, cacheOptions.FriendsNameplates_Bar_Color)
    end

    if not UnitIsFriend(frame.displayedUnit, "player") then
        applyTextColor(frame.name, cacheOptions.EnemiesNameplates_Txt_UseColor, c, cacheOptions.EnemiesNameplates_Txt_Color)
        local optionBarUseColor = filterNameplateBarOption(cacheOptions.EnemiesNameplates_Bar_UseColor)
        applyBarColor(frame.healthBar, optionBarUseColor, c, cacheOptions.EnemiesNameplates_Bar_Color)
    end
end

-- Will be used in standalone addon
local function getInfo(self)
    ns.AddMsg(l.MSG_LOADED);
end

local function isEnabled(options)
    return (options.FriendsNameplates_Txt_UseColor or "0") ~= "0"
        or (options.FriendsNameplates_Bar_UseColor or "0") ~= "0"
        or (options.EnemiesNameplates_Txt_UseColor or "0") ~= "0"
        or (options.EnemiesNameplates_Bar_UseColor or "0") ~= "0"
end

local function onSaveOptions(self, options)
    if not ns._NameplatesHooked and isEnabled(options) then
        ns._NameplatesHooked = true
        hooksecurefunc("CompactUnitFrame_UpdateName", ns.UpdateNameplateColor);
    end
end

local function onInit(self, options)
    onSaveOptions(self, options);
end
local module = ns.Module:new(onInit, "NameplatesColor");
module:SetOnSaveOptions(onSaveOptions);
module:SetGetInfo(getInfo);

--@do-not-package@
-- hooksecurefunc(NamePlateDriverFrame,"OnNamePlateCreated", ??
-- Blizzard nameplates color test: local allowClassColor = frame.optionTable.allowClassColorsForNPCs or UnitIsPlayer(frame.unit) or (UnitTreatAsPlayerForDisplay and UnitTreatAsPlayerForDisplay(frame.unit));
--@end-do-not-package@