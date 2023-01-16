--[[
	Hello to Kallye Raid Frames
	Last version: @project-version@ (@project-date-iso@)
]]

local isInit = false;


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
	FriendsClassColor = false,
	AlphaNotInRange = 55, -- 30
	AlphaNotInCombat = 100, -- 70
	SoloRaidFrame = false,		 -- Show solo raid (useful for testing)

	BuffsScale = 0.75,
	DebuffsScale = 1.25,
	MaxBuffs = 3,
	FriendsClassColor_Nameplates = true,

	ShowMsgNormal = true,
	ShowMsgWarning = true,
	ShowMsgError = true,
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
		_G.hooksecurefunc("CompactUnitFrame_UpdateName", KRF_Hook_UpdateName);
		_G.hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", KRF_Hook_UpdateRoleIcon);
		_G.hooksecurefunc("CompactUnitFrame_UpdateHealth", KRF_Hook_UpdateHealth);
		_G.hooksecurefunc("CompactUnitFrame_UpdateHealPrediction", KRF_Hook_UpdateHealth);
		if KallyeRaidFramesOptions.AlphaNotInRange ~= 55 or KallyeRaidFramesOptions.AlphaNotInCombat ~= 100 then
			_G.hooksecurefunc("CompactUnitFrame_UpdateInRange", KRF_Hook_UpdateInRange);
		end
		if KallyeRaidFramesOptions.BuffsScale ~= 1 or KallyeRaidFramesOptions.DebuffsScale ~= 1 then
			_G.hooksecurefunc("CompactUnitFrame_SetMaxBuffs", KRF_Hook_ManageBuffs);
		end

		-- ! SoloRaid Frames
		if (KallyeRaidFramesOptions.SoloRaidFrame) then
			_G.hooksecurefunc("CompactPartyFrame_UpdateVisibility", KRF_Hook_CompactPartyFrame_UpdateVisibility);
		end

		-- ! Addon Loaded ^^
		if (KallyeRaidFramesOptions.Version ~= KRF_DefaultOptions.Version) then
			KallyeRaidFramesOptions.Version = KRF_DefaultOptions.Version;
			KRF_AddMsg(KRF_WHATSNEW);
		end
	end
end -- END KRF_OnEvent

function SLASH_KRF_command(msgIn)
	if (not isLoaded) then
		KRF_AddMsgWarn(KRF_INIT_FAILED, true);
		return;
	end
	if msgIn == "test" then
		KRF_DebugFrames(true);
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
		..tostring(KallyeRaidFramesOptions.UpdateHealthColor)
		..tostring(KallyeRaidFramesOptions.BuffsScale)
		..tostring(KallyeRaidFramesOptions.DebuffsScale)
		..tostring(KallyeRaidFramesOptions.AlphaNotInRange ~= 55 or KallyeRaidFramesOptions.AlphaNotInCombat ~= 100);
end

function SaveKRFOptions()
	local FramePrefix = "KRFOptionsFrame_";
	local PreviousOptionsWReload = OptionsWReloadValues();
	-- Auto detect options controls and save them
	foreach(KRF_DefaultOptions,
		function (k, v)
			if (_G[FramePrefix..k] ~= nil) then
				local control = _G[FramePrefix..k];
				local previousValue = KallyeRaidFramesOptions[k] or v;

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
	if KallyeRaidFramesOptions.SoloRaidFrame and not EditModeManagerFrame:UseRaidStylePartyFrames() then
		KRF_AddMsgWarn(KRF_OPTION_SOLORAID_REQUIRE_USERAIDPARTYFRAMES, true);
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
	local FramePrefix = "KRFOptionsFrame_";
	foreach(KRF_DefaultOptions,
		function (k, v)
			if (_G[FramePrefix..k] ~= nil) then
				local control = _G[FramePrefix..k];
				local value = KallyeRaidFramesOptions[k];
				if value == nil then
					value = v;
					KRF_AddMsgErr(format("Option not found ("..YLD.."%s|r), loading default value...", k));
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
	local HealthOption, RevertBarOption = KRFOptionsFrame_UpdateHealthColor:GetChecked(), KRFOptionsFrame_RevertBar:GetChecked()
	KRF_OptionsEnable(KRFOptionsFrame_MaxBuffs, false, .2);

	KRF_OptionsEnable(KRFOptionsFrame_RevertBar, HealthOption)
	KRF_OptionsEnable(KRFOptionsFrame_LimitLow , HealthOption);
	KRF_OptionsEnable(KRFOptionsFrame_LimitWarn, HealthOption);
	KRF_OptionsEnable(KRFOptionsFrame_LimitOk  , HealthOption);

	KRF_OptionsSetShownAndEnable(KRFOptionsFrame_BGColorLow , not RevertBarOption, HealthOption);
	KRF_OptionsSetShownAndEnable(KRFOptionsFrame_BGColorWarn, not RevertBarOption, HealthOption);
	KRF_OptionsSetShownAndEnable(KRFOptionsFrame_BGColorOK  , not RevertBarOption, HealthOption);

	KRF_OptionsSetShownAndEnable(KRFOptionsFrame_RevertColorLow , RevertBarOption, HealthOption);
	KRF_OptionsSetShownAndEnable(KRFOptionsFrame_RevertColorWarn, RevertBarOption, HealthOption);
	KRF_OptionsSetShownAndEnable(KRFOptionsFrame_RevertColorOK  , RevertBarOption, HealthOption);
end