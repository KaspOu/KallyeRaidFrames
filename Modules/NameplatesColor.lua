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
local function BCC(color)
    return string.format("ff%02x%02x%02x", (color.r*255), (color.g*255), (color.b*255));
end

ns.pvpIcons = {
    gemred = "|TInterface/PVPFrame/Icons/prestige-icon-8-1:16|t",
    gemblue = "|TInterface/PVPFrame/Icons/prestige-icon-8-2:16|t",
    gemgreen = "|TInterface/PVPFrame/Icons/prestige-icon-8-3:16|t",
    wolf = "|TInterface/PVPFrame/Icons/prestige-icon-3-3-small:20|t",
    lion = "|TInterface/PVPFrame/Icons/prestige-icon-3-4-small:20|t",
    sword = "|TInterface/PVPFrame/Icons/prestige-icon-1:20|t",
    shield = "|TInterface/PVPFrame/Icons/prestige-icon-2:20|t",
    swords = "|TInterface/PVPFrame/Icons/prestige-icon-3:20|t",
    Alliance = "|TInterface/PVPFrame/PVP-Currency-Alliance:16|t",
    Horde = "|TInterface/PVPFrame/PVP-Currency-Horde:16|t",
}
local function applyIconAndText(unit, name, pvpIconOption, showLevelOption, underLevelColor, overLevelColor)
    local playerName = GetUnitName(unit);
    local newName = playerName;
    if showLevelOption ~= "0" then
        local unitLevel = UnitLevel(unit);
        local levelShowed = "";
        if (showLevelOption == "22" or ns._PlayerLevel ~= unitLevel) then
            levelShowed = unitLevel.." ";
        end
        if (levelShowed ~= "") then
            if (showLevelOption == "12" or showLevelOption == "22") then
                if (unitLevel < ns._PlayerLevel) then
                    levelShowed = WrapTextInColorCode(levelShowed, BCC(underLevelColor));
                elseif (unitLevel > ns._PlayerLevel) then
                    levelShowed = WrapTextInColorCode(levelShowed, BCC(overLevelColor));
                end
            end
            newName = levelShowed..newName;
        end
    end
    if UnitIsPVP(unit) and pvpIconOption ~= "0" then
        local icon = ns.pvpIcons[pvpIconOption] or ""
        if pvpIconOption == "faction" then
            local faction = UnitFactionGroup(unit)
            icon = ns.pvpIcons[faction] or ""
        end
        if icon ~= "" then
            newName = icon..newName;
        end
    end
    if newName ~= playerName then
        name:SetText(newName)
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
    if (ns.HAS_colorNameBySelection and option == "1") then
        return "0"
    end
    return option
end


--- Updates the nameplate colors based on user settings.
--- Hook CompactUnitFrame_UpdateName
--- @param frame any The nameplate frame to update.
local function Hook_CUF_UpdateName(frame)
    if frame:IsForbidden() or not UnitPlayerControlled(frame.displayedUnit) or FrameIsCompact(frame) or _G[ns.OPTIONS_NAME].ActiveNameplatesColor == false then
        return
    end

    local cacheOptions = ns.Module.cacheOptions
    local r, g, b, a = UnitSelectionColor(frame.displayedUnit)
    local c = not UnitIsPlayer(frame.displayedUnit) and {r= r, g= g, b=b, a=a} or getClassColors()[select(2,UnitClass(frame.displayedUnit))]

    if UnitIsFriend(frame.displayedUnit, "player") then
        applyTextColor(frame.name, cacheOptions.FriendsNameplates_Txt_UseColor, c, cacheOptions.FriendsNameplates_Txt_Color)
        applyIconAndText(frame.displayedUnit, frame.name,
            cacheOptions.FriendsNameplates_PvpIcon,
            cacheOptions.FriendsNameplates_Txt_ShowLevel,
            cacheOptions.FriendsNameplates_Txt_Level_Color_Under,
            cacheOptions.FriendsNameplates_Txt_Level_Color_Over)
        local optionBarUseColor = filterNameplateBarOption(cacheOptions.FriendsNameplates_Bar_UseColor)
        applyBarColor(frame.healthBar, optionBarUseColor, c, cacheOptions.FriendsNameplates_Bar_Color)
    end

    if not UnitIsFriend(frame.displayedUnit, "player") then
        applyTextColor(frame.name, cacheOptions.EnemiesNameplates_Txt_UseColor, c, cacheOptions.EnemiesNameplates_Txt_Color)
        applyIconAndText(frame.displayedUnit, frame.name,
            cacheOptions.EnemiesNameplates_PvpIcon,
            cacheOptions.EnemiesNameplates_Txt_ShowLevel,
            cacheOptions.EnemiesNameplates_Txt_Level_Color_Under,
            cacheOptions.EnemiesNameplates_Txt_Level_Color_Over)
        local optionBarUseColor = filterNameplateBarOption(cacheOptions.EnemiesNameplates_Bar_UseColor)
        applyBarColor(frame.healthBar, optionBarUseColor, c, cacheOptions.EnemiesNameplates_Bar_Color)
    end
end

local function OnEvent(self, event, ...)
	local arg1 = select(1, ...);
	if (event == "PLAYER_LEVEL_UP") then
        ns._PlayerLevel = arg1;
	end
end

-- Will be used in standalone addon
local function getInfo(self)
    ns.AddMsg(l.MSG_LOADED);
end

local function isEnabled(options)
    return options.ActiveNameplatesColor ~= false
		and (
            (options.FriendsNameplates_Txt_UseColor or "0") ~= "0"
            or (options.FriendsNameplates_Bar_UseColor or "0") ~= "0"
            or (options.FriendsNameplates_PvpIcon or "0") ~= "0"
            or (options.FriendsNameplates_Txt_ShowLevel or "0") ~= "0"

            or (options.EnemiesNameplates_Txt_UseColor or "0") ~= "0"
            or (options.EnemiesNameplates_Bar_UseColor or "0") ~= "0"
            or (options.EnemiesNameplates_PvpIcon or "0") ~= "0"
            or (options.EnemiesNameplates_Txt_ShowLevel or "0") ~= "0"
        )
end

local function onSaveOptions(self, options)
    if not ns._NameplatesHooked and isEnabled(options) then
        ns._NameplatesHooked = true;
        hooksecurefunc("CompactUnitFrame_UpdateName", Hook_CUF_UpdateName);

        ns._PlayerLevel = UnitLevel("player");
        local f = CreateFrame("Frame", nil, UIParent);
        f:RegisterEvent("PLAYER_LEVEL_UP");
        f:SetScript("OnEvent", OnEvent);
    end
end

local function onInit(self, options)
    onSaveOptions(self, options);
end
local module = ns.Module:new(onInit, "NameplatesColor");
module:SetOnSaveOptions(onSaveOptions);
module:SetGetInfo(getInfo);

--@do-not-package@
--[[
hooksecurefunc(NamePlateDriverFrame,"OnNamePlateCreated", ??
Blizzard nameplates color test: local allowClassColor = frame.optionTable.allowClassColorsForNPCs or UnitIsPlayer(frame.unit) or (UnitTreatAsPlayerForDisplay and UnitTreatAsPlayerForDisplay(frame.unit));
Textures: 
https://github.com/Gethe/wow-ui-textures/tree/live/PVPFrame
--]]
--@end-do-not-package@