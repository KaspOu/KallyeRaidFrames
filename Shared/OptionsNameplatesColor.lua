local _, ns = ...

-- ! avoid conflict override
if ns.CONFLICT then return; end

local function ManageNameplatesOptions()
    local activeCheckbox = ns.FindControl("ActiveNameplatesColor")
    local headingLabel = ns.FindControl("LabelNameplatesColor")
    local hideDisabledModules = ns.FindControl("HideDisabledModules")
    local isEnabled = ns.IsModuleEnabled(activeCheckbox, headingLabel, _G[ns.OPTIONS_NAME].ActiveNameplatesColor, hideDisabledModules and hideDisabledModules:GetChecked())

    local frameData = {
        ["FriendsNameplates_Txt_UseColor"] = { link = "FriendsNameplates_Txt_Color", classEnabled = true },
        ["FriendsNameplates_Bar_UseColor"] = { link = "FriendsNameplates_Bar_Color", classEnabled = not ns.HAS_colorNameBySelection },
        ["EnemiesNameplates_Txt_UseColor"] = { link = "EnemiesNameplates_Txt_Color", classEnabled = true },
        ["EnemiesNameplates_Bar_UseColor"] = { link = "EnemiesNameplates_Bar_Color", classEnabled = not ns.HAS_colorNameBySelection }
    }

    for frameName, data in pairs(frameData) do
        local dropDownWidget = ns.FindControl(frameName)
        local colorWidget = ns.FindControl(data.link)

        if not data.classEnabled then
            dropDownWidget:SetAttribute("disabled2", "true")
        end

        ns.OptionsEnable(dropDownWidget, isEnabled, .2)
        ns.OptionsSetShownAndEnable(colorWidget, isEnabled and dropDownWidget:GetValue() == "2",  isEnabled)
    end
end
K_SHARED_UI.AddRefreshOptions(ManageNameplatesOptions)
