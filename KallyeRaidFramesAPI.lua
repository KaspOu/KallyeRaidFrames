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


function UnitInPartyOrRaid(Unit)
	return UnitInParty(Unit) or UnitInRaid(Unit) or UnitIsUnit(Unit, "player")
end

function FrameIsCompact(frame)
	local getName = frame:GetName();
	return getName ~=nil and strsub(getName, 0, 7) == "Compact"
end


--[[
! Managing Health & Alpha
- Normal or revert, depending on option
]]
function KRF_Hook_UpdateHealth(frame, health)
	if not frame:IsForbidden() and KallyeRaidFramesOptions.UpdateHealthColor then
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
]]
function KRF_Hook_UpdateInRange(frame)
	if not frame:IsForbidden() and FrameIsCompact(frame) then
		local isInRange, hasCheckedRange = UnitInRange(frame.displayedUnit)
		if KallyeRaidFramesOptions.AlphaNotInRange < 100 and hasCheckedRange and not isInRange then
			frame:SetAlpha(KallyeRaidFramesOptions.AlphaNotInRange/100);
		elseif not InCombatLockdown() and not _G.KRF_IsDebugFramesTimerActive and KallyeRaidFramesOptions.AlphaNotInCombat < 100 then
			frame:SetAlpha(KallyeRaidFramesOptions.AlphaNotInCombat/100);
		else
			frame.name:SetAlpha(1);
		end
	end
end
--[[
! Managing Health color: background
]]
function UpdateHealth_Regular(frame, health)
	if not frame:IsForbidden() and frame.background and UnitInPartyOrRaid(frame.displayedUnit) and FrameIsCompact(frame) then
		health = health or UnitHealth(frame.displayedUnit)
		local unitHealthMax = UnitHealthMax(frame.displayedUnit);
		local healthPercentage = ceil((health / unitHealthMax * 100))

		local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
		if c and frame.optionTable.useClassColors then
			frame.healthBar:SetStatusBarColor(darken(c.r, c.g, c.b, .2, .95))
		end
		if health > 0 and not UnitIsDeadOrGhost(frame.displayedUnit) then
			frame.background:SetColorTexture(GetHPSeverity(healthPercentage/100, false))
			if frame.wasDead then
				KRF_UpdateNameColor(frame); -- reset color according options
				frame.wasDead = false;
			end
		else
			-- Unit is dead
			frame.healthBar:SetStatusBarColor(darken(KallyeRaidFramesOptions.BGColorLow.r, KallyeRaidFramesOptions.BGColorLow.g, KallyeRaidFramesOptions.BGColorLow.b, .8, .3));
			KRF_UpdateNameColor(frame, KallyeRaidFramesOptions.BGColorLow);
			frame.wasDead = true;
		end
	end
end

--[[
! Managing Health color: reverted bar
TODO : réduire la barre en hauteur, mettre un contour comme sRaidFrames
]]
function UpdateHealth_Reverted(frame, health)
	if not frame:IsForbidden() and UnitInPartyOrRaid(frame.displayedUnit) and FrameIsCompact(frame) then
		health = health or ( UnitHealth(frame.displayedUnit) + (UnitGetTotalAbsorbs(frame.displayedUnit) or 0) + (UnitGetIncomingHeals(frame.displayedUnit) or 0) );
		local unitHealthMax = UnitHealthMax(frame.displayedUnit);
		local healthPercentage = ceil((health / unitHealthMax * 100))
		local healthLost = unitHealthMax - health;

		frame.name:SetAlpha(1);
		local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];

		if c and frame and frame.background and frame.optionTable.useClassColors then
			frame.background:SetColorTexture(darken(c.r, c.g, c.b, .7, .8))
			frame.name:SetShadowColor(c.r, c.g, c.b, .3)
		end

		if health > 0 and not UnitIsDeadOrGhost(frame.displayedUnit) then
			frame.healthBar:SetStatusBarColor(GetHPSeverity(healthPercentage/100, true));
			if frame.wasDead then
				KRF_UpdateNameColor(frame); -- reset color according options
				frame.wasDead = false;
			end
		else
			-- Unit is dead
			frame.healthBar:SetStatusBarColor(darken(KallyeRaidFramesOptions.RevertColorLow.r, KallyeRaidFramesOptions.RevertColorLow.g, KallyeRaidFramesOptions.RevertColorLow.b, .8, .3));
			KRF_UpdateNameColor(frame, KallyeRaidFramesOptions.RevertColorLow);
			frame.name:SetAlpha(KallyeRaidFramesOptions.RevertColorLow.a);
			frame.wasDead = true;
		end

		-- Revert healthBar
		if ( frame.optionTable.smoothHealthUpdates ) then
			if ( frame.newUnit ) then
				frame.healthBar:ResetSmoothedValue(healthLost);
				frame.newUnit = false;
			else
				frame.healthBar:SetSmoothedValue(healthLost);
			end
		else
			frame.healthBar:SetValue(healthLost);
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
- Max buffs to display (max 3!)
]]
function KRF_Hook_ManageBuffs(frame,numbuffs)
	for i=1, #frame.buffFrames do
		frame.buffFrames[i]:SetScale(KallyeRaidFramesOptions.BuffsScale);
	end

	for i=1, #frame.debuffFrames do
		frame.debuffFrames[i]:SetScale(KallyeRaidFramesOptions.DebuffsScale);
	end

	-- ! MaxBuffs Deprecated
	-- if KallyeRaidFramesOptions.MaxBuffs > 0 then
	-- 	frame.maxBuffs = KallyeRaidFramesOptions.MaxBuffs;
	-- end
end


--[[
! Manage player names (partyframes & nameplates)
- Hide realm
- Change name color, according to class
]]
function KRF_Hook_UpdateName(frame)
	if not frame:IsForbidden() then
		local UnitIsPlayerControlled = UnitIsPlayer(frame.displayedUnit)
		if UnitIsPlayerControlled then
			KRF_UpdateNameColor(frame);

			local name = frame.name;

			if KallyeRaidFramesOptions.HideRealm then
				local playerNameServer = GetUnitName(frame.displayedUnit, true);
				local playerName = GetUnitName(frame.displayedUnit, false);
				if playerName ~= playerNameServer then
					if strsub(playerName, -3) == "(*)" then
						-- ? playerName can already contains (*) if name has unicode chars
						name:SetText(playerName);
					else
						name:SetText(playerName.." (*)");
					end
				end
			end
		end
	end
end

--[[
! Manage player name colors (partyframes & nameplates)
- Allow specific color (for dead color)
- Class Color
- Back to original color after dead or unset class color
]]
function KRF_UpdateNameColor(frame, forceColor)
	if not frame:IsForbidden() and UnitIsPlayer(frame.displayedUnit) then
		local name = frame.name;
		if not FrameIsCompact(frame) then
			-- Nameplates: change color (works outside instances)
			if KallyeRaidFramesOptions.FriendsClassColor_Nameplates and UnitIsFriend(frame.displayedUnit,"player") then
				local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.displayedUnit))];
				if c then
					name:SetTextColor(c.r, c.g, c.b)
					name:SetShadowColor(c.r, c.g, c.b, 0.2)
				end
			end
		else
			-- Compact Raid Frames: change color
			if forceColor ~= nil then
				-- Force color (dead color...)
				if name._InitialColor == nil then
					local r, g, b, a = name:GetTextColor();
					name._InitialColor = { r=r, g=g, b=b, a=a };
				end
				name:SetTextColor(forceColor.r, forceColor.g, forceColor.b)
			elseif KallyeRaidFramesOptions.FriendsClassColor then
				-- Class color
				if name._InitialColor == nil then
					local r, g, b, a = name:GetTextColor();
					name._InitialColor = { r=r, g=g, b=b, a=a };
				end
				local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.displayedUnit))];
				if c then
					name:SetTextColor(c.r, c.g, c.b)
					name:SetShadowColor(c.r, c.g, c.b, 0.2)
				end
			else
				-- Back to previous color
				if name._InitialColor ~= nil then
					name:SetTextColor(name._InitialColor.r, name._InitialColor.g, name._InitialColor.b, name._InitialColor.a);
					name._InitialColor = nil;
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
	local PartyFramesShown = EditModeManagerFrame:ArePartyFramesForcedShown() or (IsInGroup() and not IsInRaid()) or (not IsInGroup() and not IsInRaid());
	local ShowCompactPartyFrame = PartyFramesShown and EditModeManagerFrame:UseRaidStylePartyFrames();
	CompactPartyFrame:SetShown(ShowCompactPartyFrame);
	PartyFrame:UpdatePaddingAndLayout();
end

function mergeRGBA(r1, v1, b1, a1, r2, v2, b2, a2, percent)
	return r1*(1-percent) + r2*percent, v1*(1-percent) + v2*percent, b1*(1-percent) + b2*percent, a1*(1-percent) + a2*percent
end
function mergeRGB(r1, v1, b1, r2, v2, b2, percent, alpha)
	return r1*(1-percent) + r2*percent, v1*(1-percent) + v2*percent, b1*(1-percent) + b2*percent, alpha
end
function mergeColors(color1, color2, percent)
	return mergeRGBA(color1.r, color1.g, color1.b, color1.a, color2.r, color2.g, color2.b, color2.a, percent)
end
function darken(r, v, b, percent, alpha)
	return r*(1-percent), v*(1-percent), b*(1-percent), alpha or 1
end
function lighten(r, v, b, percent, alpha)
	return r*(1-percent) + percent, v*(1-percent) + percent, b*(1-percent) + percent, alpha or 1
end

function GetHPSeverity(percent, revert)
	local BGColorOK=revert and KallyeRaidFramesOptions.RevertColorOK or KallyeRaidFramesOptions.BGColorOK
	local BGColorWarn=revert and KallyeRaidFramesOptions.RevertColorWarn or KallyeRaidFramesOptions.BGColorWarn
	local BGColorLow=revert and KallyeRaidFramesOptions.RevertColorLow or KallyeRaidFramesOptions.BGColorLow
	local pLimitLow = KallyeRaidFramesOptions.LimitLow / 100;
	local pLimitWarn = KallyeRaidFramesOptions.LimitWarn / 100;
	local pLimitOk = KallyeRaidFramesOptions.LimitOk / 100;

	if percent > pLimitOk and percent > pLimitWarn then
		return BGColorOK.r, BGColorOK.g, BGColorOK.b, BGColorOK.a or 1
	elseif percent > pLimitWarn then
		return mergeColors(BGColorWarn, BGColorOK, (percent - pLimitWarn)/ (pLimitOk - pLimitWarn))
	elseif percent > pLimitLow then
		return mergeColors(BGColorLow, BGColorWarn, (percent - pLimitLow) / (pLimitWarn - pLimitLow))
	else
		return BGColorLow.r, BGColorLow.g, BGColorLow.b, BGColorLow.a or 1
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

function KRF_OptionsEnable(FrameObject, isEnabled)
	if isEnabled then
		FrameObject:Enable();
		FrameObject:SetAlpha(1);
	else
		FrameObject:Disable();
		FrameObject:SetAlpha(.6);
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
			frame._testHealthPercentage = fastrandom(0,100)
		end

		local unitHealthMax = UnitHealthMax(frame.displayedUnit);
		frame._testHealthPercentage = (frame._testHealthPercentage == 0) and 100 or math.max(0, frame._testHealthPercentage - 5);
		health = ceil(health * frame._testHealthPercentage / 100);
		frame.statusText:SetText(format("%d%%", frame._testHealthPercentage));
	end
	frame.healthBar:SetValue(health);
	KRF_Hook_UpdateHealth(frame, health);
end

function KRF_DebugFrames(toggle)
	if toggle == true then
		_G.KRF_IsDebugFramesTimerActive = not _G.KRF_IsDebugFramesTimerActive;
		KRF_AddMsgWarn(_G.KRF_IsDebugFramesTimerActive and KRF_OPTION_DEBUG_ON_MESSAGE or KRF_OPTION_DEBUG_OFF_MESSAGE);
	end
	if _G.KRF_IsDebugFramesTimerActive then
		KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, true);
	else
		KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, false);
	end
	if _G.KRF_IsDebugFramesTimerActive then
		C_Timer.After(.5, KRF_DebugFrames);
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