local _, ns = ...

-- ! avoid conflict override
if ns.CONFLICT then return; end

local function updatePerLineLabel(slider, iconsPerLine, maxIcons)
    local l = ns.I18N;

    local shouldShowDefault = iconsPerLine >= maxIcons
    local currentLabel = gsub(slider:GetLabel(), l.DEFAULT, "")
    local newLabel = shouldShowDefault and (l.DEFAULT..currentLabel) or currentLabel

    slider:SetLabel(newLabel)
end

local function ManageUnitDebuffsOptions()
    local activeCheckbox = ns.FindControl("ActiveUnitDebuffs")
    local headingLabel = ns.FindControl("LabelMaxBuffs")
    local hideDisabledModules = ns.FindControl("HideDisabledModules")
    local isEnabled = ns.IsModuleEnabled(activeCheckbox, headingLabel, _G[ns.OPTIONS_NAME].ActiveUnitDebuffs, hideDisabledModules and hideDisabledModules:GetChecked())
        and (not ns.CONFLICT_RFA)

    local resetButton = ns.FindControl("Reset")
    local maxBuffsSlide = ns.FindControl("MaxBuffs")
    local buffsPerLineSlide = ns.FindControl("BuffsPerLine")
    local buffsOrientationDropdown = ns.FindControl("BuffsOrientation")
    local buffsPosXSlide = ns.FindControl("BuffsPosX")
    local buffsPosYSlide = ns.FindControl("BuffsPosY")
    local maxDebuffsSlide = ns.FindControl("MaxDebuffs")
    local debuffsPerLineSlide = ns.FindControl("DebuffsPerLine")
    local debuffsOrientationDropdown = ns.FindControl("DebuffsOrientation")
    local debuffsPosXSlide = ns.FindControl("DebuffsPosX")
    local debuffsPosYSlide = ns.FindControl("DebuffsPosY")

    ns.OptionsSiblingsEnable(_G[ns.OPTIONS_NAME], activeCheckbox, isEnabled, .2)
    ns.OptionsEnable(resetButton, false, .1)

    -- Spacing exists in modes B (RaidFrameAuras) and C (AuraContainer); filter and
    -- hide-tooltip only in mode C. Mode A (classic) supports none of them.
    local hasSpacing = ns.HAS_AURACONTAINER == true or ns.LoadRaidFramesAuras ~= nil
    local hasAuraContainer = ns.HAS_AURACONTAINER == true
    for _, controlName in ipairs({ "BuffsSpacingX", "BuffsSpacingY", "DebuffsSpacingX", "DebuffsSpacingY" }) do
        ns.OptionsEnable(ns.FindControl(controlName), isEnabled and hasSpacing, .2)
    end
    for _, controlName in ipairs({ "BuffsFilter", "BuffsHideTooltip", "BuffsExcluded", "DebuffsFilter", "DebuffsHideTooltip" }) do
        ns.OptionsEnable(ns.FindControl(controlName), isEnabled and hasAuraContainer, .2)
    end

    if not isEnabled then
        return
    end
    local currentOptions = {
        BuffsPerLine = buffsPerLineSlide:GetValue(),
        MaxBuffs = maxBuffsSlide:GetValue(),
        BuffsOrientation = buffsOrientationDropdown:GetValue(),
        BuffsPosX = buffsPosXSlide:GetValue(),
        BuffsPosY = buffsPosYSlide:GetValue(),
        DebuffsPerLine = debuffsPerLineSlide:GetValue(),
        MaxDebuffs = maxDebuffsSlide:GetValue(),
        DebuffsOrientation = debuffsOrientationDropdown:GetValue(),
        DebuffsPosX = debuffsPosXSlide:GetValue(),
        DebuffsPosY = debuffsPosYSlide:GetValue()
    }
    ns.OptionsEnable(resetButton, ns.HasCustomAuraLayout and ns.HasCustomAuraLayout(currentOptions) or false, .1)

    updatePerLineLabel(buffsPerLineSlide, currentOptions.BuffsPerLine, currentOptions.MaxBuffs)
    updatePerLineLabel(debuffsPerLineSlide, currentOptions.DebuffsPerLine, currentOptions.MaxDebuffs)
end
K_SHARED_UI.AddRefreshOptions(ManageUnitDebuffsOptions)