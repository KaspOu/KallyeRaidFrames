--[[
? Code inspired from :
?   LucyRaidFrames
?   LFRAdvanced !!
? 	AzeriteTooltip (Ace)
?	GarrisonCommander-Broker (Ace)


? Help : https://github.com/fgprodigal/BlizzardInterfaceCode_zhTW/blob/master/Interface/FrameXML/CompactUnitFrame.lua
? https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/CompactUnitFrame.lua
? Depuis http://www.wowinterface.com/forums/showthread.php?t=56237
? Réf Blizzard http://wowwiki.wikia.com/wiki/Widget_API

? Debug frames: use /fstack

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

		-- BGColorOk =			{ r= .1, g= .1, b= .1, a = .3 },
		-- BGColorWarning = { r = 1, g= 1, b= 0, a = .4 },
		-- BGColorLow =		{ r= 1, g= 0, b= 0, a = 1 },
		BGColorOk =			{ r= 0, g= 1, b= 0, a = 1 },
		BGColorWarning = { r = 1, g= 1, b= 0, a = .8 },
		BGColorLow =		{ r= 1, g= 0, b= 0, a = 1 },

		LimitOk = .70,
		LimitWarning = .50,
		LimitLow = .20,

		RevertBar = true, -- Revert the bar (sRaidFrames like)
		DebugRandomHealth = false,		 -- Show random healths (debug)
		SoloRaidFrame = true,		 -- Show random healths (debug)
	}
end

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

hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
	if not KallyeRaidFramesOptions.RevertBar then
		UpdateHealth(frame)
	else
		UpdateHealth_Reverted(frame)
	end
end)


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


-- ## SoloRaid Frames: need to reload
if (KallyeRaidFramesOptions.SoloRaidFrame) then
	CompactRaidFrameManager:Show()
	CompactRaidFrameManager.Hide = function() end
	CompactRaidFrameContainer:Show()
	CompactRaidFrameContainer.Hide = function() end

	-- Override this global function so that 'party' and nil values return 'raid'
	local getDAF = GetDisplayedAllyFrames
	function GetDisplayedAllyFrames()
		local daf = getDAF()
		-- if daf == 'party' or not daf then
		-- return 'raid'
		if not daf then
		return 'party'
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



-- ## SoloRaid Frames: need to reload
if (KallyeRaidFramesOptions.SoloRaidFrame) then
	CompactRaidFrameManager:Show()
	CompactRaidFrameManager.Hide = function() end
	CompactRaidFrameContainer:Show()
	CompactRaidFrameContainer.Hide = function() end

	-- Override this global function so that 'party' and nil values return 'raid'
	local getDAF = GetDisplayedAllyFrames
	function GetDisplayedAllyFrames()
		local daf = getDAF()
		-- if daf == 'party' or not daf then
		-- return 'raid'
		if not daf then
		return 'party'
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