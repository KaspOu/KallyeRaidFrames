if not AddonCompartmentFrame then return end
local addonName, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end

local _compartmentRegistered = false
local function onOptionsChanged(self, options, changed)
    if (ns.SLASHCMD and options.AddonCompartmentFilter ~= false and not _compartmentRegistered) then
        -- AddonCompartmentFrame, Since DF (10)
        AddonCompartmentFrame:RegisterAddon({
            text = ns.TITLE,
            icon = C_AddOns.GetAddOnMetadata(addonName, "IconTexture"),
            notCheckable = true,
            func = SlashCmdList[ns.SLASHCMD],
        })
        _compartmentRegistered = true
    end
end


local function onInit(self, options)
    onOptionsChanged(self, options);
end
local module = ns.Module:new(onInit, "AddonCompartmentFilter");
module:SetOnOptionsChanged(onOptionsChanged);