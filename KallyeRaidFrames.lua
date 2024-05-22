--[[
	Hello to Kallye Raid Frames
	Last version: @project-version@ (@project-date-iso@)
]]

local isInit = false;
local isLoaded = false;


KRF_DefaultOptions = {
	Version = KRF_VERSION,

	UpdateHealthColor = true,
	BGColorLow =		{ r= 1, g= 0, b= 0, a = 1 },
	BGColorWarn = 		{ r = 1, g= 1, b= 0, a = .52 },
	BGColorOK =			{ r= .1, g= .1, b= .1, a = .15 },
	RevertBar = false, -- Revert the bar (sRaidFrames like)
	RevertColorLow =		{ r= 1, g= 0, b= 0, a = 1 },
	RevertColorWarn = { r = 1, g= 1, b= 0, a = .8 },
	RevertColorOK =			{ r= 0, g= 1, b= 0, a = 1 },
	LimitLow = 25,
	LimitWarn = 50,
	LimitOk = 75,

	MoveRoleIcons = true,
	HideDamageIcons = true,
	HideRealm = true,
	IconOnDeath = true,
	FriendsClassColor = false,
	AlphaNotInRange = 55, -- 30
	AlphaNotInCombat = 100, -- 70
	SoloRaidFrame = false,		 -- Show solo raid (useful for testing)

	BuffsScale = 0.75,
	DebuffsScale = 1.25,
	MaxBuffs = 3,
	FriendsClassColor_Nameplates = true,
	EnemiesClassColor_Nameplates = false,

	ShowMsgNormal = true,
	ShowMsgWarning = true,
	ShowMsgError = true,

	DebugMode = false,
};
KRF_SetDefaultOptions(KRF_DefaultOptions);


function KRF_OnLoad(self)

	SlashCmdList["KRF"] = SLASH_KRF_command;
	SLASH_KRF1 = "/krf";
	SLASH_KRF2 = "/kallye";
	SLASH_KRF3 = "/kallyeraidframes";

	SlashCmdList["CLEAR"] = SLASH_CLEAR_command;
	SLASH_CLEAR1 = "/clear";

	if (isInit or InCombatLockdown()) then return; end

	isInit = true;
	self:SetScript("OnEvent",
		function(self, event, ...)
			KRF_OnEvent(self, event, ...);
		end
	);
	self:RegisterEvent("ADDON_LOADED");
end -- END KRF_OnLoad

-- KRF_OnEvent
function KRF_OnEvent(self, event, ...)
	local arg1 = select(1, ...);
	if (event == "ADDON_LOADED" and arg1 == KRF_ADDON_NAME) then
		self:UnregisterEvent("ADDON_LOADED");
		isLoaded = true;

		KRF_SetDefaultOptions(KRF_DefaultOptions);

		-- ! Hooks
		hooksecurefunc("CompactUnitFrame_UpdateName", KRF_Hook_UpdateName);
		hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", KRF_Hook_UpdateRoleIcon);
		hooksecurefunc("CompactUnitFrame_UpdateHealthColor", KRF_Hook_UpdateHealth);
		if (CompactUnitFrame_UpdateHealPrediction) then
			-- Since DragonFlight (10)
			hooksecurefunc("CompactUnitFrame_UpdateHealPrediction", KRF_Hook_UpdateHealth);
		else
			-- Classic
			hooksecurefunc("CompactUnitFrame_UpdateHealth", KRF_Hook_UpdateHealth);
		end
		
		if KallyeRaidFramesOptions.AlphaNotInRange ~= 55 or KallyeRaidFramesOptions.AlphaNotInCombat ~= 100 then
			-- DefaultCompactUnitFrameOptions.fadeOutOfRange = false; -- side effects :/
			hooksecurefunc("CompactUnitFrame_UpdateInRange", KRF_Hook_UpdateInRange);
			hooksecurefunc("CompactUnitFrame_UpdateHealthColor", KRF_Hook_UpdateInRange);
		end
		if KallyeRaidFramesOptions.BuffsScale ~= 1 or KallyeRaidFramesOptions.DebuffsScale ~= 1 then
			hooksecurefunc("CompactUnitFrame_SetMaxBuffs", KRF_Hook_ManageBuffs);
		end

		-- ! SoloRaid Frames
		if (KallyeRaidFramesOptions.SoloRaidFrame) then
			if (EditModeManagerFrame.UseRaidStylePartyFrames) then
				-- Edit Mode - Since DragonFlight (10)
				hooksecurefunc(CompactPartyFrame, "UpdateVisibility", KRF_Hook_CompactPartyFrame_UpdateVisibility);
			else
				-- Classic
				CompactRaidFrameManager:Show()
				CompactRaidFrameManager.Hide = function() end
				CompactRaidFrameContainer:Show()
				CompactRaidFrameContainer.Hide = function() end

				GetDisplayedAllyFrames = KRF_SoloRaid_GetDisplayedAllyFrames;
				CompactRaidFrameContainer_OnEvent = KRF_SoloRaid_CompactRaidFrameContainer_OnEvent;
			end
		end

		-- ! Addon Loaded ^^
		if (KallyeRaidFramesOptions.Version ~= KRF_DefaultOptions.Version) then
			KallyeRaidFramesOptions.Version = KRF_DefaultOptions.Version;
			if (KRF_WHATSNEW ~= "") then
				KRF_AddMsg(KRF_WHATSNEW);
			end
		end
		if (KallyeRaidFramesOptions.DebugMode) then
			SLASH_KRF_command()
		end
	end
end -- END KRF_OnEvent

function SLASH_KRF_command(msgIn)
	if (not isLoaded) then
		KRF_AddMsgWarn(KRF_INIT_FAILED, true);
		return;
	end
	if msgIn == "new" then
		KRF_AddMsg(KRF_WHATSNEW);
	elseif msgIn == "test" then
		KRF_DebugFrames();
	elseif msgIn == "edit" then
		KRF_ShowEditMode("PartyFrame");
	elseif msgIn == "debug" then
		KallyeRaidFramesOptions.DebugMode = not KallyeRaidFramesOptions.DebugMode;
		KRF_AddMsgWarn("Debug mode: "..(KallyeRaidFramesOptions.DebugMode and KRF_Globals.GR.."true" or KRF_Globals.RD.."false"), true);
		SLASH_KRF_command();
	else
		if Settings then
			Settings.OpenToCategory(KRF_TITLE);
		else
			InterfaceOptionsFrame_OpenToCategory(KRF_TITLE);
		end
	end
end

function SLASH_CLEAR_command()
	SELECTED_CHAT_FRAME:Clear()
end


function OptionsWReloadValues()
	return tostring(KallyeRaidFramesOptions.SoloRaidFrame)
		..tostring(KallyeRaidFramesOptions.RevertBar)
		..tostring(KallyeRaidFramesOptions.UpdateHealthColor)
		..tostring(KallyeRaidFramesOptions.BuffsScale)
		..tostring(KallyeRaidFramesOptions.DebuffsScale)
		..tostring(KallyeRaidFramesOptions.AlphaNotInRange ~= 55 or KallyeRaidFramesOptions.AlphaNotInCombat ~= 100);
end

function SaveKRFOptions()
	local PreviousOptionsWReload = OptionsWReloadValues();
	-- Auto detect options controls and save them
	foreach(KRF_DefaultOptions,
		function (k, v)
			if (KRFOptionsFrame[k] ~= nil) then
				local control = KRFOptionsFrame[k];
				local previousValue = KallyeRaidFramesOptions[k] or v;
				local value = nil;

				if control.type == "color" then
					value = control.GetColor(control);
				elseif control.type == CONTROLTYPE_SLIDER then
					value = control:GetValue();
				elseif type(previousValue) == "boolean" then
					value = control:GetChecked();
				end
				if value == nil then
					KRF_AddMsgErr(format("Incorrect field value, loading default value for %s...", k));
					value = v;
				end;
				KallyeRaidFramesOptions[k] = value;
			end
		end
	);
	-- Secure limits (low <= warn <= ok)
	if KallyeRaidFramesOptions.LimitWarn < KallyeRaidFramesOptions.LimitLow then
		KallyeRaidFramesOptions.LimitWarn = KallyeRaidFramesOptions.LimitLow
	end
	if KallyeRaidFramesOptions.LimitOk < KallyeRaidFramesOptions.LimitWarn then
		KallyeRaidFramesOptions.LimitOk = KallyeRaidFramesOptions.LimitWarn
	end
	-- Reset party health as soon as possible
	KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, false);

	if OptionsWReloadValues() ~= PreviousOptionsWReload then
		KRF_AddMsgWarn(KRF_OPTION_RELOAD_REQUIRED, true);
	end
	-- Edit Mode - Since DragonFlight (10)
	if EditModeManagerFrame.UseRaidStylePartyFrames and KallyeRaidFramesOptions.SoloRaidFrame and not EditModeManagerFrame:UseRaidStylePartyFrames() then
		KRF_AddMsgWarn(KRF_OPTION_SOLORAID_TOOLTIP, true);
	end
	if KRFOptionsFrame ~= nil and KRFOptionsFrame.HandleVis ~= nil then
		KRFOptionsFrame:Hide();
	end
end

function RefreshKRFOptions()
	if KRFOptionsFrame ~= nil then
		KRFOptionsFrame:Show();
		KRFOptionsFrame.HandleVis = true;
	end
	-- Auto detect options controls and load them
	foreach(KRF_DefaultOptions,
		function (k, v)
			if (KRFOptionsFrame[k] ~= nil) then
				local control = KRFOptionsFrame[k];
				local value = KallyeRaidFramesOptions[k];
				if value == nil then
					value = v;
					KRF_AddMsgErr(format("Option not found ("..KRF_Globals.YLD.."%s|r), loading default value...", k));
				end;

				if control.type == "color" then
					control.SetColor(control, value);
				elseif control.type == CONTROLTYPE_SLIDER then
					control:SetValue(value);
				elseif type(value) == "boolean" then
					control:SetChecked(value);
				end
			end
		end
	);
end

function ManageKRFOptionsVisibility()
	local HealthOption,
		RevertBarOption,
		NameplatesOption
			= 
			KRFOptionsFrame.UpdateHealthColor:GetChecked(),
			KRFOptionsFrame.RevertBar:GetChecked(),
			KRFOptionsFrame.FriendsClassColor_Nameplates:GetChecked();

	if (EditModeManagerFrame.UseRaidStylePartyFrames) then
		-- Edit Mode - Since DragonFlight (10)		
		KRFOptionsFrame.EditMode:SetAlpha(EditModeManagerFrame:UseRaidStylePartyFrames() and .4 or 1);
	else
		KRF_OptionsEnable(KRFOptionsFrame.EditMode, false, .2);
	end

	KRF_OptionsEnable(KRFOptionsFrame.MaxBuffs, false, .2);

	KRF_OptionsEnable(KRFOptionsFrame.RevertBar, HealthOption)
	KRF_OptionsEnable(KRFOptionsFrame.LimitLow , HealthOption);
	KRF_OptionsEnable(KRFOptionsFrame.LimitWarn, HealthOption);
	KRF_OptionsEnable(KRFOptionsFrame.LimitOk  , HealthOption);

	KRF_OptionsSetShownAndEnable(KRFOptionsFrame.BGColorLow , not RevertBarOption, HealthOption);
	KRF_OptionsSetShownAndEnable(KRFOptionsFrame.BGColorWarn, not RevertBarOption, HealthOption);
	KRF_OptionsSetShownAndEnable(KRFOptionsFrame.BGColorOK  , not RevertBarOption, HealthOption);

	KRF_OptionsSetShownAndEnable(KRFOptionsFrame.RevertColorLow , RevertBarOption, HealthOption);
	KRF_OptionsSetShownAndEnable(KRFOptionsFrame.RevertColorWarn, RevertBarOption, HealthOption);
	KRF_OptionsSetShownAndEnable(KRFOptionsFrame.RevertColorOK  , RevertBarOption, HealthOption);

	KRF_OptionsEnable(KRFOptionsFrame.EnemiesClassColor_Nameplates, NameplatesOption);
end