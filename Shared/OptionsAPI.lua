local _, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end

CONTROLTYPE_SLIDER = CONTROLTYPE_SLIDER or "slider"; -- removed since TWW (11)

function ns.SetGradientBg(frame, color)
    local texture = frame:CreateTexture()
    texture:SetAllPoints(true)
    texture:SetColorTexture(color.r, color.g, color.b, color.a)
    texture:SetGradient("VERTICAL", CreateColor(color.r, color.g, color.b, color.a), CreateColor(color.r*.5, color.g*.5, color.b*.5, color.a*.5))
end

--- SHARED API options management (default, bind, live changes)
--- ! Useable only after ADDON_LOADED
function ns.SetDefaultOptions(DefaultOptions, reset)
	if reset or _G[ns.OPTIONS_NAME] == nil then
		_G[ns.OPTIONS_NAME] = CopyTable(DefaultOptions)
	else
        if ns.RemoveOldOptions then
            ns.RemoveOldOptions(_G[ns.OPTIONS_NAME])
        end
		foreach(DefaultOptions,
			function (optionName, defaultValue)
				if _G[ns.OPTIONS_NAME][optionName] == nil then
					_G[ns.OPTIONS_NAME][optionName] = defaultValue;
				end
			end
		);
	end
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

--#region Control <-> value
--- Reads the value currently held by a control
--- @param control table The option control (checkbox, color, dropdown, slider)
--- @param previousValue any Current option value (used to detect checkbox options)
--- @return any value nil if the control type is not supported
function ns.ReadControlValue(control, previousValue)
    if control.type == "color" then
        return control:GetColor();
    elseif control.type == "dropdown" or control.type == CONTROLTYPE_SLIDER then
        return control:GetValue();
    elseif type(previousValue) == "boolean" and control.GetChecked then
        return control:GetChecked();
    end
end

--- Writes a value into a control (does NOT notify: see ns._loadingControls)
--- @return boolean written
function ns.WriteControlValue(control, value)
    if control.type == "color" then
        control:SetColor(value);
    elseif control.type == "dropdown" or control.type == CONTROLTYPE_SLIDER then
        control:SetValue(value);
    elseif type(value) == "boolean" then
        control:SetChecked(value);
    else
        return false;
    end
    return true;
end

local function valuesAreEqual(a, b)
    if type(a) == "table" and type(b) == "table" then
        return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a;
    end
    return a == b;
end

--#endregion
--#region Live options
-- called by K_SHARED_UI (can be called by another addon)
ns._optionByControl = {};
ns._pendingChanges = {};
ns._isFlushScheduled = false;

local reloadStateFunc = nil;
local reloadBaseline = nil;
local isReloadWarned = false;

--- Warns (once, at the equal -> different transition) when an option requiring a reload was modified
local function checkReloadRequired()
    if reloadStateFunc == nil then
        return;
    end
    local isDifferent = reloadStateFunc() ~= reloadBaseline;
    if isDifferent and not isReloadWarned then
        ns.AddMsgWarn(format("%s: %s", ns.TITLE, l.OPTION_RELOAD_REQUIRED or ""), true);
    end
    isReloadWarned = isDifferent;
end

function ns.ApplyFuncToRaidFrames(func, ...)
	for member = 1, 80 do -- Pets included
		local frame = _G["CompactRaidFrame"..member];
		if frame and frame:IsVisible() then
			func(frame, ...);
		end
	end
	for member = 1, 5 do
		local frame = _G["CompactPartyFrameMember"..member];
		if frame and frame:IsVisible() then
			func(frame, ...);
		end
		frame = _G["CompactPartyFramePet"..member];
		if frame and frame:IsVisible() then
			func(frame, ...);
		end
	end
	for raid = 1, 8 do
		if _G["CompactRaidGroup"..raid] ~= nil and _G["CompactRaidGroup"..raid]:IsVisible() then
			for member = 1, 5 do
				local frame = _G["CompactRaidGroup"..raid.."Member"..member];
				if frame == nil or not frame:IsVisible() then
					break;
				end
				func(frame, ...);
			end
		end
	end
end

--- Dispatches changed options: reload warning, core, modules, then UI state
--- @param changed table Set of modified option names ({ [name] = true })
function ns.NotifyOptionsChanged(changed)
    local options = _G[ns.OPTIONS_NAME];
    checkReloadRequired();
    if ns.OnCoreOptionsChanged then
        ns.OnCoreOptionsChanged(options, changed);
    end
    foreach(ns.MODULES,
        function(_, module)
            module:OnOptionsChanged(options, changed);
        end
    );
    K_SHARED_UI.RefreshOptions();
end

--- Applies all pending changes now (batched once per frame otherwise)
function ns.FlushOptionsChanges()
    ns._isFlushScheduled = false;
    if next(ns._pendingChanges) == nil then
        return;
    end
    local changed = ns._pendingChanges;
    ns._pendingChanges = {};
    ns.NotifyOptionsChanged(changed);
end

local function scheduleFlush(_NS)
    if _NS._isFlushScheduled then
        return;
    end
    _NS._isFlushScheduled = true;
    C_Timer.After(0, _NS.FlushOptionsChanges);
end

--- Called by widgets when the user modified a control: saves the option right away and applies it
--- @param _NS table The namespace of the addon ! method is shared between addons !
--- @param control table The modified control
function K_SHARED_UI.NotifyControlChanged(_NS, control)
    local optionName = _NS._optionByControl[control];
    if _NS._loadingControls or optionName == nil then
        if not _NS._loadingControls then
            K_SHARED_UI.RefreshOptions();
        end
        return;
    end
    local options = _G[_NS.OPTIONS_NAME];
    local value = _NS.ReadControlValue(control, options[optionName]);
    if value == nil or valuesAreEqual(value, options[optionName]) then
        return;
    end
    options[optionName] = value;
    _NS._pendingChanges[optionName] = true;
    scheduleFlush(_NS);
end

--- Sets an option from code: saved value + its control, without notification
function ns.SetOptionValue(optionName, value)
    _G[ns.OPTIONS_NAME][optionName] = value;
    local control = ns.FindControl(optionName);
    if control then
        local wasLoading = ns._loadingControls;
        ns._loadingControls = true;
        ns.WriteControlValue(control, value);
        ns._loadingControls = wasLoading;
    end
end

--- Binds every option control to its option: from now on, each UI change is applied immediately
--- ! Useable only after ADDON_LOADED, once
--- @param defaultOptions table Table containing the default options
--- @param ComputedReloadOptions function? Function that returns the options (requiring reload) state as a string
function ns.BindOptionControls(defaultOptions, ComputedReloadOptions)
    foreach(defaultOptions,
        function (optionName, defaultValue)
            local control = ns.FindControl(optionName);
            if control == nil then
                return;
            end
            ns._optionByControl[control] = optionName;
            if control.type == "checkbox" then
                control:HookScript("OnClick", function (ctrl) K_SHARED_UI.NotifyControlChanged(ns, ctrl) end);
            end
        end
    );
    reloadStateFunc = ComputedReloadOptions;
    reloadBaseline = ComputedReloadOptions and ComputedReloadOptions() or nil;
end
--#endregion

function K_SHARED_UI.AddRefreshOptions(func)
    K_SHARED_UI.optionsRefreshFuncs = K_SHARED_UI.optionsRefreshFuncs or {}
    table.insert(K_SHARED_UI.optionsRefreshFuncs, func)
end

--- Refreshes the UI state (visibility / enabled) of the options, from the live options
function K_SHARED_UI.RefreshOptions()
    foreach(K_SHARED_UI.optionsRefreshFuncs,
        function (_, func)
            func()
        end
    );
end

--- Refreshes UI controls based on the current options state (no notification)
--- ! Useable only after ADDON_LOADED
--- @param defaultOptions table Table containing the default options
--- @param showOptionsFrame boolean? Optional Whether to show the options frame
--- @param limitToOptionsNames table? Optional table containing the names of options to limit to
function ns.RefreshOptions(defaultOptions, showOptionsFrame, limitToOptionsNames)
    ns.optionsFrame:SetShown(showOptionsFrame);
    ns._loadingControls = true;
    -- Auto detect options controls and load them
    foreach(defaultOptions,
        function (optionName, defaultValue)
            if limitToOptionsNames ~= nil and not tContains(limitToOptionsNames, optionName) then
                return
            end
            local control = ns.FindControl(optionName);
            if (control ~= nil) then
                local value = _G[ns.OPTIONS_NAME][optionName];
                if value == nil then
                    value = defaultValue;
                    ns.AddMsgErr(format("Option not found ("..l.YLD.."%s|r), loading default value...", optionName));
                end;

                if not ns.WriteControlValue(control, value) then
                    ns.AddMsgDebug(format("Type non prevu pour %s - %s, type de valeur: %s", optionName, control.type or "unknown", type(value)));
                end
            end
        end
    );
    ns._loadingControls = false;
    K_SHARED_UI.RefreshOptions()
end


-- SHARED UI
function ns.OptionsEnable(FrameObject, isEnabled, disabledAlpha)
	if isEnabled then
		FrameObject:Enable();
		FrameObject:SetAlpha(1);
	else
		FrameObject:Disable();
		FrameObject:SetAlpha(disabledAlpha or .6);
	end
end
function ns.OptionsSetShownAndEnable(FrameObject, isShowned, isEnabled, disabledAlpha)
	FrameObject:SetShown(isShowned);
	if (isShowned) then
		ns.OptionsEnable(FrameObject, isEnabled, disabledAlpha);
	end
end

function ns.OptionsSiblingsEnable(options, sibling, isEnabled, alpha)
    local parent = sibling:GetParent()
    foreach(options,
        function (optionName, _)
            if parent[optionName] and parent[optionName] ~= sibling then
                ns.OptionsEnable(parent[optionName], isEnabled,  alpha)
            end
        end
    );
end

function ns.IsModuleEnabled(activeCheckbox, headingLabel, option, resize)
    if not activeCheckbox or not headingLabel then
        return true
    end
    if option == nil then
        activeCheckbox:Hide()
        K_SHARED_UI.HeadingWidget_SetPaddings(headingLabel, 5, 5)
        return true
    end
    local isEnabled = activeCheckbox:GetChecked()
    local parent = activeCheckbox:GetParent()
    if resize then
        parent._initialHeight = parent._initialHeight or parent:GetHeight()
        parent:SetClipsChildren(true)
        parent:SetHeight(isEnabled and parent._initialHeight or 40 , 5)
    elseif parent._initialHeight then
        parent:SetHeight(parent._initialHeight)
    end
    return isEnabled
end


--- Resets the specified options to their default values (refreshes UI and applies changes only for them)
--- @param optionNamesToReset table A list of option names to reset.
--- @param defaultOptions table  A table containing the default options.
--- @param optionsToForce table? An optional table containing options to force override
function ns.ResetOptions(optionNamesToReset, defaultOptions, optionsToForce)
	local changed = {}
	for _, optionName in ipairs(optionNamesToReset) do
		_G[ns.OPTIONS_NAME][optionName] = CopyTable({ defaultOptions[optionName] })[1]
	end
	if optionsToForce then
        foreach(optionsToForce,
            function (optionName, overrideValue)
				_G[ns.OPTIONS_NAME][optionName] = overrideValue
			    table.insert(optionNamesToReset, optionName) -- in case of we forgot
			end
		)
	end
	for _, optionName in ipairs(optionNamesToReset) do
		changed[optionName] = true
	end
	ns.RefreshOptions(defaultOptions, true, optionNamesToReset)
	ns.NotifyOptionsChanged(changed)
end
