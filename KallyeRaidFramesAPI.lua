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

StaticPopupDialogs["KRF_CONFIRM_RESET"] = {
	showAlert = true,
	text = CONFIRM_RESET_SETTINGS,
	button1 = ALL_SETTINGS,
	-- button3 = CURRENT_SETTINGS,
	button2 = CANCEL,
	OnAccept = function()												
		KRF_SetDefaultOptions(KRF_DefaultOptions, true);
		ReloadUI();
	end,
	-- OnAlt  = function()	end,
	timeout = STATICPOPUP_TIMEOUT,
	timeoutInformationalOnly = false,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint
};

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
	if KRF_Globals.IsDebugFramesTimerActive then
		return not frame._testUnitDisconnected;
	end
	return UnitIsConnected(frame.unit);
end

local function KRF_UnitIsDeadOrGhost(frame)
	if KRF_Globals.IsDebugFramesTimerActive then
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

local function KRF_GetClassColors()
	return CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;
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
		local c = KRF_GetClassColors()[select(2,UnitClass(frame.unit))];
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
			frame.background:SetColorTexture(GetHPSeverity(healthPercentage/100, false));
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
		local c = KRF_GetClassColors()[select(2,UnitClass(frame.unit))];

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
		if UnitPlayerControlled(frame.displayedUnit) then
			if (not calledOutsideHook) then
				KRF_UpdateNameColor(frame);
			end

			local name = frame.name;
			local dead = (KallyeRaidFramesOptions.IconOnDeath and KRF_UnitIsDeadOrGhost(frame)) and KRF_Globals.RT8 or "";

			if KallyeRaidFramesOptions.HideRealm then
				local playerName, realm = UnitName(frame.displayedUnit);
				if realm and realm ~= "" then
					name:SetText(dead..playerName..FOREIGN_SERVER_LABEL); -- " (*)"
				else
					name:SetText(dead..playerName);
				end
			elseif KallyeRaidFramesOptions.IconOnDeath then
				name:SetText(dead..GetUnitName(frame.displayedUnit, true));
			end
		end
	end
end

--[[
! Manage player name colors (partyframes & nameplates)
- Class Color for Nameplates or Frames (inc. Dead / Disconnected)
]]
function KRF_UpdateNameColor(frame)
	if not frame:IsForbidden() and UnitPlayerControlled(frame.displayedUnit) then
		local name = frame.name;
		local r, g, b, a = UnitSelectionColor(frame.displayedUnit);
		-- pet default color, or player class color
		local c = not UnitIsPlayer(frame.displayedUnit) and {r= r, g= g, b=b, a=a} or KRF_GetClassColors()[select(2,UnitClass(frame.displayedUnit))];
		if not FrameIsCompact(frame) then
			-- Nameplates: change color (works outside instances)
			if c and KallyeRaidFramesOptions.FriendsClassColor_Nameplates and (KallyeRaidFramesOptions.EnemiesClassColor_Nameplates or UnitIsFriend(frame.displayedUnit,"player")) then
				if UnitIsPlayer(frame.displayedUnit) then
					-- change nameplate text color only for players, not pets
					name:SetVertexColor(c.r, c.g, c.b);
					name:SetShadowColor(c.r, c.g, c.b, 0.2);
				end
				-- colorNameBySelection: nameplates already colored, Since BfA (7)
				if (not KRF_HAS_colorNameBySelection) then
					-- on every refresh, not only player, it will avoid misscolorations on updates
					local healthBar = frame.healthBar;
					healthBar:SetStatusBarColor(c.r, c.g, c.b);
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
! Solo Raid Frames main, since DragonFlight (10)
- Show Raid Frames if solo
]]
function KRF_Hook_CompactPartyFrame_UpdateVisibility()
	if (not IsInGroup() and not IsInRaid()) then
		CompactPartyFrame:SetShown(true);
	end
end

--[[
! Solo Party Frames Classic
- Show Party/Raid Frames even if solo
]]
local KRF_Blizzard_GetDisplayedAllyFrames = GetDisplayedAllyFrames; -- protect original behavior
function KRF_SoloRaid_GetDisplayedAllyFrames()
	-- Call original default behavior
	local daf = KRF_Blizzard_GetDisplayedAllyFrames()

	if not daf then
		return 'party'
	else
		return daf
	end
end
local KRF_Blizzard_CompactRaidFrameContainer_OnEvent = CompactRaidFrameContainer_OnEvent;  -- protect original behavior
function KRF_SoloRaid_CompactRaidFrameContainer_OnEvent(self, event, ...)
	-- Call original default behavior
	KRF_Blizzard_CompactRaidFrameContainer_OnEvent(self, event, ...)

	-- If all these are true, then the above call already did the TryUpdate
	local unit = ... or ""
	if ( unit == "player" or strsub(unit, 1, 4) == "raid" or strsub(unit, 1, 5) == "party" ) then
		return
	end
	-- Always update the RaidFrame
	if ( event == "UNIT_PET" ) and ( self.displayPets ) then
		CompactRaidFrameContainer_TryUpdate(self)
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
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", KRF_Globals.YLL, msg or ""));
	end
end
--[[
!  Warning chat
]]
function KRF_AddMsgWarn(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgWarning)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", KRF_Globals.CY, msg or ""));
	end
end
--[[
!  Error chat
]]
function KRF_AddMsgErr(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgError)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s: %s|r", KRF_Globals.RDL, KRF_TITLE, msg or ""));
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
	KRF_Globals.IsDebugFramesTimerActive = not KRF_Globals.IsDebugFramesTimerActive;
	if KRF_Globals.IsDebugFramesTimerActive then
		KRF_AddMsgWarn(KRF_OPTION_DEBUG_ON_MESSAGE);
		KRFOptionsFrame.Debug.Text:SetText(KRF_OPTION_DEBUG_OFF);
		KRFOptionsFrame.Debug.tooltipText = KRF_OPTION_DEBUG_OFF;
		PlaySound(SOUNDKIT.IG_MAINMENU_OPEN, "Master")
		KRF_LoopDebug();
	else
		KRF_AddMsgWarn(KRF_OPTION_DEBUG_OFF_MESSAGE);
		KRFOptionsFrame.Debug.Text:SetText(KRF_OPTION_DEBUG_ON);
		KRFOptionsFrame.Debug.tooltipText = KRF_OPTION_DEBUG_ON;
		PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE, "Master")
	end
end
function KRF_LoopDebug()
	if KRF_Globals.IsDebugFramesTimerActive then
		KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, true);
		C_Timer.After(.5, KRF_LoopDebug);
	else
		KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, false);
	end
end

function KRF_ShowEditMode(window)
	ShowUIPanel(EditModeManagerFrame);
	if window == "PartyFrame" then
		C_EditMode.SetAccountSetting(Enum.EditModeAccountSetting.ShowPartyFrames, 1);
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
? Hooks: https://wowpedia.fandom.com/wiki/Category:API_functions/restricted

? https://www.curseforge.com/wow/addons/blizzard-raid-frames-solo-frame

? /fstack /dump CompactPartyFrameMember1.myHealPrediction
? /console scriptErrors 1
? print (tostring(checked))
? /run print(select(4, GetBuildInfo()))  
? wowversion, wowbuild, wowdate, wowtocversion = GetBuildInfo()
]]
--@end-do-not-package@