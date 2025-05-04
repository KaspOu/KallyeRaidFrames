local _, ns = ...
local l = ns.I18N;

function ns.InterfaceOptions_AddCategory(frame, addOn, position)
	if not Settings or not Settings.RegisterCanvasLayoutSubcategory then
		return InterfaceOptions_AddCategory(frame, addOn, position)
	end
    -- cancel is no longer a default option. May add menu extension for this.
    frame.OnCommit = frame.okay;
    frame.OnDefault = frame.default;
    frame.OnRefresh = frame.refresh;

    if frame.parent then -- for subcategories
        local category = Settings.GetCategory(frame.parent);
        local subcategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, frame.name, frame.name);
        subcategory.ID = frame.name;
        return subcategory, category;
    else
        local category, layout = Settings.RegisterCanvasLayoutCategory(frame, frame.name, frame.name);
        category.ID = frame.name;
        Settings.RegisterAddOnCategory(category);
        return category;
    end
end

function ns.RemoveOldOptions(options)
	-- TODO: REMOVE Since 10.206 OLD KEYS
	if  options.FriendsClassColor_Nameplates then
		options.FriendsNameplates_Txt_UseColor = "1"
		options.FriendsNameplates_Bar_UseColor = ns.HAS_colorNameBySelection and "0" or "1"
		options.FriendsClassColor_Nameplates = nil
	end
	if  options.EnemiesClassColor_Nameplates then
		options.EnemiesNameplates_Txt_UseColor = "1"
		options.EnemiesNameplates_Bar_UseColor = ns.HAS_colorNameBySelection and "0" or "1"
		options.EnemiesClassColor_Nameplates = nil
	end
end

local startsWith = {
	play = true, -- player
	part = true, -- party
	raid = true,
}
local function UnitInPartyOrRaid(frame)
	return startsWith[strsub(frame.displayedUnit, 1, 4)];
	-- return UnitInParty(Unit) or UnitInRaid(Unit) or UnitIsUnit(Unit, "player")
end

local function KRF_UnitIsConnected(frame)
	if ns.IsDebugFramesTimerActive then
		return not frame._testUnitDisconnected;
	end
	return UnitIsConnected(frame.unit);
end

local function KRF_UnitIsDeadOrGhost(frame)
	if ns.IsDebugFramesTimerActive then
		return (frame._testHealthPercentage == 0 and not frame._testUnitDisconnected);
	end
	return UnitIsDeadOrGhost(frame.unit);
end

local function FrameIsCompact(frame)
	local getName = frame:GetName();
	return getName ~=nil and strsub(getName, 0, 7) == "Compact"
end

local function mergeRGBA(r1, g1, b1, a1, r2, g2, b2, a2, percent)
	return r1*(1-percent) + r2*percent, g1*(1-percent) + g2*percent, b1*(1-percent) + b2*percent, a1*(1-percent) + a2*percent
end
local function mergeColors(color1, color2, percent)
	return mergeRGBA(color1.r, color1.g, color1.b, color1.a, color2.r, color2.g, color2.b, color2.a, percent)
end
local function darken(r, g, b, percent, alpha)
	-- return r*(1-percent), g*(1-percent), b*(1-percent), alpha or 1
	return mergeRGBA(r, g, b, alpha or 1, 0, 0, 0, alpha or 1, percent)
end
local function lighten(r, g, b, percent, alpha)
	-- return r*(1-percent) + percent, g*(1-percent) + percent, b*(1-percent) + percent, alpha or 1
	return mergeRGBA(r, g, b, alpha or 1, 1, 1, 1, alpha or 1, percent)
end

local function KRF_GetClassColors()
	return CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;
end

--[[
! Managing Alpha depending on range
- Alpha not in range
- then alpha out of combat
- Disabled if alpha values are equals to blizzard default (100% / 55%)
]]
function ns.Hook_UpdateInRange(frame)
	if UnitInPartyOrRaid(frame) and FrameIsCompact(frame) and not frame:IsForbidden() then
		local isInRange, hasCheckedRange = UnitInRange(frame.displayedUnit);
		local newAlpha = 1;
		if _G[ns.OPTIONS_NAME].AlphaNotInRange < 100 and hasCheckedRange and not isInRange then
			newAlpha = _G[ns.OPTIONS_NAME].AlphaNotInRange/100;
		elseif not InCombatLockdown() and _G[ns.OPTIONS_NAME].AlphaNotInCombat < 100 then
			newAlpha = _G[ns.OPTIONS_NAME].AlphaNotInCombat/100;
		end
		if (floor(frame:GetAlpha()*100) ~= floor(newAlpha*100)) then
			frame:SetAlpha(newAlpha);
			frame.background:SetAlpha(newAlpha);
		end
	end
end


local function GetHPSeverity(percent, revert)
	local BGColorOK=revert and _G[ns.OPTIONS_NAME].RevertColorOK or _G[ns.OPTIONS_NAME].BGColorOK;
	local BGColorWarn=revert and _G[ns.OPTIONS_NAME].RevertColorWarn or _G[ns.OPTIONS_NAME].BGColorWarn;
	local BGColorLow=revert and _G[ns.OPTIONS_NAME].RevertColorLow or _G[ns.OPTIONS_NAME].BGColorLow;
	local pLimitLow = _G[ns.OPTIONS_NAME].LimitLow / 100;
	local pLimitWarn = _G[ns.OPTIONS_NAME].LimitWarn / 100;
	local pLimitOk = _G[ns.OPTIONS_NAME].LimitOk / 100;

	if percent > pLimitOk then
		return BGColorOK.r, BGColorOK.g, BGColorOK.b, BGColorOK.a or 1;
	elseif percent > pLimitWarn then
		return mergeColors(BGColorWarn, BGColorOK, (percent - pLimitWarn)/ (pLimitOk - pLimitWarn));
	elseif percent > pLimitLow then
		return mergeColors(BGColorLow, BGColorWarn, (percent - pLimitLow) / (pLimitWarn - pLimitLow));
	else
		return BGColorLow.r, BGColorLow.g, BGColorLow.b, BGColorLow.a or 1;
	end
end

--[[
! Managing Health color: background
]]
local function UpdateHealth_Regular(frame, health)
	if not frame:IsForbidden() and frame.background and UnitInPartyOrRaid(frame) and FrameIsCompact(frame) then
		local c = KRF_GetClassColors()[select(2,UnitClass(frame.unit))];
		if c and frame.optionTable.useClassColors then
			frame.healthBar:SetStatusBarColor(darken(c.r, c.g, c.b, .2, .95))
		end
		if not KRF_UnitIsConnected(frame) then
			-- Disconnected
			frame.healthBar:SetValue(0);
			frame.background:SetColorTexture(darken(_G[ns.OPTIONS_NAME].BGColorLow.r, _G[ns.OPTIONS_NAME].BGColorLow.g, _G[ns.OPTIONS_NAME].BGColorLow.b, .6, .4));
			ns.Hook_UpdateName(frame, true);
			ns.UpdateNameRaidColor(frame);
		elseif KRF_UnitIsDeadOrGhost(frame) then
			-- Dead
			frame.healthBar:SetValue(0);
			frame._wasDead = true;
			if (_G[ns.OPTIONS_NAME].IconOnDeath) then
				ns.Hook_UpdateName(frame, true);
			end
			ns.UpdateNameRaidColor(frame);
			frame.background:SetColorTexture(darken(c.r, c.g, c.b, .7, .8));
		else
			-- Alive
			health = health or UnitHealth(frame.displayedUnit);
			local unitHealthMax = UnitHealthMax(frame.displayedUnit);
			local healthPercentage = ceil((health / unitHealthMax * 100));
			frame.background:SetColorTexture(GetHPSeverity(healthPercentage/100, false));
			if frame._wasDead then
				if (_G[ns.OPTIONS_NAME].IconOnDeath) then
					ns.Hook_UpdateName(frame, true);
				end
				ns.UpdateNameRaidColor(frame);
				frame._wasDead = false;
			end
		end
	end
end

--[[
! Managing Health color: reverted bar
]]
local function UpdateHealth_Reverted(frame, health)
	if not frame:IsForbidden() and UnitInPartyOrRaid(frame) and FrameIsCompact(frame) then
		local c = KRF_GetClassColors()[select(2,UnitClass(frame.unit))];

		if c and frame and frame.background and frame.optionTable.useClassColors then
			frame.background:SetColorTexture(darken(c.r, c.g, c.b, .7, .8));
			frame.name:SetShadowColor(c.r, c.g, c.b, .3);
		end

		if not KRF_UnitIsConnected(frame) then
			-- Disconnected
			frame.healthBar:SetValue(0);
			frame.background:SetColorTexture(darken(_G[ns.OPTIONS_NAME].RevertColorLow.r, _G[ns.OPTIONS_NAME].RevertColorLow.g, _G[ns.OPTIONS_NAME].RevertColorLow.b, .6, .4));
			ns.Hook_UpdateName(frame, true);
			ns.UpdateNameRaidColor(frame);
		elseif KRF_UnitIsDeadOrGhost(frame) then
			-- Dead
			frame.healthBar:SetValue(0);
			frame._wasDead = true;
			if (_G[ns.OPTIONS_NAME].IconOnDeath) then
				ns.Hook_UpdateName(frame, true);
			end
			ns.UpdateNameRaidColor(frame);
		else
			-- Alive
			health = health or UnitHealth(frame.displayedUnit);
			local unitHealthMax = UnitHealthMax(frame.displayedUnit);
			local healthPercentage = ceil((health / unitHealthMax * 100));
			local healthLost = unitHealthMax - health;
			frame.healthBar:SetStatusBarColor(GetHPSeverity(healthPercentage/100, true));
			if frame._wasDead then
				if (_G[ns.OPTIONS_NAME].IconOnDeath) then
					ns.Hook_UpdateName(frame, true);
				end
				ns.UpdateNameRaidColor(frame);
				frame._wasDead = false;
			end

			-- Set reverted value
			if (frame.optionTable.smoothHealthUpdates ) then
				frame.healthBar:SetSmoothedValue(healthLost);
			else
				frame.healthBar:SetValue(healthLost);
			end
			if ( frame.optionTable.displayHealPrediction and healthLost > 0) then
				local hbS = frame.healthBar:GetStatusBarTexture();
				frame.myHealPrediction:ClearAllPoints();
				frame.myHealPrediction:SetPoint("TOPRIGHT", hbS, "TOPRIGHT");
				frame.myHealPrediction:SetPoint("BOTTOMRIGHT", hbS, "BOTTOMRIGHT");
				frame.otherHealPrediction:ClearAllPoints();
				frame.otherHealPrediction:SetPoint("TOPRIGHT", frame.myHealPrediction, "TOPLEFT");
				frame.otherHealPrediction:SetPoint("BOTTOMRIGHT", frame.myHealPrediction, "BOTTOMLEFT");				
				frame.totalAbsorb:ClearAllPoints();
				-- frame.totalAbsorb:SetPoint("TOPRIGHT", hbS, "TOPRIGHT");
				-- frame.totalAbsorb:SetPoint("BOTTOMRIGHT", hbS, "BOTTOMRIGHT");
				frame.totalAbsorb:SetPoint("TOPRIGHT", frame.otherHealPrediction, "TOPLEFT");
				frame.totalAbsorb:SetPoint("BOTTOMRIGHT", frame.otherHealPrediction, "BOTTOMLEFT");	
			else
				frame.myHealPrediction:Hide();
				frame.otherHealPrediction:Hide();
				frame.totalAbsorb:Hide();
			end
		end
	end
end

--[[
! Managing Health & Alpha
- Normal or revert, depending on option
]]
function ns.Hook_UpdateHealth(frame, health)
	if _G[ns.OPTIONS_NAME].UpdateHealthColor and not frame:IsForbidden() then
		if not _G[ns.OPTIONS_NAME].RevertBar then
			UpdateHealth_Regular(frame, health)
		else
			UpdateHealth_Reverted(frame, health)
		end
	end
end

--[[
! UpdateRoleIcon
- Role icon on top left
- Role icon visible only for tanks / heals
- Reposition name accordingly
]]
function ns.Hook_UpdateRoleIcon(frame)
	if not frame:IsForbidden() and (_G[ns.OPTIONS_NAME].HideDamageIcons or _G[ns.OPTIONS_NAME].MoveRoleIcons) then
		local icon = frame.roleIcon;
		if not icon then
			return;
		end

		local offset = icon:GetWidth() / 4;

		if _G[ns.OPTIONS_NAME].MoveRoleIcons then
			icon:ClearAllPoints();
			icon:SetPoint("TOPLEFT", -offset, offset);
			frame.name:SetPoint("TOPLEFT", 5, -5);
		end

		local role = UnitGroupRolesAssigned(frame.unit);
		if _G[ns.OPTIONS_NAME].HideDamageIcons and role == "DAMAGER" then
			icon:Hide();
		end
	end
end


--[[
! Manage player names (partyframes & nameplates)
- Hide realm
- Add death icon (option)
- Call to ns.UpdateNameRaidColor (only inside hook)
]]
function ns.Hook_UpdateName(frame, calledOutsideHook)
	if frame:IsForbidden() or not UnitPlayerControlled(frame.displayedUnit) then
		return
	end

	if not calledOutsideHook then
		ns.UpdateNameRaidColor(frame)
	end

	local name = frame.name
	local dead = (_G[ns.OPTIONS_NAME].IconOnDeath and KRF_UnitIsDeadOrGhost(frame)) and l.RT8 or ""

	if _G[ns.OPTIONS_NAME].HideRealm then
		local playerName, realm = UnitName(frame.displayedUnit)
		realm = realm or ""
		name:SetText(dead .. playerName .. (realm ~= "" and FOREIGN_SERVER_LABEL or "")) -- (*)
	elseif _G[ns.OPTIONS_NAME].IconOnDeath then
		name:SetText(dead .. GetUnitName(frame.displayedUnit, true))
	end
end

--[[
! Update Raid/Party frames color
]]
function ns.UpdateNameRaidColor(frame)
    if not frame:IsForbidden() and UnitPlayerControlled(frame.displayedUnit) and FrameIsCompact(frame) then
        local name = frame.name;
        local c = KRF_GetClassColors()[select(2,UnitClass(frame.displayedUnit))];
        -- Party / Raid Frames
        if _G[ns.OPTIONS_NAME].FriendsClassColor then
            if KRF_UnitIsDeadOrGhost(frame) then
                local lowColor = (not _G[ns.OPTIONS_NAME].RevertBar) and _G[ns.OPTIONS_NAME].BGColorLow or _G[ns.OPTIONS_NAME].RevertColorLow;
                name:SetVertexColor(lowColor.r, lowColor.g, lowColor.b, lowColor.a or 1);
                name:SetShadowColor(lowColor.r, lowColor.g, lowColor.b, 0.2);
            else
                if c then
                    local r, g, b = c.r, c.g, c.b;
                    if (not _G[ns.OPTIONS_NAME].RevertBar) then
                        r, g, b = lighten(r, g, b, 0.20);
                    end
                    name:SetVertexColor(r, g, b);
                    name:SetShadowColor(r, g, b, 0.2);
                end
                name:SetAlpha(KRF_UnitIsConnected(frame) and 1 or 0.5);
            end
        end
    end
end

function ns.ApplyFuncToRaidFrames(func, ...)
	for member = 1, 40 do
		local frame = _G["CompactRaidFrame"..member];
		if frame and frame:IsVisible() then
			func(frame, ...);
		end
	end
	for member = 1, 5 do
		local frame = _G["CompactPartyFrameMember"..member];
		if frame and frame:IsVisible() then
			func(frame, ...);
		end
	end
	for raid = 1, 8 do
		if _G["CompactRaidGroup"..raid] ~= nil and _G["CompactRaidGroup"..raid]:IsVisible() then
			for member = 1, 5 do
				local frame = _G["CompactRaidGroup"..raid.."Member"..member];
				if frame == nil or not frame:IsVisible() then
					break;
				end
				func(frame, ...);
			end
		end
	end
end

function ns.RaidFrames_ResetHealth(frame, testMode)
	local health = UnitHealth(frame.displayedUnit);
	if testMode then
		if frame._testHealthPercentage == nil then
			frame._testHealthPercentage = fastrandom(0, 100)
		end

		if frame._testHealthPercentage == 0 and not frame._testUnitDisconnected then
			frame._testUnitDisconnected = true;
			frame.statusText:SetText(PLAYER_OFFLINE);
			ns.Hook_UpdateHealth(frame, 0);
			return
		end
		frame._testUnitDisconnected = nil;
		local unitHealthMax = UnitHealthMax(frame.displayedUnit);
		frame._testHealthPercentage = (frame._testHealthPercentage == 0) and 100 or math.max(0, frame._testHealthPercentage - 5);
		health = ceil(unitHealthMax * frame._testHealthPercentage / 100);
		if frame._testHealthPercentage <= 0 then
			frame.statusText:SetText(DEAD);
		else
			frame.statusText:SetText(format("%d%%", frame._testHealthPercentage));
		end
	end
	frame.healthBar:SetValue(health);
	ns.Hook_UpdateHealth(frame, health);
end

function ns.DebugFrames()
	ns.IsDebugFramesTimerActive = not ns.IsDebugFramesTimerActive;
	if ns.IsDebugFramesTimerActive then
		ns.AddMsgWarn(l.OPTION_DEBUG_ON_MESSAGE);
		ns.optionsFrame.Debug.Text:SetText(l.OPTION_DEBUG_OFF);
		ns.optionsFrame.Debug.tooltipText = l.OPTION_DEBUG_OFF;
		PlaySound(SOUNDKIT.IG_MAINMENU_OPEN, "Master")
		ns.LoopDebug();
	else
		ns.AddMsgWarn(l.OPTION_DEBUG_OFF_MESSAGE);
		ns.optionsFrame.Debug.Text:SetText(l.OPTION_DEBUG_ON);
		ns.optionsFrame.Debug.tooltipText = l.OPTION_DEBUG_ON;
		PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE, "Master")
	end
end
function ns.LoopDebug()
	if ns.IsDebugFramesTimerActive then
		ns.ApplyFuncToRaidFrames(ns.RaidFrames_ResetHealth, true);
		C_Timer.After(.5, ns.LoopDebug);
	else
		ns.ApplyFuncToRaidFrames(ns.RaidFrames_ResetHealth, false);
	end
end


--@do-not-package@
--[[
? Changements: https://wowpedia.fandom.com/wiki/Patch_10.0.2/API_changes
? Help : https://github.com/fgprodigal/BlizzardInterfaceCode_zhTW/blob/master/Interface/FrameXML/CompactUnitFrame.lua
? https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/CompactUnitFrame.lua
? Depuis http://www.wowinterface.com/forums/showthread.php?t=56237
? Réf Blizzard http://wowwiki.wikia.com/wiki/Widget_API
? Hooks: https://wowpedia.fandom.com/wiki/Category:API_functions/restricted

? https://www.curseforge.com/wow/addons/blizzard-raid-frames-solo-frame

? /fstack /dump CompactPartyFrameMember1.myHealPrediction
? /console scriptErrors 1
? print (tostring(checked))
? /run print(select(4, GetBuildInfo()))  
? wowversion, wowbuild, wowdate, wowtocversion = GetBuildInfo()

EditModeManagerFrame:IsEditModeActive()
]]
--@end-do-not-package@