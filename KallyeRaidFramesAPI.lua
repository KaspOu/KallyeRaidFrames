function KRF_SetDefaultOptions(DefaultOptions, reset)
	if reset or KallyeRaidFramesOptions == nil then
		KallyeRaidFramesOptions = CopyTable(DefaultOptions)
	else
		foreach(DefaultOptions,
			function (k, v)
				if KallyeRaidFramesOptions[k] == nil then
					KallyeRaidFramesOptions[k] = v;
				end
			end
		);
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
	if _G.KRF_IsDebugFramesTimerActive then
		return not frame._testUnitDisconnected;
	end
	return UnitIsConnected(frame.unit);
end

local function KRF_UnitIsDeadOrGhost(frame)
	if _G.KRF_IsDebugFramesTimerActive then
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
local function mergeRGB(r1, g1, b1, r2, g2, b2, percent, alpha)
	return r1*(1-percent) + r2*percent, g1*(1-percent) + g2*percent, b1*(1-percent) + b2*percent, alpha
end
local function mergeColors(color1, color2, percent)
	return mergeRGBA(color1.r, color1.g, color1.b, color1.a, color2.r, color2.g, color2.b, color2.a, percent)
end
local function darken(r, g, b, percent, alpha)
	return r*(1-percent), g*(1-percent), b*(1-percent), alpha or 1
end
local function lighten(r, g, b, percent, alpha)
	return r*(1-percent) + percent, g*(1-percent) + percent, b*(1-percent) + percent, alpha or 1
end


--[[
! Managing Health & Alpha
- Normal or revert, depending on option
]]
function KRF_Hook_UpdateHealth(frame, health)
	if KallyeRaidFramesOptions.UpdateHealthColor and not frame:IsForbidden() then
		if not KallyeRaidFramesOptions.RevertBar then
			UpdateHealth_Regular(frame, health)
		else
			UpdateHealth_Reverted(frame, health)
		end
	end
end

--[[
! Managing Alpha depending on range
- Alpha not in range
- then alpha out of combat
- Disabled if alpha values are equals to blizzard default (100% / 55%)
]]
function KRF_Hook_UpdateInRange(frame)
	if UnitInPartyOrRaid(frame) and FrameIsCompact(frame) and not frame:IsForbidden() then
		local isInRange, hasCheckedRange = UnitInRange(frame.displayedUnit);
		local newAlpha = 1;
		if KallyeRaidFramesOptions.AlphaNotInRange < 100 and hasCheckedRange and not isInRange then
			newAlpha = KallyeRaidFramesOptions.AlphaNotInRange/100;
		elseif not InCombatLockdown() and KallyeRaidFramesOptions.AlphaNotInCombat < 100 then
			newAlpha = KallyeRaidFramesOptions.AlphaNotInCombat/100;
		end
		if (floor(frame:GetAlpha()*100) ~= floor(newAlpha*100)) then
			frame:SetAlpha(newAlpha);
			frame.background:SetAlpha(newAlpha);
		end
	end
end
--[[
! Managing Health color: background
]]
function UpdateHealth_Regular(frame, health)
	if not frame:IsForbidden() and frame.background and UnitInPartyOrRaid(frame) and FrameIsCompact(frame) then
		local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
		if c and frame.optionTable.useClassColors then
			frame.healthBar:SetStatusBarColor(darken(c.r, c.g, c.b, .2, .95))
		end
		if not KRF_UnitIsConnected(frame) then
			-- Disconnected
			frame.healthBar:SetValue(0);
			frame.background:SetColorTexture(darken(KallyeRaidFramesOptions.BGColorLow.r, KallyeRaidFramesOptions.BGColorLow.g, KallyeRaidFramesOptions.BGColorLow.b, .6, .4));
			KRF_Hook_UpdateName(frame, true);
			KRF_UpdateNameColor(frame);
		elseif KRF_UnitIsDeadOrGhost(frame) then
			-- Dead
			frame.healthBar:SetValue(0);
			frame._wasDead = true;
			if (KallyeRaidFramesOptions.IconOnDeath) then
				KRF_Hook_UpdateName(frame, true);
			end
			KRF_UpdateNameColor(frame);
			frame.background:SetColorTexture(darken(c.r, c.g, c.b, .7, .8));
		else
			-- Alive
			health = health or UnitHealth(frame.displayedUnit);
			local unitHealthMax = UnitHealthMax(frame.displayedUnit);
			local healthPercentage = ceil((health / unitHealthMax * 100));
			frame.background:SetColorTexture(GetHPSeverity(healthPercentage/100, false))
			if frame._wasDead then
				if (KallyeRaidFramesOptions.IconOnDeath) then
					KRF_Hook_UpdateName(frame, true);
				end
				KRF_UpdateNameColor(frame);
				frame._wasDead = false;
			end
		end
	end
end

--[[
! Managing Health color: reverted bar
]]
function UpdateHealth_Reverted(frame, health)
	if not frame:IsForbidden() and UnitInPartyOrRaid(frame) and FrameIsCompact(frame) then
		local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];

		if c and frame and frame.background and frame.optionTable.useClassColors then
			frame.background:SetColorTexture(darken(c.r, c.g, c.b, .7, .8));
			frame.name:SetShadowColor(c.r, c.g, c.b, .3);
		end

		if not KRF_UnitIsConnected(frame) then
			-- Disconnected
			frame.healthBar:SetValue(0);
			frame.background:SetColorTexture(darken(KallyeRaidFramesOptions.RevertColorLow.r, KallyeRaidFramesOptions.RevertColorLow.g, KallyeRaidFramesOptions.RevertColorLow.b, .6, .4));
			KRF_Hook_UpdateName(frame, true);
			KRF_UpdateNameColor(frame);
		elseif KRF_UnitIsDeadOrGhost(frame) then
			-- Dead
			frame.healthBar:SetValue(0);
			frame._wasDead = true;
			if (KallyeRaidFramesOptions.IconOnDeath) then
				KRF_Hook_UpdateName(frame, true);
			end
			KRF_UpdateNameColor(frame);
		else
			-- Alive
			health = health or UnitHealth(frame.displayedUnit);
			local unitHealthMax = UnitHealthMax(frame.displayedUnit);
			local healthPercentage = ceil((health / unitHealthMax * 100));
			local healthLost = unitHealthMax - health;
			frame.healthBar:SetStatusBarColor(GetHPSeverity(healthPercentage/100, true));
			if frame._wasDead then
				if (KallyeRaidFramesOptions.IconOnDeath) then
					KRF_Hook_UpdateName(frame, true);
				end
				KRF_UpdateNameColor(frame);
				frame._wasDead = false;
			end

			-- Set reverted value
			if (  frame.optionTable.smoothHealthUpdates ) then
				frame.healthBar:SetSmoothedValue(healthLost);
			else
				frame.healthBar:SetValue(healthLost);
			end
		end
	end
end

--[[
! UpdateRoleIcon
- Role icon on top left
- Role icon visible only for tanks / heals
- Reposition name accordingly
]]
function KRF_Hook_UpdateRoleIcon(frame)
	if not frame:IsForbidden() and (KallyeRaidFramesOptions.HideDamageIcons or KallyeRaidFramesOptions.MoveRoleIcons) then
		local icon = frame.roleIcon;
		if not icon then
			return;
		end

		local offset = icon:GetWidth() / 4;

		if KallyeRaidFramesOptions.MoveRoleIcons then
			icon:ClearAllPoints();
			icon:SetPoint("TOPLEFT", -offset, offset);
			frame.name:SetPoint("TOPLEFT", 5, -5);
		end

		local role = UnitGroupRolesAssigned(frame.unit);
		if KallyeRaidFramesOptions.HideDamageIcons and role == "DAMAGER" then
			icon:Hide();
		end
	end
end

--[[
! Manage buffs
- Scale buffs / debuffs
]]
function KRF_Hook_ManageBuffs(frame,numbuffs)
	if KallyeRaidFramesOptions.BuffsScale ~= 1 then
		for i=1, #frame.buffFrames do
			frame.buffFrames[i]:SetScale(KallyeRaidFramesOptions.BuffsScale);
		end
	end

	if KallyeRaidFramesOptions.DebuffsScale ~= 1 then
		for i=1, #frame.debuffFrames do
			frame.debuffFrames[i]:SetScale(KallyeRaidFramesOptions.DebuffsScale);
		end
		for i=1, #frame.dispelDebuffFrames do
			frame.dispelDebuffFrames[i]:SetScale(KallyeRaidFramesOptions.DebuffsScale);
		end
	end

	-- ! MaxBuffs Deprecated
	-- if KallyeRaidFramesOptions.MaxBuffs > 0 then
	-- 	frame.maxBuffs = KallyeRaidFramesOptions.MaxBuffs;
	-- end
end


--[[
! Manage player names (partyframes & nameplates)
- Hide realm
- Add death icon (option)
- Call to KRF_UpdateNameColor (only inside hook)
]]
function KRF_Hook_UpdateName(frame, calledOutsideHook)
	if not frame:IsForbidden() then
		if UnitIsPlayer(frame.displayedUnit) then
			local playerNameServer = GetUnitName(frame.displayedUnit, true);
			if (not calledOutsideHook) then
				KRF_UpdateNameColor(frame);
			end

			local name = frame.name;
			local dead = (KallyeRaidFramesOptions.IconOnDeath and KRF_UnitIsDeadOrGhost(frame)) and RT8 or "";

			if KallyeRaidFramesOptions.HideRealm then
				local playerName = GetUnitName(frame.displayedUnit, false);
				if playerName ~= playerNameServer then
					if strsub(playerName, -3) == "(*)" then
						-- ? playerName can already contains (*) if name has unicode chars
						name:SetText(dead..playerName);
					else
						name:SetText(dead..playerName.." (*)");
					end
				else
					name:SetText(dead..playerName);
				end
			elseif KallyeRaidFramesOptions.IconOnDeath then
				name:SetText(dead..playerNameServer);
			end
		end
	end
end

--[[
! Manage player name colors (partyframes & nameplates)
- Class Color for Nameplates or Frames (inc. Dead / Disconnected)
]]
function KRF_UpdateNameColor(frame)
	if not frame:IsForbidden() and UnitIsPlayer(frame.displayedUnit) then
		local name = frame.name;
		if not FrameIsCompact(frame) then
			-- Nameplates: change color (works outside instances)
			if KallyeRaidFramesOptions.FriendsClassColor_Nameplates and UnitIsFriend(frame.displayedUnit,"player") then
				local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.displayedUnit))];
				if c then
					name:SetVertexColor(c.r, c.g, c.b);
					name:SetShadowColor(c.r, c.g, c.b, 0.2);
				end
			end
		else
			-- Party / Raid Frames
			if KallyeRaidFramesOptions.FriendsClassColor then
				if KRF_UnitIsDeadOrGhost(frame) then
					local lowColor = (not KallyeRaidFramesOptions.RevertBar) and KallyeRaidFramesOptions.BGColorLow or KallyeRaidFramesOptions.RevertColorLow;
					name:SetVertexColor(lowColor.r, lowColor.g, lowColor.b, lowColor.a or 1);
					name:SetShadowColor(lowColor.r, lowColor.g, lowColor.b, 0.2);
				else
					local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.displayedUnit))];
					if c then
						local r, g, b = c.r, c.g, c.b;
						if (not KallyeRaidFramesOptions.RevertBar) then
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
end

--[[
! Solo Party Frames
- Show Party Frames even if solo (but not in raid)
]]
function KRF_Hook_CompactPartyFrame_UpdateVisibility()
	if not CompactPartyFrame:IsForbidden() then
		local PartyFramesShown = EditModeManagerFrame:ArePartyFramesForcedShown() or not IsInRaid();
		local ShowCompactPartyFrame = PartyFramesShown and EditModeManagerFrame:UseRaidStylePartyFrames();
		if CompactPartyFrame:IsShown() ~= ShowCompactPartyFrame then
			CompactPartyFrame:SetShown(ShowCompactPartyFrame);
			PartyFrame:UpdatePaddingAndLayout();
		end
	end
end

function GetHPSeverity(percent, revert)
	local BGColorOK=revert and KallyeRaidFramesOptions.RevertColorOK or KallyeRaidFramesOptions.BGColorOK;
	local BGColorWarn=revert and KallyeRaidFramesOptions.RevertColorWarn or KallyeRaidFramesOptions.BGColorWarn;
	local BGColorLow=revert and KallyeRaidFramesOptions.RevertColorLow or KallyeRaidFramesOptions.BGColorLow;
	local pLimitLow = KallyeRaidFramesOptions.LimitLow / 100;
	local pLimitWarn = KallyeRaidFramesOptions.LimitWarn / 100;
	local pLimitOk = KallyeRaidFramesOptions.LimitOk / 100;

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
!  Default chat
]]
function KRF_AddMsg(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgNormal)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", YLL, msg));
	end
end
--[[
!  Warning chat
]]
function KRF_AddMsgWarn(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgWarning)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", CY, msg));
	end
end
--[[
!  Error chat
]]
function KRF_AddMsgErr(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgError)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s: %s|r", RDL, KRF_TITLE, msg));
	end
end

function KRF_AddMsgD(msg, r, g, b)
	if (r == nil) then r = 0.5; end
	if (g == nil) then g = 0.8; end
	if (b == nil) then b = 1; end
	if (DEFAULT_CHAT_FRAME and O and O.Debug) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
	end
end

function KRF_OptionsEnable(FrameObject, isEnabled, disabledAlpha)
	if isEnabled then
		FrameObject:Enable();
		FrameObject:SetAlpha(1);
	else
		FrameObject:Disable();
		FrameObject:SetAlpha(disabledAlpha or .6);
	end
end
function KRF_OptionsSetShownAndEnable(FrameObject, isShowned, isEnabled)
	FrameObject:SetShown(isShowned);
	if (isShowned) then
		KRF_OptionsEnable(FrameObject, isEnabled);
	end
end

function KRF_ApplyFuncToRaidFrames(func, ...)
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

function KRF_RaidFrames_ResetHealth(frame, testMode)
	local health = UnitHealth(frame.displayedUnit);
	if testMode then
		if frame._testHealthPercentage == nil then
			frame._testHealthPercentage = fastrandom(0, 100)
		end

		if frame._testHealthPercentage == 0 and not frame._testUnitDisconnected then
			frame._testUnitDisconnected = true;
			frame.statusText:SetText(PLAYER_OFFLINE);
			KRF_Hook_UpdateHealth(frame, 0);
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
	KRF_Hook_UpdateHealth(frame, health);
end

function KRF_DebugFrames()
	_G.KRF_IsDebugFramesTimerActive = not _G.KRF_IsDebugFramesTimerActive;
	if _G.KRF_IsDebugFramesTimerActive then
		KRF_AddMsgWarn(KRF_OPTION_DEBUG_ON_MESSAGE);
		KRFOptionsFrame_Debug.Text:SetText(KRF_OPTION_DEBUG_OFF);
		KRFOptionsFrame_Debug.tooltipText = KRF_OPTION_DEBUG_OFF;
		_G.PlaySound(850, "Master") -- SOUNDKIT.IG_MAINMENU_OPEN
		KRF_LoopDebug();
	else
		KRF_AddMsgWarn(KRF_OPTION_DEBUG_OFF_MESSAGE);
		KRFOptionsFrame_Debug.Text:SetText(KRF_OPTION_DEBUG_ON);
		KRFOptionsFrame_Debug.tooltipText = KRF_OPTION_DEBUG_ON;
		_G.PlaySound(851, "Master") -- SOUNDKIT.IG_MAINMENU_CLOSE
	end
end
function KRF_LoopDebug()
	if _G.KRF_IsDebugFramesTimerActive then
		KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, true);
		C_Timer.After(.5, KRF_LoopDebug);
	else
		KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, false);
	end
end

function KRF_ShowEditMode(window)
	ShowUIPanel(EditModeManagerFrame);
	if window == "PartyFrame" then
		EditModeManagerFrame.AccountSettings.Settings.PartyFrames:SetControlChecked(true);
		--EditModeManagerFrame:SelectSystem(PartyFrame);
		PartyFrame:SelectSystem();
		PartyFrame:HighlightSystem();
		KRF_AddMsgWarn(KRF_OPTION_EDITMODE_PARTY_NOTE);
	end
end

--@do-not-package@
--[[
? Changements: https://wowpedia.fandom.com/wiki/Patch_10.0.2/API_changes
? Help : https://github.com/fgprodigal/BlizzardInterfaceCode_zhTW/blob/master/Interface/FrameXML/CompactUnitFrame.lua
? https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/CompactUnitFrame.lua
? Depuis http://www.wowinterface.com/forums/showthread.php?t=56237
? Réf Blizzard http://wowwiki.wikia.com/wiki/Widget_API

? https://www.curseforge.com/wow/addons/blizzard-raid-frames-solo-frame

? /fstack /dump
? /console scriptErrors 1
? print (tostring(checked))
? /run print(select(4, GetBuildInfo()))
]]
--@end-do-not-package@