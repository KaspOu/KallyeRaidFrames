--[[
? Code inspired from :
?   LucyRaidFrames
?   LFRAdvanced !!
?	RaidFameMore
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
-- local FOLDER_NAME, private = ...


KRF_DefaultOptions = {
	Version = KRF_VERSION,
	BuffsScale = 0.75,
	DebuffsScale = 1.25,
	MaxBuffs = 3,
	HideDamageIcons = true,
	MoveRoleIcons = true,
	HideRealm = true,
	FriendsClassColor = true,
	Nameplates_FriendsAlphaInCombat = 1, -- Experimental !!
	Nameplates_FriendsAlphaNotInCombat = 1, -- Experimental !!

	ShowMsgNormal = true,
	ShowMsgErr = true,
	ShowMsgWarning = true,

	UpdateHealthColor = true,
	AlphaNotInRange = .3,
	BGColorLow =		{ r= 1, g= 0, b= 0, a = 1 },
	BGColorWarn = 		{ r = 1, g= 1, b= 0, a = .4 },
	BGColorOK =			{ r= .1, g= .1, b= .1, a = .3 },

	LimitLow = .20,
	LimitWarn = .50,
	LimitOk = .70,

	-- Revert the bar (sRaidFrames like)
	RevertBar = false,
	RevertBGColorLow =		{ r= 1, g= 0, b= 0, a = 1 },
	RevertBGColorWarn = { r = 1, g= 1, b= 0, a = .8 },
	RevertBGColorOK =			{ r= 0, g= 1, b= 0, a = 1 },

	DebugRandomHealth = false,		 -- Show random healths (debug)
	SoloRaidFrame = true,		 -- Show random healths (debug)
};
KRF_SetDefaultOptions(KRF_DefaultOptions);


function KRF_OnLoad(self)

	SlashCmdList["KRF"] = SLASH_KRF_command;
	SLASH_KRF1 = "/krf";
	SLASH_KRF2 = "/kallye";
	SLASH_KRF3 = "/kallyeraidframes";

	SlashCmdList["KallyeReloadUI"] = function(msg) ReloadUI(); end;
	SLASH_KallyeReloadUI1 = "/r";

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
	elseif(event == "ADDON_LOADED" and arg1 == KRF_ADDON_NAME) then
		isLoaded = true;
		self:UnregisterEvent("ADDON_LOADED");
		KRF_SetDefaultOptions(KRF_DefaultOptions);

		-- ! Hooks
		_G.hooksecurefunc("CompactUnitFrame_SetMaxBuffs", KRF_ManageBuffs);
		_G.hooksecurefunc("CompactUnitFrame_UpdateName", KRF_UpdateName);
		_G.hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", KRF_UpdateRoleIcon);
		_G.hooksecurefunc("CompactUnitFrame_UpdateHealth", KRF_UpdateHealth);
		_G.hooksecurefunc("CompactUnitFrame_UpdateInRange", KRF_UpdateInRange);


		-- ! SoloRaid Frames: need to reload
		if (KallyeRaidFramesOptions.SoloRaidFrame) then
			_G.CompactRaidFrameManager:Show()
			_G.CompactRaidFrameManager.Hide = function() end
			_G.CompactRaidFrameContainer:Show()
			_G.CompactRaidFrameContainer.Hide = function() end

			_G.GetDisplayedAllyFrames = SoloRaid_GetDisplayedAllyFrames;
			_G.CompactRaidFrameContainer_OnEvent = SoloRaid_CompactRaidFrameContainer_OnEvent;
		end

		-- ! Addon Loaded ^^
		KRF_AddMsg(KRF_MSG_LOADED);
	end
end -- END KRF_OnEvent

function SLASH_KRF_command(msgIn)
	if (not isLoaded) then
		KRF_AddMsgWarn(KRF_INIT_FAILED, true);
		return;
	end
	InterfaceOptionsFrame_OpenToCategory(KRF_TITLE);
	InterfaceOptionsFrame_OpenToCategory(KRF_TITLE);
end


function OptionsWReloadValues()
	return tostring(KallyeRaidFramesOptions.SoloRaidFrame)
		..tostring(KallyeRaidFramesOptions.UpdateHealthColor)
		..tostring(KallyeRaidFramesOptions.RevertBar);
end

function SaveKRFOptions()
	local PreviousOptionsWReload = OptionsWReloadValues();

	KallyeRaidFramesOptions.UpdateHealthColor = _G[KRF_OPTIONS.."UpdateHealthColor"]:GetChecked();
	KallyeRaidFramesOptions.RevertBar = _G[KRF_OPTIONS.."RevertBar"]:GetChecked();
	KallyeRaidFramesOptions.FriendsClassColor = _G[KRF_OPTIONS.."FriendsClassColor"]:GetChecked();
	KallyeRaidFramesOptions.BGColorLow = _G[KRF_OPTIONS.."BGColorLow"].GetColor();
	KallyeRaidFramesOptions.BGColorWarn = _G[KRF_OPTIONS.."BGColorWarn"].GetColor();
	KallyeRaidFramesOptions.BGColorOK = _G[KRF_OPTIONS.."BGColorOK"].GetColor();
	KallyeRaidFramesOptions.RevertBGColorLow = _G[KRF_OPTIONS.."RevertBGColorLow"].GetColor();
	KallyeRaidFramesOptions.RevertBGColorWarn = _G[KRF_OPTIONS.."RevertBGColorWarn"].GetColor();
	KallyeRaidFramesOptions.RevertBGColorOK = _G[KRF_OPTIONS.."RevertBGColorOK"].GetColor();

	if OptionsWReloadValues() ~= PreviousOptionsWReload then
		KRF_AddMsgWarn(KRF_OPTION_RELOAD_REQUIRED, true)
	end
end

function RefreshKRFOptions()
	_G[KRF_OPTIONS.."UpdateHealthColor"]:SetChecked(KallyeRaidFramesOptions.UpdateHealthColor);
	_G[KRF_OPTIONS.."RevertBar"]:SetChecked(KallyeRaidFramesOptions.RevertBar);
	_G[KRF_OPTIONS.."FriendsClassColor"]:SetChecked(KallyeRaidFramesOptions.FriendsClassColor);
	_G[KRF_OPTIONS.."BGColorLow"].SetColor(KallyeRaidFramesOptions.BGColorLow);
	_G[KRF_OPTIONS.."BGColorWarn"].SetColor(KallyeRaidFramesOptions.BGColorWarn);
	_G[KRF_OPTIONS.."BGColorOK"].SetColor(KallyeRaidFramesOptions.BGColorOK);
	_G[KRF_OPTIONS.."RevertBGColorLow"].SetColor(KallyeRaidFramesOptions.RevertBGColorLow);
	_G[KRF_OPTIONS.."RevertBGColorWarn"].SetColor(KallyeRaidFramesOptions.RevertBGColorWarn);
	_G[KRF_OPTIONS.."RevertBGColorOK"].SetColor(KallyeRaidFramesOptions.RevertBGColorOK);
end