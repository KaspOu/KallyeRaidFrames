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
    local maxBuffsSlide = ns.FindControl("MaxBuffs")
    local maxDebuffsSlide = ns.FindControl("MaxDebuffs")

    ns.OptionsSiblingsEnable(_G[ns.OPTIONS_NAME], activeCheckbox, isEnabled, .2)
    ns.OptionsEnable(useTaintMethodCheckbox, maxBuffsSlide:GetValue() ~= DEFAULT_MAXBUFFS or maxDebuffsSlide:GetValue() ~= DEFAULT_MAXDEBUFFS, .4)

end
K_SHARED_UI.AddRefreshOptions(ManageUnitDebuffsOptions)