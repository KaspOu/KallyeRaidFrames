--[[
Get from LucyRaidFrames
/fstack

 Sur les noms au dessus des barres
   - Change le nom des joueurs   Kallye (*)
   - Change l'alpha des amis en combat / hors combat  (pour les rendre moins visible en combat)
 Modifie les buffs / debuffs (taille des buffs/debuffs, nombre max)
 Barres de raids
   - Déplace les icones de rôle
   - Cache l'icone pour les rôles dps


Aide :
 - KallyeRaidFramesOptions:
     AzeriteTooltip (Ace)
	 GarrisonCommander-Broker (Ace)
	 LFRAdvanced !!

]]

local isInit = false;
local isPlayer = false;

if KallyeRaidFramesOptions == nil then
	KallyeRaidFramesOptions = {
		BuffsScale = 0.75,
		DebuffsScale = 1.25,
		MaxBuffs = 3,
		HideDamageIcons = true,
		MoveRoleIcons = true,
		HideRealm = true,
		FriendsClassColor = true,
		Nameplates_FriendsAlphaInCombat = 0.8,
		Nameplates_FriendsAlphaNotInCombat = 0.8,
		
		ShowMsgNormal = true,
		ShowMsgErr = true,
		ShowMsgWarning = true,
		
		-- BGColorOk =      { r= .1, g= .1, b= .1, a = .3 },
		-- BGColorWarning = { r = 1, g= 1, b= 0, a = .4 },
		-- BGColorLow =    { r= 1, g= 0, b= 0, a = 1 },
		BGColorOk =      { r= 0, g= 1, b= 0, a = 1 },
		BGColorWarning = { r = 1, g= 1, b= 0, a = .8 },
		BGColorLow =    { r= 1, g= 0, b= 0, a = 1 },
		
		LimitOk = .70,
		LimitWarning = .50,
		LimitLow = .20,
		
		RevertBar = true, -- Revert the bar (sRaidFrames like)
		DebugRandomHealth = false,     -- Show random healths (debug)
		SoloRaidFrame = true,     -- Show random healths (debug)
	}
end

--function KALLYE_KallyeRaidFramesOptions_Init()
-- function addon:OnInitialized()
function KALLYE_OnLoad(self)
  -- self:RegisterEvent("ADDON_LOADED");
  -- self:RegisterEvent("PLAYER_ENTERING_WORLD");
  -- self:RegisterEvent("PLAYER_REGEN_ENABLED");
  -- self:RegisterEvent("PLAYER_REGEN_DISABLED");
  
  -- self:RegisterEvent("UNIT_ENTERED_VEHICLE");
  -- self:RegisterEvent("UNIT_EXITED_VEHICLE");

  SlashCmdList["KALLYE"] = KALLYE_command;
  SLASH_KALLYE1 = "/kallye";
  SLASH_KALLYE2 = "/krs";
  SLASH_KALLYE3 = "/rs";
  
  if (isInit or InCombatLockdown()) then return; end 
  KALLYE_AddMsg(KALLYE_MSG_LOADED);
  --_,_, KALLYE_NOTES, KALLYE_ENABLED, KALLYE_LOADABLE, KALLYE_REASON, KALLYE_SECURITY = GetAddOnInfo("KallyeRaidFrames"))
  -- KALLYE_AddMsg(_);
  
  isInit = true;
  self:SetScript("OnEvent", 
    function(self, event, ...)
      KALLYE_OnEvent(self, event, ...);
    end
  );
end -- END KALLYE_OnLoad

function KALLYE_OnUpdate(self, elapsed)
  --[[
  if (isInit) then
    SMARTDEBUFF_Ticker(false);
    SMARTDEBUFF_CheckDebuffs(false);
  else
    ou_time = ou_time + elapsed;    
    if (not isTTreeLoaded and ou_time > 0.5) then
      local _, tName = GetTalentInfo(1, 1, 1);
      if (tName) then
        --DEFAULT_CHAT_FRAME:AddMessage("Talent tree ready ("..ou_time.."sec) -> Init SDB");
        isTTreeLoaded = true;
        SMARTDEBUFF_OnEvent(self, "ONUPDATE");
      end
      ou_time = 0;
    end
  end --]]
 end -- END KALLYE_OnUpdate
 
-- KALLYE_OnEvent
function KALLYE_OnEvent(self, event, ...)
  local arg1 = select(1, ...);
  if ((event == "UNIT_NAME_UPDATE" and arg1 == "player") or event == "PLAYER_ENTERING_WORLD") then
    isPlayer = true;
    --self:UnRegisterEvent("PLAYER_ENTERING_WORLD");
  elseif(event == "ADDON_LOADED" and arg1 == KALLYE_TITLE) then
    isLoaded = true;
    self:UnregisterEvent("ADDON_LOADED");
  end
end -- END KALLYE_OnEvent
 
function KALLYE_command(msgIn)
  if (not isInit) then
    KALLYE_AddMsgWarn(KALLYE_INIT_FAILED, true);
    return;
  end
  InterfaceOptionsFrame_OpenToCategory(KALLYE_TITLE);
  InterfaceOptionsFrame_OpenToCategory(KALLYE_TITLE);
end

function UnitInPartyOrRaid(Unit) 
	return UnitInParty(Unit) or UnitInRaid(Unit) or UnitIsUnit(Unit, "player")
end

function FrameIsCompact(frame)
	return strsub(frame:GetName(), 0, 7) == "Compact"
end
  
-- Bigger Debuffs
hooksecurefunc("CompactUnitFrame_SetMaxBuffs", function(frame,numbuffs)
	for i=1, #frame.buffFrames do
		frame.buffFrames[i]:SetScale(KallyeRaidFramesOptions.BuffsScale);
	end

	for i=1, #frame.debuffFrames do
		frame.debuffFrames[i]:SetScale(KallyeRaidFramesOptions.DebuffsScale);
	end

  if KallyeRaidFramesOptions.MaxBuffs > 0 then 
	frame.maxBuffs = KallyeRaidFramesOptions.MaxBuffs;
  end
end);

-- Change name of players from other realms: (*)
hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
  if not frame:IsForbidden() then
	
	-- https://eu.forums.blizzard.com/en/wow/t/improving-default-blizzardui/2890
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

		
		-- [[ Change player name color
		if KallyeRaidFramesOptions.FriendsClassColor then
			local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
			if c then
				name:SetTextColor(c.r, c.g, c.b)
				-- name:SetTextColor(darken(c.r, c.g, c.b, .8, 1))
				name:SetShadowColor(c.r, c.g, c.b, 0.2)
			end
		end
		-- ]]
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

end);

-- Role Icon on top left, visible only for tanks / heals
hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", function(frame)
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

end);

-- Help : https://github.com/fgprodigal/BlizzardInterfaceCode_zhTW/blob/master/Interface/FrameXML/CompactUnitFrame.lua
-- https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/CompactUnitFrame.lua
-- Depuis http://www.wowinterface.com/forums/showthread.php?t=56237
-- Réf Blizzard http://wowwiki.wikia.com/wiki/Widget_API

-- Changement background
--[[
hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
    -- if frame.optionTable.colorNameBySelection and not frame:IsForbidden() then
	-- frame.optionTable.useClassColors
	-- frame.myHealPredictionBar
	-- frame.otherHealPredictionBar
	if not frame:IsForbidden() and frame.background and UnitInPartyOrRaid(frame.displayedUnit) then
	--if not frame:IsForbidden() and frame.background and UnitInPartyOrRaid(frame.displayedUnit) then
        local healthPercentage = ceil((UnitHealth(frame.displayedUnit) / UnitHealthMax(frame.displayedUnit) * 100))
		-- local healthLost = UnitHealthMax(frame.displayedUnit) - UnitHealth(frame.displayedUnit);
		-- healthPercentage = 25
		-- healthLost = ceil(3 * UnitHealthMax(frame.displayedUnit) / 4)
		
        if C_NamePlate.GetNamePlateForUnit(frame.unit) == C_NamePlate.GetNamePlateForUnit("player") then
            if healthPercentage == 100 then
                --frame.healthBar:SetStatusBarColor(0, 1, 0, 0.5)
				-- frame.background:SetColorTexture(0, 0, 0)
				frame.background:SetColorTexture(1, 0, 0)
            elseif healthPercentage < 100 and healthPercentage > 75 then
                --frame.healthBar:SetStatusBarColor(0, 1, 0, 0.7)
				frame.background:SetColorTexture(0, 1, 0, 0.6)
            elseif healthPercentage <= 75 and healthPercentage > 50 then
                --frame.healthBar:SetStatusBarColor(1, 1, 0, 0.9)
				frame.background:SetColorTexture(1, 1, 0, 0.75)
            elseif healthPercentage <= 50 and healthPercentage > 25 then
                --frame.healthBar:SetStatusBarColor(1, 0.64, 0)
				frame.background:SetColorTexture(1, 0.64, 0)
            elseif healthPercentage <= 25 and healthPercentage > 0 then
                --frame.healthBar:SetStatusBarColor(1, 0, 0)
				frame.background:SetColorTexture(1, 0, 0)
            else
				local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
				if c and frame.optionTable.useClassColors then
					--frame.healthBar:SetStatusBarColor(c.r, c.g, c.b, 0.5)
					frame.background:SetColorTexture(c.r, c.g, c.b, 0.5)
				else
					--frame.healthBar:SetStatusBarColor(0, 0, 0)
					frame.background:SetColorTexture(0, 0, 0)
				end
            end
			frame.background:SetColorTexture(0, 0, 0)
			--frame.healthBar.border:SetVertexColor(1, 0, 0, 1);
			-- frame.healthBar.healthBackground
        end

    end
end)
]]--



if KallyeRaidFramesOptions.RevertBar then
-- Barre inversée
-- TODO : réduire la barre en hauteur, mettre un fond et un contour sRF
hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
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
end)
--
else
-- Changement background
hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
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
		 	-- frame.background:SetColorTexture(.1, .1, .1, .5)
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
end)
--
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
hooksecurefunc("CompactRaidFrameContainer_AddUnitFrame", function()
  local index = 1
  local frame 
  repeat
    frame = _G["CompactRaidFrame"..index]
    if frame and frame.unit and frame.optionTable.useClassColors then
		  local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
		  if c then
			frame.background:SetColorTexture(c.r, c.g, c.b, 0.4)
			--frame.name:SetTextColor(c.r, c.g, c.b, 0.6)
			frame.name:SetShadowColor(c.r, c.g, c.b, 1)
		  end
		--frame.background:SetVertexColor(1, 0, 0, 1)
		--frame.background:SetAlpha(.5)
		--frame.background:SetTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill")
    end
    index = index + 1
  until not frame
end)
]]--

-- Will dump the value of msg to the default chat window
function KALLYE_AddMsg(msg, force)
  if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgNormal)) then
    DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", YLL, msg));
  end
end

function KALLYE_AddMsgWarn(msg, force)
  if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgWarning)) then
    DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", CY, msg));
  end
end

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


function SaveRSOptions()
	-- ReloadUI();
	-- --KallyeRaidFramesOptions.ServerSideFiltering = KallyeRaidFramesOptionsFrameServerSideFiltering:GetChecked();
	-- KallyeRaidFramesOptions.ShowMemberInfo = KallyeRaidFramesOptionsFrameShowMemberInfo:GetChecked();
	-- --KallyeRaidFramesOptions.AutoRefresh = KallyeRaidFramesOptionsFrameAutoRefresh:GetChecked();
	-- --KallyeRaidFramesOptions.AutoRefreshInterval = KallyeRaidFramesOptionsFrameAutoRefreshInterval:GetCurrentValue();
	-- KallyeRaidFramesOptions.HideLegionNormals = KallyeRaidFramesOptionsFrameHideLegionNormals:GetChecked();
	-- KallyeRaidFramesOptions.HideLegionHeroics = KallyeRaidFramesOptionsFrameHideLegionHeroics:GetChecked();
	-- KallyeRaidFramesOptions.HideBFANormals = KallyeRaidFramesOptionsFrameHideBFANormals:GetChecked();
	-- KallyeRaidFramesOptions.HideBFAHeroics = KallyeRaidFramesOptionsFrameHideBFAHeroics:GetChecked();
end

function RefreshRSOptions()
	--KallyeRaidFramesOptionsFrameServerSideFiltering:SetChecked(KallyeRaidFramesOptions.ServerSideFiltering);
	KallyeRaidFramesOptionsFrameShowMemberInfo:SetChecked(KallyeRaidFramesOptions.ShowMemberInfo);
	--KallyeRaidFramesOptionsFrameAutoRefresh:SetChecked(KallyeRaidFramesOptions.AutoRefresh);
	--KallyeRaidFramesOptionsFrameAutoRefreshInterval:SetValue(KallyeRaidFramesOptions.AutoRefreshInterval);
	KallyeRaidFramesOptionsFrameHideLegionNormals:SetChecked(KallyeRaidFramesOptions.HideLegionNormals);
	KallyeRaidFramesOptionsFrameHideLegionHeroics:SetChecked(KallyeRaidFramesOptions.HideLegionHeroics);
	KallyeRaidFramesOptionsFrameHideBFANormals:SetChecked(KallyeRaidFramesOptions.HideBFANormals);
	KallyeRaidFramesOptionsFrameHideBFAHeroics:SetChecked(KallyeRaidFramesOptions.HideBFAHeroics);
end



if (KallyeRaidFramesOptions.SoloRaidFrame) then

	CompactRaidFrameManager:Show()
	CompactRaidFrameManager.Hide = function() end
	CompactRaidFrameContainer:Show()
	CompactRaidFrameContainer.Hide = function() end

	-- Override this global function so that 'party' and nil values return 'raid'
	local getDAF = GetDisplayedAllyFrames
	function GetDisplayedAllyFrames()
	  local daf = getDAF()
	  if daf == 'party' or not daf then
		return 'raid'
	  else
		return daf
	  end
	end

	local CRFC_OnEvent = CompactRaidFrameContainer_OnEvent
	function CompactRaidFrameContainer_OnEvent(self, event, ...)
	  -- Call original to perform its default behavior, also helps future protect this hook
	  CRFC_OnEvent(self, event, ...)
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
end