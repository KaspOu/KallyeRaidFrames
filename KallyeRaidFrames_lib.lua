
function UnitInPartyOrRaid(Unit)
	return UnitInParty(Unit) or UnitInRaid(Unit) or UnitIsUnit(Unit, "player")
end

function FrameIsCompact(frame)
	return strsub(frame:GetName(), 0, 7) == "Compact"
end


--[[
! Managing Health
]]
function Kallye_UpdateHealth(frame)
	if KallyeRaidFramesOptions.UpdateHealthColor then
		if not KallyeRaidFramesOptions.RevertBar then
			UpdateHealth_Background(frame)
		else
			UpdateHealth_Reverted(frame)
		end
	end
end

--[[
! Managing Health color: background
]]
function UpdateHealth_Background(frame)
	if not frame:IsForbidden() and frame.background and UnitInPartyOrRaid(frame.displayedUnit) and FrameIsCompact(frame) then
		local healthPercentage = ceil((UnitHealth(frame.displayedUnit) / UnitHealthMax(frame.displayedUnit) * 100))

		if KallyeRaidFramesOptions.DebugRandomHealth then
			healthPercentage = math.random(10,90)
			frame.healthBar:SetValue(ceil(UnitHealthMax(frame.displayedUnit) * healthPercentage / 100));
		end

		-- texture:SetVertexColor(r, g, b, a)
		local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
		if c and frame.optionTable.useClassColors then
			--frame.healthBar:SetStatusBarColor(c.r, c.g, c.b, 0.9)
			frame.healthBar:SetStatusBarColor(darken(c.r, c.g, c.b, .2, .95))
		else
			--frame.healthBar:SetStatusBarColor(0, 0, 0)
		end
		frame.healthBar:SetAlpha(1);
		frame.name:SetAlpha(1);
		frame.name:SetTextColor(1, 1, 1);
		-- frame.healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		-- "Interface\\TargetingFrame\\UI-StatusBar"
		-- if healthPercentage > KallyeRaidFramesOptions.LimitOk and healthPercentage > KallyeRaidFramesOptions.LimitWarning then
		-- 	frame.background:SetColorTexture(.1, .1, .1, .5)
		-- else
		if healthPercentage > 0 then
			frame.background:SetColorTexture(GetHPSeverity(healthPercentage/100, false)) --, math.max(.5, (100-healthPercentage)/100)))
		else
			frame.name:SetTextColor(1, 0, 0)
			local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
			if c and frame.optionTable.useClassColors then
				--frame.healthBar:SetStatusBarColor(c.r, c.g, c.b, 0.5)
				frame.background:SetColorTexture(c.r, c.g, c.b, 0.2)
			else
				--frame.healthBar:SetStatusBarColor(0, 0, 0)
				frame.background:SetColorTexture(.2, .2, .1)
			end
		end
		-- frame.background:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")

		-- local playerName = GetUnitName(frame.unit, true);
		-- frame.name:SetText(playerName.." "..healthPercentage);
	end
end

--[[
! Managing Health color: reverted bar
TODO : réduire la barre en hauteur, mettre un contour comme sRaidFrames
]]
function UpdateHealth_Reverted(frame)
	-- if frame.optionTable.colorNameBySelection and not frame:IsForbidden() then
	-- frame.optionTable.useClassColors
	-- frame.myHealPredictionBar
	-- frame.otherHealPredictionBar
	if not frame:IsForbidden() and UnitInPartyOrRaid(frame.displayedUnit) and FrameIsCompact(frame) then
	local healthPercentage = ceil((UnitHealth(frame.displayedUnit) / UnitHealthMax(frame.displayedUnit) * 100))
	local healthLost = UnitHealthMax(frame.displayedUnit) - UnitHealth(frame.displayedUnit);
	if KallyeRaidFramesOptions.DebugRandomHealth then
		healthPercentage = math.random(10,90)
		healthLost = ceil(UnitHealthMax(frame.displayedUnit) * (100-healthPercentage) / 100)
	end

	frame.name:SetAlpha(1);
	-- #### Modifs ####
	frame.healthBar:SetHeight(10)
	--frame:SetHeight(30)
	--frame.healthBar:SetAttribute("style-height", 1)
	--frame.healthBar:SetHeight(1)
	--frame.healthBar:ClearAllPoints()
	--frame.healthBar:SetPoint("LEFT", frame.background, "RIGHT") --, 50, 50)
	-- #### Fin Modifs ####

	--frame.healthBar:SetStatusBarTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	-- "Interface\\TargetingFrame\\UI-StatusBar"
	local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
	if c and frame and frame.background and frame.optionTable.useClassColors then
		--frame.background:SetColorTexture(c.r, c.g, c.b, .3)
		frame.background:SetColorTexture(darken(c.r, c.g, c.b, .7, .8))
		-- frame.name:SetTextColor(c.r, c.g, c.b);
		frame.name:SetShadowColor(c.r, c.g, c.b, .3)
	end

	if healthPercentage > 0 then
		frame.healthBar:SetStatusBarColor(GetHPSeverity(healthPercentage/100, true))
		frame.name:SetTextColor(1, 1, 1);
		if IsSpellInRange("Heal",frame.unit) then
			frame.name:SetAlpha(1);
		else
			frame.name:SetAlpha(.5);
		end
	else
		-- local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
		if c and frame.optionTable.useClassColors then
			frame.healthBar:SetStatusBarColor(darken(c.r, c.g, c.b, .8, .3))
		else
			frame.healthBar:SetStatusBarColor(0, 0, 0, 0.1)
		end
		frame.name:SetTextColor(.8, 0, 0)
		frame.name:SetAlpha(0.75);
	end
	--frame.healthBar.border:SetVertexColor(1, 0, 0, 1);
	--frame.healthBar:SetStatusBarColor(GetHPSeverity(healthPercentage/100, true))

	if ( frame.optionTable.smoothHealthUpdates ) then
		if ( frame.newUnit ) then
			frame.healthBar:ResetSmoothedValue(healthLost);
			frame.newUnit = false;
		else
			frame.healthBar:SetSmoothedValue(healthLost);
		end
	else
		--PixelUtil.SetStatusBarValue(frame.healthBar, healthLost);
		frame.healthBar:SetValue(healthLost);
	end
	--frame.healthBar:SetBackdropColor(1, 0, 0)
	--frame.background:SetBackdropColor(0, 1, 0)
	-- local playerName = GetUnitName(frame.unit, true);
	-- frame.name:SetText(playerName.." "..healthPercentage);
	end
end

--[[
! UpdateRoleIcon
Role Icon on top left, visible only for tanks / heals
]]
function Kallye_UpdateRoleIcon(frame)
	if KallyeRaidFramesOptions.HideDamageIcons or KallyeRaidFramesOptions.MoveRoleIcons then
		local icon = frame.roleIcon;
		if not icon then
		return;
		end

		local offset = icon:GetWidth() / 4;

		if KallyeRaidFramesOptions.MoveRoleIcons then
		icon:ClearAllPoints();
		icon:SetPoint("TOPLEFT", -offset, offset);
		end

		local role = UnitGroupRolesAssigned(frame.unit);
		if KallyeRaidFramesOptions.HideDamageIcons and role == "DAMAGER" then
		icon:Hide();
		end
	end
end

--[[
! Manage buffs
Scale buffs / debuffs
Max buffs to display (max 3!)
]]
function Kallye_ManageBuffs (frame,numbuffs)
	for i=1, #frame.buffFrames do
		frame.buffFrames[i]:SetScale(KallyeRaidFramesOptions.BuffsScale);
	end

	for i=1, #frame.debuffFrames do
		frame.debuffFrames[i]:SetScale(KallyeRaidFramesOptions.DebuffsScale);
	end

	if KallyeRaidFramesOptions.MaxBuffs > 0 then
		frame.maxBuffs = KallyeRaidFramesOptions.MaxBuffs;
	end
end


--[[
! Manage names (partyframes & nameplates)
Hide realm
Change name color, according to class
PartyFrames: reposition name
]]
function Kallye_UpdateName(frame)
	if not frame:IsForbidden() then
		-- https://eu.forums.blizzard.com/en/wow/t/improving-default-blizzardui/2890
		-- if frame.name and frame.name:match("^CompactRaidFrame%d") and
		-- strsub(frame.name, 16) == "CompactRaidFrame"

		local UnitIsPlayerControlled = UnitPlayerControlled(frame.displayedUnit)
		if UnitIsPlayerControlled then
			local name = frame.name;
			-- name:SetPoint("TOPLEFT", 5, -5);

			if KallyeRaidFramesOptions.HideRealm then
				local playerNameServer = GetUnitName(frame.displayedUnit, true);
				local playerName = GetUnitName(frame.displayedUnit, false);
				--local playerPVPName = UnitPVPName(frame.displayedUnit);
				if playerName ~= playerNameServer then
					name:SetText(playerName.." (*)");
				end
			end


			if KallyeRaidFramesOptions.FriendsClassColor then
				local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
				if c then
					name:SetTextColor(c.r, c.g, c.b)
					-- name:SetTextColor(darken(c.r, c.g, c.b, .8, 1))
					name:SetShadowColor(c.r, c.g, c.b, 0.2)
				end
			end

			if FrameIsCompact(frame) then
				name:SetPoint("TOPLEFT", 5, -5);
			else
				if ( KallyeRaidFramesOptions.Nameplates_FriendsAlphaNotInCombat ~= 1 or KallyeRaidFramesOptions.Nameplates_FriendsAlphaInCombat ~= 1 ) and UnitIsFriend(frame.displayedUnit, "player") then
					if InCombatLockdown() then
						name:SetAlpha(KallyeRaidFramesOptions.Nameplates_FriendsAlphaInCombat);
						-- name:Hide(1);
					else
						name:SetAlpha(KallyeRaidFramesOptions.Nameplates_FriendsAlphaNotInCombat);
						-- name:Show();
					end
				end
			end
		end
	end
end


--[[
! SoloPartyFrames
]]
local getDAF = GetDisplayedAllyFrames
function SoloRaid_GetDisplayedAllyFrames()
	local daf = getDAF()
	-- if daf == 'party' or not daf then
	-- return 'raid'
	if not daf then
		return 'party'
	else
		return daf
	end
end
--[[
! SoloPartyFrames
]]
local CRFC_OnEvent = CompactRaidFrameContainer_OnEvent
function SoloRaid_CompactRaidFrameContainer_OnEvent(self, event, ...)
	-- Call original to perform its default behavior, also helps future protect this hook
	SoloRaid_CompactRaidFrameContainer_OnEvent(self, event, ...)
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
	local BGColorOk=revert and KallyeRaidFramesOptions.RevertBGColorOk or KallyeRaidFramesOptions.BGColorOk
	local BGColorWarning=revert and KallyeRaidFramesOptions.RevertBGColorWarning or KallyeRaidFramesOptions.BGColorWarning
	local BGColorLow=revert and KallyeRaidFramesOptions.RevertBGColorLow or KallyeRaidFramesOptions.BGColorLow

	if percent > KallyeRaidFramesOptions.LimitOk and percent > KallyeRaidFramesOptions.LimitWarning then
		return BGColorOk.r, BGColorOk.g, BGColorOk.b, BGColorOk.a or 1
	elseif percent > KallyeRaidFramesOptions.LimitWarning then
		return mergeColors(BGColorWarning, BGColorOk, (percent - KallyeRaidFramesOptions.LimitWarning)/ (KallyeRaidFramesOptions.LimitOk - KallyeRaidFramesOptions.LimitWarning))
	elseif percent > KallyeRaidFramesOptions.LimitLow then
		return mergeColors(BGColorLow, BGColorWarning, (percent - KallyeRaidFramesOptions.LimitLow) / (KallyeRaidFramesOptions.LimitWarning - KallyeRaidFramesOptions.LimitLow))
	else
		return BGColorLow.r, BGColorLow.g, BGColorLow.b, BGColorLow.a or 1
	end
end


--[[
!  Default chat
]]
function KALLYE_AddMsg(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgNormal)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", YLL, msg));
	end
end
--[[
!  Warning chat
]]
function KALLYE_AddMsgWarn(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgWarning)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", CY, msg));
	end
end
--[[
!  Error chat
]]
function KALLYE_AddMsgErr(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgError)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s: %s|r", RDL, KALLYE_TITLE, msg));
	end
end

function KALLYE_AddMsgD(msg, r, g, b)
	if (r == nil) then r = 0.5; end
	if (g == nil) then g = 0.8; end
	if (b == nil) then b = 1; end
	if (DEFAULT_CHAT_FRAME and O and O.Debug) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
	end
end

function KRFOptionsEnable(FrameObject, isEnabled)
	if isEnabled then
		FrameObject:Enable();
		FrameObject:SetAlpha(1);
	else
		FrameObject:Disable();
		FrameObject:SetAlpha(.6);
	end
end