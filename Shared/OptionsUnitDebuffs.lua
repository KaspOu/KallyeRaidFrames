local _, ns = ...

-- ! avoid conflict override
if ns.CONFLICT then return; end


local function ManageUnitDebuffsOptions()
    local activeCheckbox = ns.FindControl("ActiveUnitDebuffs")
    local headingLabel = ns.FindControl("LabelMaxBuffs")
    local hideDisabledModules = ns.FindControl("HideDisabledModules")
    local isEnabled = ns.IsModuleEnabled(activeCheckbox, headingLabel, _G[ns.OPTIONS_NAME].ActiveUnitDebuffs, hideDisabledModules and hideDisabledModules:GetChecked())

    ns.OptionsEnable(ns.FindControl("BuffsScale"), isEnabled,  .2)
    ns.OptionsEnable(ns.FindControl("MaxBuffs"), isEnabled, .2)
    ns.OptionsEnable(ns.FindControl("BuffsPerLine"), isEnabled, .2)
    ns.OptionsEnable(ns.FindControl("DebuffsScale"), isEnabled, .2)
    ns.OptionsEnable(ns.FindControl("BuffsVertical"), isEnabled, .2)
    ns.OptionsEnable(ns.FindControl("MaxDebuffs"), isEnabled, .2)
    ns.OptionsEnable(ns.FindControl("DebuffsPerLine"), isEnabled, .2)
    ns.OptionsEnable(ns.FindControl("DebuffsVertical"), isEnabled, .2)

end
K_SHARED_UI.AddRefreshOptions(ManageUnitDebuffsOptions)