

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
	return strsub(frame:GetName(), 0, 7) == "Compact"
end


--[[
! Managing Health & Alpha
]]
function KRF_UpdateHealth(frame)
	if KallyeRaidFramesOptions.UpdateHealthColor then
		if not KallyeRaidFramesOptions.RevertBar then
			UpdateHealth_Regular(frame)
		else
			UpdateHealth_Reverted(frame)
		end
	end
	-- KRF_UpdateInRange(frame)
end

--[[
! Managing Alpha depending on range
]]
function KRF_UpdateInRange(frame)
	if FrameIsCompact(frame) then
		local inRange, checkedRange = UnitInRange(frame.displayedUnit)
		-- IsSpellInRange("Heal",frame.unit)
		if KallyeRaidFramesOptions.AlphaNotInRange < 1 and checkedRange and not inRange then
			frame.name:SetAlpha(KallyeRaidFramesOptions.AlphaNotInRange);
			-- frame.background:SetAlpha(KallyeRaidFramesOptions.AlphaNotInRange);
		else
			frame.name:SetAlpha(1);
			-- frame.background:SetAlpha(1)
		end
	end
end
--[[
! Managing Health color: background
]]
function UpdateHealth_Regular(frame)
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
		-- ? frame.healthBar:SetAlpha(1);
		-- frame.name:SetAlpha(1);
		-- frame.name:SetTextColor(1, 1, 1);
		-- frame.healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		-- "Interface\\TargetingFrame\\UI-StatusBar"
		-- if healthPercentage > KallyeRaidFramesOptions.LimitOk and healthPercentage > KallyeRaidFramesOptions.LimitWarn then
		-- 	frame.background:SetColorTexture(.1, .1, .1, .5)
		-- else
		if healthPercentage > 0 then
			frame.background:SetColorTexture(GetHPSeverity(healthPercentage/100, false))
			if frame.wasDead then
				KRF_UpdateNameColor(frame); -- reset color according options
				frame.wasDead = false;
			end
		else
			-- frame.name:SetTextColor(1, 0, 0)
			-- local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
			-- if c and frame.optionTable.useClassColors then
			-- 	--frame.healthBar:SetStatusBarColor(c.r, c.g, c.b, 0.5)
			-- 	frame.background:SetColorTexture(c.r, c.g, c.b, 0.2)
			-- else
			-- 	--frame.healthBar:SetStatusBarColor(0, 0, 0)
			-- 	frame.background:SetColorTexture(.2, .2, .1)
			-- end
			frame.healthBar:SetStatusBarColor(darken(KallyeRaidFramesOptions.BGColorLow.r, KallyeRaidFramesOptions.BGColorLow.g, KallyeRaidFramesOptions.BGColorLow.b, .8, .3));
			frame.name:SetTextColor(KallyeRaidFramesOptions.BGColorLow.r, KallyeRaidFramesOptions.BGColorLow.g, KallyeRaidFramesOptions.BGColorLow.b)
			-- frame.name:SetAlpha(KallyeRaidFramesOptions.BGColorLow.a);
			frame.wasDead = true;
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
	-- frame.healthBar:SetHeight(10)
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
		if frame.wasDead then
			KRF_UpdateNameColor(frame); -- reset color according options
			frame.wasDead = false;
		end
	else
		-- Unit is dead
		-- if c and frame.optionTable.useClassColors then
		-- 	frame.healthBar:SetStatusBarColor(darken(c.r, c.g, c.b, .8, .3))
		-- else
		-- 	frame.healthBar:SetStatusBarColor(0, 0, 0, 0.1)
		-- end
		frame.healthBar:SetStatusBarColor(darken(KallyeRaidFramesOptions.RevertBGColorLow.r, KallyeRaidFramesOptions.RevertBGColorLow.g, KallyeRaidFramesOptions.RevertBGColorLow.b, .8, .3));
		frame.name:SetTextColor(KallyeRaidFramesOptions.RevertBGColorLow.r, KallyeRaidFramesOptions.RevertBGColorLow.g, KallyeRaidFramesOptions.RevertBGColorLow.b)
		frame.name:SetAlpha(KallyeRaidFramesOptions.RevertBGColorLow.a);
		frame.wasDead = true;
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
function KRF_UpdateRoleIcon(frame)
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
function KRF_ManageBuffs (frame,numbuffs)
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
- Hide realm
- Change name color, according to class
- PartyFrames: reposition name
]]
function KRF_UpdateName(frame)
	KRF_UpdateNameColor(frame);
	if not frame:IsForbidden() then
		-- https://eu.forums.blizzard.com/en/wow/t/improving-default-blizzardui/2890

		local UnitIsPlayerControlled = UnitPlayerControlled(frame.displayedUnit)
		if UnitIsPlayerControlled then
			local name = frame.name;

			if KallyeRaidFramesOptions.HideRealm then
				local playerNameServer = GetUnitName(frame.displayedUnit, true);
				local playerName = GetUnitName(frame.displayedUnit, false);
				if playerName ~= playerNameServer then
					if strsub(playerName, -3) == "(*)" then
						-- ? playerName can already contains (*) if name has accents
						name:SetText(playerName);
					else
						name:SetText(playerName.." (*)");
					end
				end
			end
		end
	end
end

function KRF_UpdateNameColor(frame)
	if not frame:IsForbidden() then
		local UnitIsPlayerControlled = UnitPlayerControlled(frame.displayedUnit)
		if UnitIsPlayerControlled then
			local name = frame.name;
			if KallyeRaidFramesOptions.FriendsClassColor then
				local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.displayedUnit))];
				if c then
					name:SetTextColor(c.r, c.g, c.b)
					-- name:SetTextColor(darken(c.r, c.g, c.b, .8, 1))
					name:SetShadowColor(c.r, c.g, c.b, 0.2)
				end
			end

			if FrameIsCompact(frame) then
				name:SetPoint("TOPLEFT", 5, -5);
			else
				-- -- Experimental
				-- if ( KallyeRaidFramesOptions.Nameplates_FriendsAlphaNotInCombat ~= 1 or KallyeRaidFramesOptions.Nameplates_FriendsAlphaInCombat ~= 1 ) and UnitIsFriend(frame.displayedUnit, "player") then
				-- 	if InCombatLockdown() then
				-- 		name:SetAlpha(KallyeRaidFramesOptions.Nameplates_FriendsAlphaInCombat);
				-- 		-- name:Hide(1);
				-- 	else
				-- 		name:SetAlpha(KallyeRaidFramesOptions.Nameplates_FriendsAlphaNotInCombat);
				-- 		-- name:Show();
				-- 	end
				-- end
			end
		end
	end
end


--[[
! SoloPartyFrames
]]
local Blizzard_GetDisplayedAllyFrames = GetDisplayedAllyFrames; -- protect original behavior
function SoloRaid_GetDisplayedAllyFrames()
	-- Call original default behavior
	local daf = Blizzard_GetDisplayedAllyFrames()

	if not daf then
		return 'party'
	else
		return daf
	end
end

--[[
! SoloPartyFrames
]]
local Blizzard_CompactRaidFrameContainer_OnEvent = CompactRaidFrameContainer_OnEvent;  -- protect original behavior
function SoloRaid_CompactRaidFrameContainer_OnEvent(self, event, ...)
	-- Call original default behavior
	Blizzard_CompactRaidFrameContainer_OnEvent(self, event, ...)

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
	local BGColorOK=revert and KallyeRaidFramesOptions.RevertBGColorOK or KallyeRaidFramesOptions.BGColorOK
	local BGColorWarn=revert and KallyeRaidFramesOptions.RevertBGColorWarn or KallyeRaidFramesOptions.BGColorWarn
	local BGColorLow=revert and KallyeRaidFramesOptions.RevertBGColorLow or KallyeRaidFramesOptions.BGColorLow

	if percent > KallyeRaidFramesOptions.LimitOk and percent > KallyeRaidFramesOptions.LimitWarn then
		return BGColorOK.r, BGColorOK.g, BGColorOK.b, BGColorOK.a or 1
	elseif percent > KallyeRaidFramesOptions.LimitWarn then
		return mergeColors(BGColorWarn, BGColorOK, (percent - KallyeRaidFramesOptions.LimitWarn)/ (KallyeRaidFramesOptions.LimitOk - KallyeRaidFramesOptions.LimitWarn))
	elseif percent > KallyeRaidFramesOptions.LimitLow then
		return mergeColors(BGColorLow, BGColorWarn, (percent - KallyeRaidFramesOptions.LimitLow) / (KallyeRaidFramesOptions.LimitWarn - KallyeRaidFramesOptions.LimitLow))
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



function KRF_ColorButtonWidget(self)
	self._RGBA = { r=1, g=1, b=1, a=1}
	self.SetColor = function(RGBA)
			self._RGBA = RGBA or self._RGBA;
			self._colorSwatch:SetVertexColor(self._RGBA.r, self._RGBA.g, self._RGBA.b, self._RGBA.a)
		end
	self.GetColor = function() return self._RGBA; end
	self:SetScript("OnClick", function(self, ...) KRF_ShowColorPicker(KRF_ColorPickedCallback, self); end)

	self:EnableMouse(true)

	local transparent = self:CreateTexture(nil, "BACKGROUND")
	self:SetNormalTexture(transparent)

	local colorSwatch = self:CreateTexture(nil, "OVERLAY")
	colorSwatch:SetWidth(20)
	colorSwatch:SetHeight(20)
	colorSwatch:SetTexture(130939) -- Interface\\ChatFrame\\ChatFrameColorSwatch
	colorSwatch:SetPoint("LEFT", 4, 0)
	self._colorSwatch = colorSwatch

	local texture = self:CreateTexture(nil, "BACKGROUND")
	colorSwatch.background = texture
	texture:SetWidth(16)
	texture:SetHeight(16)
	texture:SetColorTexture(1, 1, 1)
	texture:SetPoint("CENTER", colorSwatch)
	texture:Show()

	local checkers = self:CreateTexture(nil, "BACKGROUND")
	colorSwatch.checkers = checkers
	checkers:SetWidth(14)
	checkers:SetHeight(14)
	checkers:SetTexture(188523) -- Tileset\\Generic\\Checkers
	checkers:SetTexCoord(.25, 0, 0.5, .25)
	checkers:SetDesaturated(true)
	checkers:SetVertexColor(1, 1, 1, 0.75)
	checkers:SetPoint("CENTER", colorSwatch)
	checkers:Show()

	local text = self:CreateFontString(nil,"OVERLAY","GameFontHighlight")
	text:SetHeight(24)
	text:SetJustifyH("LEFT")
	text:SetTextColor(1, 1, 1)
	text:SetPoint("LEFT", colorSwatch, "RIGHT", 2, 0)
	text:SetPoint("RIGHT")

	text:SetText("Select Color")
	text:Show();
end

function KRF_ShowColorPicker(changedCallback, self)
	ColorPickerFrame.Self = self;
	local r,g,b,o = self._RGBA.r, self._RGBA.g, self._RGBA.b, self._RGBA.a ~= nil and 1-self._RGBA.a or nil;
	ColorPickerFrame:SetColorRGB(r,g,b);
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (o ~= nil), o;
	ColorPickerFrame.previousValues = {r,g,b,o};
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc =
		changedCallback, changedCallback, changedCallback;
	ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
	ColorPickerFrame:Show();
end
function KRF_ColorPickedCallback(restore)
	local newR, newG, newB, newO;
	if restore then
		-- The user bailed, we extract the old color from the table created by ShowColorPicker.
		newR, newG, newB, newO = unpack(restore);
	else
		-- Something changed
		newO, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
	end
	-- Update our internal storage.
	r, g, b, a = newR, newG, newB, 1-newO;
	-- And update any UI elements that use this color...
	ColorPickerFrame.Self.SetColor({ r = r , g = g, b = b, a = a });
end