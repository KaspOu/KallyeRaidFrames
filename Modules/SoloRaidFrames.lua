local _, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end

local Hook_CompactPartyFrame_UpdateVisibility = function() end;
local SoloRaid_GetDisplayedAllyFrames = function() end;
local SoloRaid_CompactRaidFrameContainer_OnEvent = function() end;

if (EditModeManagerFrame.UseRaidStylePartyFrames) then
    --[[
    ! Solo Raid Frames main, since DragonFlight (10)
    - Show Raid Frames if solo
    ]]
    Hook_CompactPartyFrame_UpdateVisibility = function()
        if (not IsInGroup() and not IsInRaid()) then
            CompactPartyFrame:SetShown(true);
        end
    end

    function ns.ShowEditMode(window)
        if (not EditModeManagerFrame.UseRaidStylePartyFrames) then
            return;
        end
        ShowUIPanel(EditModeManagerFrame);
        if window == "PartyFrame" then
            C_EditMode.SetAccountSetting(Enum.EditModeAccountSetting.ShowPartyFrames, 1);
            --EditModeManagerFrame:SelectSystem(PartyFrame);
            PartyFrame:SelectSystem();
            PartyFrame:HighlightSystem();
        end
    end

else

    --[[
    ! Solo Party Frames Classic
    - Show Party/Raid Frames even if solo
    ]]
    local Blizzard_GetDisplayedAllyFrames = GetDisplayedAllyFrames; -- protect original behavior
    SoloRaid_GetDisplayedAllyFrames = function()
        -- Call original default behavior
        local daf = Blizzard_GetDisplayedAllyFrames()

        if not daf then
            return 'party'
        else
            return daf
        end
    end
    local Blizzard_CompactRaidFrameContainer_OnEvent = CompactRaidFrameContainer_OnEvent;  -- protect original behavior
    SoloRaid_CompactRaidFrameContainer_OnEvent = function(self, event, ...)
        -- Call original default behavior
        Blizzard_CompactRaidFrameContainer_OnEvent(self, event, ...)

        -- If all these are true, then the above call already did the TryUpdate
        local unit = ... or ""
        if ( unit == "player" or strsub(unit, 1, 4) == "raid" or strsub(unit, 1, 5) == "party" ) then
            return
        end
        -- Always update the RaidFrame
        if ( event == "UNIT_PET" ) and ( self.displayPets ) then
            CompactRaidFrameContainer_TryUpdate(self)
        end
    end

end

-- Will be used in standalone addon
local function getInfo(self)
    if (EditModeManagerFrame.UseRaidStylePartyFrames and not EditModeManagerFrame:UseRaidStylePartyFrames()) then
        -- Edit Mode - Since DragonFlight (10)
        ns.AddMsgWarn(ns.TITLE.." - "..l.OPTION_SOLORAID_TOOLTIP);
        ns.ShowEditMode("PartyFrame");
    else
        ns.AddMsg(l.MSG_LOADED);
    end
end

local function onSaveOptions(self, options)
    if (options.SoloRaidFrame) then
        if (EditModeManagerFrame.UseRaidStylePartyFrames and not EditModeManagerFrame:UseRaidStylePartyFrames()) then
			-- Edit Mode - Since DragonFlight (10)
            ns.AddMsgWarn(ns.TITLE.." - "..l.OPTION_SOLORAID_TOOLTIP);
        end
    end
end
local function onInit(self, options)
    if (options.SoloRaidFrame) then
        if (EditModeManagerFrame.UseRaidStylePartyFrames) then
            -- Edit Mode - Since DragonFlight (10)
            hooksecurefunc(CompactPartyFrame, "UpdateVisibility", Hook_CompactPartyFrame_UpdateVisibility);
        else
            -- Classic
            CompactRaidFrameManager:Show()
            CompactRaidFrameManager.Hide = function() end
            CompactRaidFrameContainer:Show()
            CompactRaidFrameContainer.Hide = function() end

            GetDisplayedAllyFrames = SoloRaid_GetDisplayedAllyFrames;
            CompactRaidFrameContainer_OnEvent = SoloRaid_CompactRaidFrameContainer_OnEvent;
        end
		-- Delay to let EditMode to be loaded
		C_Timer.After(0, function() onSaveOptions(self, options) end)
    end

end
local module = ns.Module:new(onInit, "Soloraid");
module:SetOnSaveOptions(onSaveOptions);
module:SetGetInfo(getInfo);