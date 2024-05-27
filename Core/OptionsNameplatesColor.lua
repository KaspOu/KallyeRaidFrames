local _, ns = ...
local l = ns.I18N;
function KRFUI.ManageNameplatesOptions()
	if ns.CONFLICT then
		return;
	end
    local frameNames = {
        ["FriendsNameplates_Txt_UseColor"] = { "FriendsNameplates_Txt_Color", true },
        ["FriendsNameplates_Bar_UseColor"] = { "FriendsNameplates_Bar_Color", not ns.HAS_colorNameBySelection },
        ["EnemiesNameplates_Txt_UseColor"] = { "EnemiesNameplates_Txt_Color", true },
        ["EnemiesNameplates_Bar_UseColor"] = { "EnemiesNameplates_Bar_Color", not ns.HAS_colorNameBySelection }
    }

    for frameName, details in pairs(frameNames) do
        local dropDownWidget = ns.FindControl(frameName)
        local colorWidget = ns.FindControl(details[1])

        ns.OptionsEnable(dropDownWidget, details[2],  0.5)
        ns.OptionsSetShownAndEnable(colorWidget, dropDownWidget:GetValue() == "2",  0.1)
    end
end
