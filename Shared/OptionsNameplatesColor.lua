local _, ns = ...

-- ! avoid conflict override
if ns.CONFLICT then return; end


local function ManageNameplatesOptions()

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

        ns.OptionsSetShownAndEnable(colorWidget, dropDownWidget:GetValue() == "2",  0.1)
    end
end
K_SHARED_UI.AddRefreshOptions(ManageNameplatesOptions)
