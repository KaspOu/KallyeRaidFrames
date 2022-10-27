--[[
	Hello to Kallye Raid Frames
	Last version: @project-version@ (@project-date-iso@)
]]

local isInit = false;
local isPlayer = false;


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
	AlphaNotInRange = 30,
	AlphaNotInCombat = 90,
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
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end -- END KRF_OnLoad

-- KRF_OnEvent
function KRF_OnEvent(self, event, ...)
	local arg1 = select(1, ...);
	if ((event == "UNIT_NAME_UPDATE" and arg1 == "player") or event == "PLAYER_ENTERING_WORLD") then
		isPlayer = true;
		-- self:UnRegisterEvent("PLAYER_ENTERING_WORLD");
	elseif (event == "ADDON_LOADED" and arg1 == KRF_ADDON_NAME) then
		isLoaded = true;
		self:UnregisterEvent("ADDON_LOADED");
		KRF_SetDefaultOptions(KRF_DefaultOptions);

		-- ! Hooks
		_G.hooksecurefunc("CompactUnitFrame_SetMaxBuffs", KRF_Hook_ManageBuffs);
		_G.hooksecurefunc("CompactUnitFrame_UpdateName", KRF_Hook_UpdateName);
		_G.hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", KRF_Hook_UpdateRoleIcon);
		_G.hooksecurefunc("CompactUnitFrame_UpdateHealth", KRF_Hook_UpdateHealth);
		_G.hooksecurefunc("CompactUnitFrame_UpdateHealPrediction", KRF_Hook_UpdateHealth);
		_G.hooksecurefunc("CompactUnitFrame_UpdateInRange", KRF_Hook_UpdateInRange);


		-- ! SoloRaid Frames (requires reload) !! deprecated !!
		-- if (KallyeRaidFramesOptions.SoloRaidFrame) then
		-- 	-- _G.ShouldShowRaidFrames = SoloRaid_ShouldShowRaidFrames;
		-- 	_G.IsInRaid = SoloRaid_ShouldShowRaidFrames;
		-- 	CompactRaidFrameContainer:ApplyToFrames("group", CompactRaidGroup_UpdateUnits);
		-- 	CompactRaidFrameContainer:TryUpdate();
		-- 	UpdateRaidAndPartyFrames();
		-- end

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
	InterfaceOptionsFrame_OpenToCategory(KRF_TITLE);
end

function SLASH_CLEAR_command(msgIn)
	SELECTED_CHAT_FRAME:Clear()
end


function OptionsWReloadValues()
	return tostring(KallyeRaidFramesOptions.SoloRaidFrame)
		..tostring(KallyeRaidFramesOptions.UpdateHealthColor)
		..tostring(KallyeRaidFramesOptions.BuffsScale)
		..tostring(KallyeRaidFramesOptions.DebuffsScale);
end

function SaveKRFOptions()
	local PreviousOptionsWReload = OptionsWReloadValues();
	-- Auto detect options controls and save them
	foreach(KRF_DefaultOptions,
		function (k, v)
			if (_G[KRF_OPTIONS..k] ~= nil) then
				local control = _G[KRF_OPTIONS..k];
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
		KRF_AddMsgWarn(KRF_OPTION_RELOAD_REQUIRED, true)
	end
end

function RefreshKRFOptions()
	-- Auto detect options controls and load them
	foreach(KRF_DefaultOptions,
		function (k, v)
			if (_G[KRF_OPTIONS..k] ~= nil) then
				local control = _G[KRF_OPTIONS..k];
				local value = KallyeRaidFramesOptions[k];
				if value == nil then
					value = v;
					KRF_AddMsgErr(format("Option not found (%s) loading default value...", k));
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