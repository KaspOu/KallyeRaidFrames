local _, ns = ...

-- ! avoid conflict override
if ns.CONFLICT then return; end


local function ManageUnitDebuffsOptions()
    local activeCheckbox = ns.FindControl("ActiveUnitDebuffs")
    local headingLabel = ns.FindControl("LabelMaxBuffs")
    local hideDisabledModules = ns.FindControl("HideDisabledModules")
    local isEnabled = ns.IsModuleEnabled(activeCheckbox, headingLabel, _G[ns.OPTIONS_NAME].ActiveUnitDebuffs, hideDisabledModules and hideDisabledModules:GetChecked())

    ns.OptionsSiblingsEnable(_G[ns.OPTIONS_NAME], activeCheckbox, isEnabled, .2)

end
K_SHARED_UI.AddRefreshOptions(ManageUnitDebuffsOptions)