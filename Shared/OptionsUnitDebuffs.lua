local _, ns = ...

-- ! avoid conflict override
if ns.CONFLICT then return; end

local DEFAULT_MAXBUFFS = ns.DEFAULT_MAXBUFFS or 3
local DEFAULT_MAXDEBUFFS = DEFAULT_MAXBUFFS

local function ManageUnitDebuffsOptions()
    local activeCheckbox = ns.FindControl("ActiveUnitDebuffs")
    local headingLabel = ns.FindControl("LabelMaxBuffs")
    local hideDisabledModules = ns.FindControl("HideDisabledModules")
    local isEnabled = ns.IsModuleEnabled(activeCheckbox, headingLabel, _G[ns.OPTIONS_NAME].ActiveUnitDebuffs, hideDisabledModules and hideDisabledModules:GetChecked())


    local useTaintMethodCheckbox = ns.FindControl("UseTaintMethod")
    local taintWarningText = ns.FindControl("TaintWarning")
    local flickerWarningText = ns.FindControl("FlickerWarning")
    local maxBuffsSlide = ns.FindControl("MaxBuffs")
    local buffsPerLineSlide = ns.FindControl("BuffsPerLine")
    local buffsVerticalCheckbox = ns.FindControl("BuffsVertical")
    local maxDebuffsSlide = ns.FindControl("MaxDebuffs")
    local debuffsPerLineSlide = ns.FindControl("DebuffsPerLine")
    local debuffsVerticalCheckbox = ns.FindControl("DebuffsVertical")

    ns.OptionsSiblingsEnable(_G[ns.OPTIONS_NAME], activeCheckbox, isEnabled, .2)
    ns.OptionsSetShownAndEnable(useTaintMethodCheckbox, not ns.USE_MAXBUFFS_TAINT_METHOD, false, .1)
    ns.OptionsSetShownAndEnable(taintWarningText, ns.USE_MAXBUFFS_TAINT_METHOD, false, .1)
    ns.OptionsEnable(flickerWarningText, false, .1)

    if not isEnabled then
        return
    end
    local currentOptions = {
        BuffsPerLine = buffsPerLineSlide:GetValue(),
        MaxBuffs = maxBuffsSlide:GetValue(),
        BuffsVertical = buffsVerticalCheckbox:GetChecked(),
        DebuffsPerLine = debuffsPerLineSlide:GetValue(),
        MaxDebuffs = maxDebuffsSlide:GetValue(),
        DebuffsVertical = debuffsVerticalCheckbox:GetChecked()
    }
    ns.OptionsSetShownAndEnable(useTaintMethodCheckbox, not ns.USE_MAXBUFFS_TAINT_METHOD, currentOptions.MaxBuffs ~= DEFAULT_MAXBUFFS or currentOptions.MaxDebuffs ~= DEFAULT_MAXDEBUFFS, .1)
    ns.OptionsSetShownAndEnable(taintWarningText, ns.USE_MAXBUFFS_TAINT_METHOD, currentOptions.MaxBuffs ~= DEFAULT_MAXBUFFS or currentOptions.MaxDebuffs ~= DEFAULT_MAXDEBUFFS, .1)
    ns.OptionsEnable(flickerWarningText, ns.isFlickerWarningShowed(currentOptions), .1)

end
K_SHARED_UI.AddRefreshOptions(ManageUnitDebuffsOptions)