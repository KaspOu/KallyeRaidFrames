local _, ns = ...

-- ! avoid conflict override
if ns.CONFLICT then return; end


function K_SHARED_UI.SafeUnitDebuffs(self)
    local parent = self:GetParent()
    parent.BuffsScale:SetValue(1)
    parent.MaxBuffs:SetValue(3)
    parent.BuffsPerLine:SetValue(9)
    parent.DebuffsScale:SetValue(1)
    parent.MaxDebuffs:SetValue(3)
    parent.DebuffsPerLine:SetValue(9)
end
local function ManageUnitDebuffsOptions()
    -- ns.OptionsEnable(ns.FindControl("MaxBuffs"), false,  .2)
end
K_SHARED_UI.AddRefreshOptions(ManageUnitDebuffsOptions)