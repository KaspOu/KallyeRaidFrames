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

		UpdateHealthColor = true,
		BGColorOk =			{ r= .1, g= .1, b= .1, a = .3 },
		BGColorWarning = { r = 1, g= 1, b= 0, a = .4 },
		BGColorLow =		{ r= 1, g= 0, b= 0, a = 1 },

		LimitOk = .70,
		LimitWarning = .50,
		LimitLow = .20,

		-- Revert the bar (sRaidFrames like)
		RevertBar = true,
		RevertBGColorOk =			{ r= 0, g= 1, b= 0, a = 1 },
		RevertBGColorWarning = { r = 1, g= 1, b= 0, a = .8 },
		RevertBGColorLow =		{ r= 1, g= 0, b= 0, a = 1 },

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

	SlashCmdList["KALLYE"] = SLASH_KALLYE_command;
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

function SLASH_KALLYE_command(msgIn)
	if (not isInit) then
		KALLYE_AddMsgWarn(KALLYE_INIT_FAILED, true);
		return;
	end
	InterfaceOptionsFrame_OpenToCategory(KALLYE_TITLE);
	InterfaceOptionsFrame_OpenToCategory(KALLYE_TITLE);
end


function OptionsWReloadValues()
	return tostring(KallyeRaidFramesOptions.SoloRaidFrame)..tostring(KallyeRaidFramesOptions.UpdateHealthColor)..tostring(KallyeRaidFramesOptions.RevertBar);
end
function SaveRSOptions()
	local PreviousOptionsWReload = OptionsWReloadValues();

	KallyeRaidFramesOptions.UpdateHealthColor = KRFOptionsFrameUpdateHealthColor:GetChecked();
	-- --KallyeRaidFramesOptions.ServerSideFiltering = KallyeRaidFramesOptionsFrameServerSideFiltering:GetChecked();
	-- KallyeRaidFramesOptions.ShowMemberInfo = KallyeRaidFramesOptionsFrameShowMemberInfo:GetChecked();
	-- --KallyeRaidFramesOptions.AutoRefresh = KallyeRaidFramesOptionsFrameAutoRefresh:GetChecked();
	-- --KallyeRaidFramesOptions.AutoRefreshInterval = KallyeRaidFramesOptionsFrameAutoRefreshInterval:GetCurrentValue();
	-- KallyeRaidFramesOptions.HideLegionNormals = KallyeRaidFramesOptionsFrameHideLegionNormals:GetChecked();
	-- KallyeRaidFramesOptions.HideLegionHeroics = KallyeRaidFramesOptionsFrameHideLegionHeroics:GetChecked();
	-- KallyeRaidFramesOptions.HideBFANormals = KallyeRaidFramesOptionsFrameHideBFANormals:GetChecked();
	-- KallyeRaidFramesOptions.HideBFAHeroics = KallyeRaidFramesOptionsFrameHideBFAHeroics:GetChecked();

	if OptionsWReloadValues() ~= PreviousOptionsWReload then
		KALLYE_AddMsgWarn(KALLYE_OPTION_RELOAD_REQUIRED, true)
	end
end

function RefreshRSOptions()
	KRFOptionsFrameUpdateHealthColor:SetChecked(KallyeRaidFramesOptions.UpdateHealthColor);
	--KallyeRaidFramesOptionsFrameServerSideFiltering:SetChecked(KallyeRaidFramesOptions.ServerSideFiltering);
	-- KallyeRaidFramesOptionsFrameShowMemberInfo:SetChecked(KallyeRaidFramesOptions.ShowMemberInfo);
	-- --KallyeRaidFramesOptionsFrameAutoRefresh:SetChecked(KallyeRaidFramesOptions.AutoRefresh);
	-- --KallyeRaidFramesOptionsFrameAutoRefreshInterval:SetValue(KallyeRaidFramesOptions.AutoRefreshInterval);
	-- KallyeRaidFramesOptionsFrameHideLegionNormals:SetChecked(KallyeRaidFramesOptions.HideLegionNormals);
	-- KallyeRaidFramesOptionsFrameHideLegionHeroics:SetChecked(KallyeRaidFramesOptions.HideLegionHeroics);
	-- KallyeRaidFramesOptionsFrameHideBFANormals:SetChecked(KallyeRaidFramesOptions.HideBFANormals);
	-- KallyeRaidFramesOptionsFrameHideBFAHeroics:SetChecked(KallyeRaidFramesOptions.HideBFAHeroics);
end

--[[
! Hooks
]]
hooksecurefunc("CompactUnitFrame_SetMaxBuffs", Kallye_ManageBuffs);
hooksecurefunc("CompactUnitFrame_UpdateName", Kallye_UpdateName);
hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", Kallye_UpdateRoleIcon);
hooksecurefunc("CompactUnitFrame_UpdateHealth", Kallye_UpdateHealth)


-- ## SoloRaid Frames: need to reload
if (KallyeRaidFramesOptions.SoloRaidFrame) then
	CompactRaidFrameManager:Show()
	CompactRaidFrameManager.Hide = function() end
	CompactRaidFrameContainer:Show()
	CompactRaidFrameContainer.Hide = function() end

	GetDisplayedAllyFrames = SoloRaid_GetDisplayedAllyFrames;
	CompactRaidFrameContainer_OnEvent = SoloRaid_CompactRaidFrameContainer_OnEvent;
end