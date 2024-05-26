--[[
	Hello to Kallye Raid Frames
	Last version: @project-version@ (@project-date-iso@)
]]
local _, ns = ...
local l = ns.I18N;
local isInit = false;
local isLoaded = false;


local KRF_DefaultOptions = {
	Version = ns.VERSION,

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
	FriendsNameplates_Txt_UseColor = "1",
	FriendsNameplates_Txt_Color = { r= .235, g= .941, b= 1, a = 1 },
	FriendsNameplates_Bar_UseColor = ns.HAS_colorNameBySelection and "0" or "1",
	FriendsNameplates_Bar_Color = { r= .235, g= .941, b= 1, a = 1 },
	
	EnemiesNameplates_Txt_UseColor = "1",
	EnemiesNameplates_Txt_Color = { r= .87, g= 0, b= .05, a = 1 },
	EnemiesNameplates_Bar_UseColor = "0",
	EnemiesNameplates_Bar_Color = { r= .87, g= 0, b= .05, a = 1 },

	ShowMsgNormal = true,
	ShowMsgWarning = true,
	ShowMsgError = false,

	DebugMode = false,
};
ns.SetDefaultOptions(KRF_DefaultOptions);



local function SLASH_KRF_command(msgIn)
	if (not isLoaded) then
		ns.AddMsgWarn(l.INIT_FAILED, true);
		return;
	end
	if msgIn == "new" then
		ns.AddMsg(l.WHATSNEW);
	elseif msgIn == "test" then
		ns.DebugFrames();
	elseif msgIn == "edit" then
		ns.ShowEditMode("PartyFrame");
	elseif msgIn == "debug" then
		KallyeRaidFramesOptions.DebugMode = not KallyeRaidFramesOptions.DebugMode;
		ns.AddMsgWarn("Debug mode: "..(KallyeRaidFramesOptions.DebugMode and l.GR.."true" or l.RD.."false"), true);
		SLASH_KRF_command();
	elseif msgIn == "reset" then
		StaticPopup_Show(ns.ADDON_NAME.."_CONFIRM_RESET")
	else
		if Settings then
			Settings.OpenToCategory(ns.TITLE);
		else
			InterfaceOptionsFrame_OpenToCategory(ns.TITLE);
		end
	end
end

local function SLASH_CLEAR_command()
	SELECTED_CHAT_FRAME:Clear()
end

-- KRF_OnEvent
local function OnEvent(self, event, ...)
	local arg1 = select(1, ...);
	if (event == "ADDON_LOADED" and arg1 == ns.ADDON_NAME) then
		self:UnregisterEvent("ADDON_LOADED");
		isLoaded = true;

		ns.SetDefaultOptions(KRF_DefaultOptions);

		-- ! Hooks
		hooksecurefunc("CompactUnitFrame_UpdateName", ns.Hook_UpdateName);
		hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", ns.Hook_UpdateRoleIcon);
		hooksecurefunc("CompactUnitFrame_UpdateHealthColor", ns.Hook_UpdateHealth);
		if (CompactUnitFrame_UpdateHealPrediction) then
			-- Since DragonFlight (10)
			hooksecurefunc("CompactUnitFrame_UpdateHealPrediction", ns.Hook_UpdateHealth);
		else
			-- Classic
			hooksecurefunc("CompactUnitFrame_UpdateHealth", ns.Hook_UpdateHealth);
		end
		
		if KallyeRaidFramesOptions.AlphaNotInRange ~= 55 or KallyeRaidFramesOptions.AlphaNotInCombat ~= 100 then
			-- DefaultCompactUnitFrameOptions.fadeOutOfRange = false; -- side effects :/
			hooksecurefunc("CompactUnitFrame_UpdateInRange", ns.Hook_UpdateInRange);
			hooksecurefunc("CompactUnitFrame_UpdateHealthColor", ns.Hook_UpdateInRange);
		end
		if KallyeRaidFramesOptions.BuffsScale ~= 1 or KallyeRaidFramesOptions.DebuffsScale ~= 1 then
			hooksecurefunc("CompactUnitFrame_SetMaxBuffs", ns.Hook_ManageBuffs);
		end

		-- Load Modules
		foreach(ns.MODULES,
			function(k, v)
				ns.MODULES[k]:Init(KallyeRaidFramesOptions);
			end
        );

		-- ! Addon Loaded ^^
		if (KallyeRaidFramesOptions.Version ~= KRF_DefaultOptions.Version) then
			KallyeRaidFramesOptions.Version = KRF_DefaultOptions.Version;
			if (l.WHATSNEW ~= "") then
				ns.AddMsg(l.WHATSNEW);
			end
		end
		if (KallyeRaidFramesOptions.DebugMode) then
			SLASH_KRF_command()
		end
	end
end -- END KRF_OnEvent

local function InitAddon(frame)

	SlashCmdList["KRF"] = SLASH_KRF_command;
	SLASH_KRF1 = "/krf";
	SLASH_KRF2 = "/kallye";
	SLASH_KRF3 = "/kallyeraidframes";

	SlashCmdList["CLEAR"] = SLASH_CLEAR_command;
	SLASH_CLEAR1 = "/clear";

	if (isInit or InCombatLockdown()) then return; end

	isInit = true;
	frame:SetScript("OnEvent",
		function(frame, event, ...)
			OnEvent(frame, event, ...);
		end
	);
	frame:RegisterEvent("ADDON_LOADED");
end -- END KRF_OnLoad

do
	local eventsFrame = CreateFrame("Frame", nil, UIParent)
	InitAddon(eventsFrame);
end


local function OptionsWReloadValues()
	return tostring(KallyeRaidFramesOptions.SoloRaidFrame)
		..tostring(KallyeRaidFramesOptions.RevertBar)
		..tostring(KallyeRaidFramesOptions.UpdateHealthColor)
		..tostring(KallyeRaidFramesOptions.BuffsScale)
		..tostring(KallyeRaidFramesOptions.DebuffsScale)
		..tostring(KallyeRaidFramesOptions.AlphaNotInRange ~= 55 or KallyeRaidFramesOptions.AlphaNotInCombat ~= 100);
end

local function SaveKRFOptions()
	local PreviousOptionsWReload = OptionsWReloadValues();
	-- Auto detect options controls and save them
	foreach(KRF_DefaultOptions,
		function (k, v)
			local optionsObject = ns.FindControl(k);
			if (optionsObject ~= nil) then
				local control = optionsObject;
				local previousValue = KallyeRaidFramesOptions[k] or v;
				local value = nil;

				if control.type == "color" then
					value = control:GetColor();
				elseif control.type == "dropdown" then
					value = control:GetValue();
				elseif control.type == CONTROLTYPE_SLIDER then
					value = control:GetValue();
				elseif type(previousValue) == "boolean" then
					value = control:GetChecked();
				end
				if value == nil then
					ns.AddMsgErr(format("Incorrect field value, loading default value for %s...", k));
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
	ns.ApplyFuncToRaidFrames(ns.RaidFrames_ResetHealth, false);

	if OptionsWReloadValues() ~= PreviousOptionsWReload then
		ns.AddMsgWarn(l.OPTION_RELOAD_REQUIRED, true);
	end
	
	-- OnSave: Modules
	foreach(ns.MODULES,
		function(k, v)
			ns.MODULES[k]:OnSaveOptions(KallyeRaidFramesOptions);
		end
	);
	if ns.optionsFrame ~= nil and ns.optionsFrame.HandleVis ~= nil then
		ns.optionsFrame:Hide();
	end
end

local function RefreshKRFOptions()
	if ns.optionsFrame ~= nil then
		ns.optionsFrame:Show();
		ns.optionsFrame.HandleVis = true;
	end
	-- Auto detect options controls and load them
	foreach(KRF_DefaultOptions,
		function (k, v)
			local optionsObject = ns.FindControl(k);
			if (optionsObject ~= nil) then
				local control = optionsObject;
				local value = KallyeRaidFramesOptions[k];
				if value == nil then
					value = v;
					ns.AddMsgErr(format("Option not found ("..l.YLD.."%s|r), loading default value...", k));
				end;

				if control.type == "color" then
					control:SetColor(value);
				elseif control.type == "dropdown" then
					control:SetValue(value);
				elseif control.type == CONTROLTYPE_SLIDER then
					control:SetValue(value);
				elseif type(value) == "boolean" then
					control:SetChecked(value);
				else
					ns.AddMsgDebug(format("Type non prevu pour %s - %s, type de valeur: %s", k, control.type or "unknown", type(value)));
				end
			end
		end
	);
end

function KRFUI.ManageOptionsVisibility()
	local HealthOption,
		RevertBarOption
			= 
			ns.optionsFrame.UpdateHealthColor:GetChecked(),
			ns.optionsFrame.RevertBar:GetChecked();

	if (EditModeManagerFrame.UseRaidStylePartyFrames) then
		-- Edit Mode - Since DragonFlight (10)		
		ns.optionsFrame.EditMode:SetAlpha(EditModeManagerFrame:UseRaidStylePartyFrames() and .4 or 1);
	else
		ns.OptionsEnable(ns.optionsFrame.EditMode, false, .2);
		ns.OptionsEnable(ns.optionsFrame.BlizzFriendsClassColor, false, .2);
	end

	ns.OptionsEnable(ns.optionsFrame.MaxBuffs, false, .2);

	ns.OptionsEnable(ns.optionsFrame.RevertBar, HealthOption)
	ns.OptionsEnable(ns.optionsFrame.LimitLow , HealthOption);
	ns.OptionsEnable(ns.optionsFrame.LimitWarn, HealthOption);
	ns.OptionsEnable(ns.optionsFrame.LimitOk  , HealthOption);

	ns.OptionsSetShownAndEnable(ns.optionsFrame.BGColorLow , not RevertBarOption, HealthOption);
	ns.OptionsSetShownAndEnable(ns.optionsFrame.BGColorWarn, not RevertBarOption, HealthOption);
	ns.OptionsSetShownAndEnable(ns.optionsFrame.BGColorOK  , not RevertBarOption, HealthOption);

	ns.OptionsSetShownAndEnable(ns.optionsFrame.RevertColorLow , RevertBarOption, HealthOption);
	ns.OptionsSetShownAndEnable(ns.optionsFrame.RevertColorWarn, RevertBarOption, HealthOption);
	ns.OptionsSetShownAndEnable(ns.optionsFrame.RevertColorOK  , RevertBarOption, HealthOption);
end

function ns.FindControl(ControlName)
	if ns.optionsFrame[ControlName] then
		return ns.optionsFrame[ControlName];
	else
		local i = 1
		while(ns.optionsFrame["Options"..i])
		do
			if (ns.optionsFrame["Options"..i][ControlName]) then
				return ns.optionsFrame["Options"..i][ControlName];
			end
			i=i+1;
		end
	end
end

StaticPopupDialogs[ns.ADDON_NAME.."_CONFIRM_RESET"] = {
	showAlert = true,
	text = CONFIRM_RESET_SETTINGS,
	button1 = ALL_SETTINGS,
	-- button3 = CURRENT_SETTINGS,
	button2 = CANCEL,
	OnAccept = function()												
		ns.SetDefaultOptions(KRF_DefaultOptions, true);
		ReloadUI();
	end,
	-- OnAlt  = function()	end,
	timeout = STATICPOPUP_TIMEOUT,
	timeoutInformationalOnly = false,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint
};

function KRFUI.ConfirmReset()
	StaticPopup_Show(ns.ADDON_NAME.."_CONFIRM_RESET")
end
function KRFUI.DebugFrames()
	ns.DebugFrames();
end
function KRFUI.ShowEditMode(window)
	ns.ShowEditMode(window);
end

function KRFUI.OptionsContainer_OnLoad(self, scrollFrame, optionsFrame)
	ns.containerFrame = self;
	ns.scrollFrame = scrollFrame;
	ns.optionsFrame = optionsFrame;
	RefreshKRFOptions();
	self.name = ns.TITLE;
	self.okay = SaveKRFOptions;
	self.refresh = RefreshKRFOptions;
	InterfaceOptions_AddCategory(self);
	if (ns.scrollFrame ~= nil) then
		local BACKDROP_TOOLTIP = {
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\FriendsFrame\\UI-Toast-Border",
			tile = true,
			tileSize = 8,
			edge = true,
			edgeSize = 8,
			insets = {left = 2, right = 2, top = 2, bottom = 2},
		};

		if (BackdropTemplateMixin) then Mixin(ns.scrollFrame, BackdropTemplateMixin) end
		ns.scrollFrame:SetBackdrop(BACKDROP_TOOLTIP)
	end
	if ns.optionsFrame ~= nil and ns.optionsFrame.HandleVis ~= nil then
		ns.optionsFrame:Hide();
	end

	-- Localize FontStrings
	foreach(self,
		function (k, v)
			local child = self[k];
			if type(child) == "table" and child:GetObjectType() == "FontString" then
				child:SetText(l[child:GetText()]);
			end
		end
	);
end
