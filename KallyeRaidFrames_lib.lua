
function UnitInPartyOrRaid(Unit)
	return UnitInParty(Unit) or UnitInRaid(Unit) or UnitIsUnit(Unit, "player")
end

function FrameIsCompact(frame)
	return strsub(frame:GetName(), 0, 7) == "Compact"
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
			frame.background:SetColorTexture(GetHPSeverity(healthPercentage/100)) --, math.max(.5, (100-healthPercentage)/100)))
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
		frame.healthBar:SetStatusBarColor(GetHPSeverity(healthPercentage/100))
		frame.name:SetTextColor(1, 1, 1);
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
	--frame.healthBar:SetStatusBarColor(GetHPSeverity(healthPercentage/100))

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
	-- return mergeRGB(r, v, b, 0, 0, 0, percent, alpha or 1)
end
function lighten(r, v, b, percent, alpha)
	return r*(1-percent) + percent, v*(1-percent) + percent, b*(1-percent) + percent, alpha or 1
	-- return mergeRGB(r, v, b, 1, 1, 1, percent, alpha or 1)
end

function GetHPSeverity(percent, alpha)
	if percent > KallyeRaidFramesOptions.LimitOk and percent > KallyeRaidFramesOptions.LimitWarning then
		return KallyeRaidFramesOptions.BGColorOk.r, KallyeRaidFramesOptions.BGColorOk.g, KallyeRaidFramesOptions.BGColorOk.b, KallyeRaidFramesOptions.BGColorOk.a or 1
	elseif percent > KallyeRaidFramesOptions.LimitWarning then
		return mergeColors(KallyeRaidFramesOptions.BGColorWarning, KallyeRaidFramesOptions.BGColorOk, (percent - KallyeRaidFramesOptions.LimitWarning)/ (KallyeRaidFramesOptions.LimitOk - KallyeRaidFramesOptions.LimitWarning))
		-- return (1.0-percent)*2, 1.0, 0.0, alpha or 1
	elseif percent > KallyeRaidFramesOptions.LimitLow then
		return mergeColors(KallyeRaidFramesOptions.BGColorLow, KallyeRaidFramesOptions.BGColorWarning, (percent - KallyeRaidFramesOptions.LimitLow) / (KallyeRaidFramesOptions.LimitWarning - KallyeRaidFramesOptions.LimitLow))
		-- return 1.0, percent*2, 0.0, alpha or 1
	else
		return KallyeRaidFramesOptions.BGColorLow.r, KallyeRaidFramesOptions.BGColorLow.g, KallyeRaidFramesOptions.BGColorLow.b, KallyeRaidFramesOptions.BGColorLow.a or 1
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