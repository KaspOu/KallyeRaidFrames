-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------
local _, ns = ...
local l = ns.I18N;

l.VERS_TITLE    = format("%s %s", ns.TITLE, ns.VERSION);

l.CONFLICT_MESSAGE = "Disabled: Conflict with %s";

-- Whats new info
l.WHATSNEW = [[ What's new:
- Display players level on nameplates
- Working with Addon Compartment
- SoloRaid autoactivates Raid Style Party frames
]]

l.WHATSNEW = l.YL..l.VERS_TITLE.." -"..l.YLL..l.WHATSNEW;

l.SUBTITLE      = "Raid frames support";
l.DESC          = "Enhance raid frames and nameplates on friendly units\n\n"
.." - Highlight raid frames background on low health\n\n"
.." - Inverted frames will use your choice of colors\n\n"
.." - Transparency when unit out of range\n\n"
.." - Raid always visible\n\n"
.."\n"
.."Enhance Buffs / debuffs management (size, max displayed, ...)\n\n"
.."Colorize Nameplates, with PvP icons |TInterface/PVPFrame/PVP-Currency-Alliance:16|t|TInterface/PVPFrame/PVP-Currency-Horde:16|t\n\n"
.."Shows target icons (|TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t|TInterface/TargetingFrame/UI-RaidTargetingIcon_2:0|t...) on raid frames\n\n"
l.OPTIONS_TITLE = format("%s - Options", l.VERS_TITLE);

-- Messages
l.MSG_LOADED         = format("%s loaded", l.VERS_TITLE);
l.MSG_SDB            = "Kallye options frame";

l.INIT_FAILED = format("%s not initialized correctly!", l.VERS_TITLE);


local required = l.YL.."*";
l.OPTION_RAID_HEADER = "Party / Raid";
l.OPTION_HIGHLIGHTLOWHP = "Highlight players HP loss (dynamic colors)";
l.OPTION_REVERTBAR = l.YL.."Revert|r HP bars (less life = bigger bar !) "..required;
l.OPTION_HEALTH_LOW = "Almost dead!";
l.OPTION_HEALTH_LOW_TOOLTIP = "Low health color applied "..l.YLL.."BELOW|r this limit\n\n"
  .."i.e.: Red below 25%";
l.OPTION_HEALTH_WARN = "Warning";
l.OPTION_HEALTH_WARN_TOOLTIP = "Warn health color applied "..l.YLL.."AT|r this limit exactly\n\n"
  .."i.e.: Yellow at 50%";
l.OPTION_HEALTH_OK = "Health ok";
l.OPTION_HEALTH_OK_TOOLTIP = "OK health color applied "..l.YLL.."AFTER|r this limit\n\n"
  .."i.e.: Green after 75%";
l.OPTION_MOVEROLEICONS = "Adjust role icons on top left";
l.OPTION_HIDEDAMAGEICONS = "Hide 'dps' role icon";
l.OPTION_HIDEREALM = "Hide players realm";
l.OPTION_HIDEREALM_TOOLTIP = "Realm names will be masked, "..l.YLL.."Illidan - Varimathras|r will become "..l.YLL.."Illidan (*)|r";
l.OPTION_ICONONDEATH = "Add "..l.RT8.." to dead players names";
l.OPTION_FRIENDSCLASSCOLOR = "Names colored by class";
l.OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Enhance player color according to their class (party/raid frames)";
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR = "Blizzard: "..l.OPTION_FRIENDSCLASSCOLOR;
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR_TOOLTIP = "Base raid class colors option";
l.OPTION_NOTINRANGE = "Transparency when out of range";
l.OPTION_NOTINRANGE_TOOLTIP = l.CY.."Wow default: 55%";
l.OPTION_NOTINCOMBAT = "Raid transparency out of combat";
l.OPTION_NOTINCOMBAT_TOOLTIP = l.CY.."Wow default: 100%";
l.OPTION_SOLORAID = l.CY.."Display raid frames while solo "..required;
l.OPTION_SOLORAID_TOOLTIP = "Always display party/raid frames,\nwill active "..l.YLL..USE_RAID_STYLE_PARTY_FRAMES

l.OPTION_EDITMODE_PARTY = format("Blizzard: %s", USE_RAID_STYLE_PARTY_FRAMES)
l.OPTION_EDITMODE_PARTY_TOOLTIP = "";
l.OPTION_DEBUG_ON = "! Test raid frames !";
l.OPTION_DEBUG_ON_MESSAGE = "Testing party / raid frames, reclick to stop it!";
l.OPTION_DEBUG_OFF = "! STOP Test !";
l.OPTION_DEBUG_OFF_MESSAGE = "Test stopped, have fun!";

l.OPTION_ACTIVATE_MODULE = "Activate / Desactivate module"
l.OPTION_HIDEDISABLED = l.GYL.."Hide disabled modules"

l.OPTION_BUFFS_HEADER = "Buffs / Debuffs";
l.OPTION_BUFFSSCALE = "Buffs relative size"..required;
l.OPTION_BUFFSSCALE_TOOLTIP = l.CY.."Set to 1 if you experience some addon conflict";
l.OPTION_MAXBUFFS = "Max buffs"..required;
l.OPTION_MAXBUFFS_TOOLTIP = "Max buffs to display\n"..l.CY.."Set to "..ns.DEFAULT_MAXBUFFS.." if you experience some addon conflict";
l.OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";
l.OPTION_BUFFSPERLINE = "Buffs per line";
l.OPTION_BUFFSPERLINE_TOOLTIP = "Number of buff icons per line\n"..l.CY.."Set to max value if you experience some addon conflict";
l.OPTION_BUFFSPERLINE_FORMAT = "%d per line"..required;
l.OPTION_BUFFSVERTICAL = "Buffs aligned vertically"..required;
l.OPTION_BUFFSVERTICAL_TOOLTIP = "Buffs will be vertically aligned,\nin columns\n"..l.CY.."Disable if you experience some addon conflict";
l.OPTION_DEBUFFSSCALE = "Debuffs relative size"..required;
l.OPTION_DEBUFFSSCALE_TOOLTIP = l.CY.."Set to 1 if you experience some addon conflict";
l.OPTION_MAXDEBUFFS = "Max debuffs"..required;
l.OPTION_MAXDEBUFFS_TOOLTIP = "Max debuffs to display\n"..l.CY.."Set to "..ns.DEFAULT_MAXBUFFS.." if you experience some addon conflict";
l.OPTION_MAXDEBUFFS_FORMAT = "%d |4debuff:debuffs";
l.OPTION_DEBUFFSPERLINE = "Debuffs per line"..required;
l.OPTION_DEBUFFSPERLINE_TOOLTIP = "Number of debuff icons per line\n"..l.CY.."Set to max value if you experience some addon conflict";
l.OPTION_DEBUFFSPERLINE_FORMAT = "%d per line";
l.OPTION_DEBUFFSVERTICAL = "Debuffs aligned vertically"..required;
l.OPTION_DEBUFFSVERTICAL_TOOLTIP = "Debuffs will be vertically aligned,\nin columns\n"..l.CY.."Disable if you experience some addon conflict";

l.OPTION_OTHERS_HEADER = "Nameplates";
l.OPTION_NAMEPLATES_USECOLOR_BLIZZARD = l.RDL.."Blizzard default colors";
l.OPTION_NAMEPLATES_USECOLOR_CLASS ="Use class color";
l.OPTION_NAMEPLATES_USECOLOR_CUSTOM ="Your color choice: ";
l.OPTION_NAMEPLATES_SHOWPVPICONS_BLIZZARD = l.RDL.."No icon";
l.OPTION_NAMEPLATES_SHOWPVPICONS_FACTION = "Faction icon |TInterface/PVPFrame/PVP-Currency-Alliance:16|t - |TInterface/PVPFrame/PVP-Currency-Horde:16|t"
l.OPTION_NAMEPLATES_COLOR_UNDER = "Color if lower";
l.OPTION_NAMEPLATES_COLOR_UNDER_TOOLTIP = "Select the color of the level if it is lower than yours";
l.OPTION_NAMEPLATES_COLOR_OVER = "Color if higher";
l.OPTION_NAMEPLATES_COLOR_OVER_TOOLTIP = "Select the color of the level if it is higher than yours";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER = l.RDL.."Never";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER_TOOLTIP = "Never show the level on the info bars.";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT = "If different from yours";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT_COLORED = "If different from yours, colored";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS = "Always";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS_COLORED = "Always, colored";

l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR = "Allied names";
l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Text color of the name above allied nameplates (outside instances)";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR = "Allied bars";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Color of allied nameplates (outside instances)";
l.OPTION_FRIENDSNAMEPLATES_PVPICONS = "Allied PvP icons";
l.OPTION_FRIENDSNAMEPLATES_PVPICONS_TOOLTIP = "Displays PvP icons on allied names.";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL = "Allied level";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Displays the level on allied info bars.";

l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR = "Enemy names";
l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Text color of the name above enemy nameplates (outside instances)";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR = "Enemy bars";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Color of enemy nameplates (outside instances)";
l.OPTION_ENEMIESNAMEPLATES_PVPICONS = "Enemy PvP icons";
l.OPTION_ENEMIESNAMEPLATES_PVPICONS_TOOLTIP = "Displays PvP icons on enemy names.";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL = "Enemy level";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Displays the level on enemy info bars.";

l.OPTION_ACTIVATE_MODULE_RAIDICONS = l.OPTION_ACTIVATE_MODULE .. "\n"
  ..l.WH.."Shows target icons (|TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t|TInterface/TargetingFrame/UI-RaidTargetingIcon_2:0|t...) on raid frames"
l.OPTION_RAIDICONS_HEADER = "Raid icons |TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t";
l.OPTION_RAIDICONS_ANCHOR = "Icon alignement";
l.OPTION_RAIDICONS_ANCHOR_TOOLTIP = "Position of the target icon in the raid frame";
l.OPTION_CENTER = "Center"
l.OPTION_TOPLEFT = "Top Left";
l.OPTION_TOPRIGHT = "Top Right";
l.OPTION_BOTTOMLEFT = "Bottom Left";
l.OPTION_BOTTOMRIGHT = "Bottom Right";
l.OPTION_RAIDICONS_SIZE = "Raid icon size";
l.OPTION_RAIDICONS_SIZE_TOOLTIP = "Adjust the size of the raid icons";
l.OPTION_RAIDICONS_RELATIVE_X = "Horizontal position";
l.OPTION_RAIDICONS_RELATIVE_X_TOOLTIP = "Adjust the relative horizontal position of the raid icons";
l.OPTION_RAIDICONS_RELATIVE_Y = "Vertical position";
l.OPTION_RAIDICONS_RELATIVE_Y_TOOLTIP = "Adjust the relative vertical position of the raid icons";


l.OPTION_RESET_OPTIONS = "Reset options";
l.OPTION_RELOAD_REQUIRED = "Some changes require reloading (write: "..l.YL.."/reload|r )";
l.OPTIONS_ASTERIX = l.YL.."*|r"..l.WH..": Options requiring reloading";

l.OPTION_SHOWMSGNORMAL = l.GYL.."Display messages";
l.OPTION_SHOWMSGWARNING = l.GYL.."Display warnings";
l.OPTION_SHOWMSGERR = l.GYL.."Display errors";
l.OPTION_COMPARTMENT_FILTER = "Display in the Compartment Filter";
l.OPTION_COMPARTMENT_FILTER_TOOLTIP = "In addons list on top right";
l.OPTION_WHATSNEW = "What's new";

--? Edit Mode - Since DragonFlight (10)
if (EditModeManagerFrame.UseRaidStylePartyFrames) then
  -- Edit mode takes a while...
  l.UpdateLocales = function ()
    C_Timer.After(1, function()
        if (not ns.CanEditActiveLayout()) then
          l.OPTION_SOLORAID_TOOLTIP = "I suggest you to activate option "..l.YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU..": "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
          l.DESC = l.DESC.."\n"..l.CY..l.OPTION_SOLORAID_TOOLTIP.."|r\n\n";
        end
      end)
  end
  l.OPTION_EDITMODE_PARTY_TOOLTIP = format("%s / %s option %s|r of %s|r\n(%s|r)", ENABLE, DISABLE, l.YL..USE_RAID_STYLE_PARTY_FRAMES, l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL, l.RDD..HUD_EDIT_MODE_MENU)
  l.OPTION_EDITMODE_BTN_PARTY = HUD_EDIT_MODE_MENU..": "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
  l.OPTION_EDITMODE_BTN_PARTY_NOTE = "Note: Use "..l.YL.."/reload|r after "..HUD_EDIT_MODE_MENU..", to avoid possibles errors";
  l.OPTION_EDITMODE_BTN_PARTY_TOOLTIP = "Enter "..l.YL..HUD_EDIT_MODE_MENU.."|r, and open "..l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r options window.\n\n"..l.CY..l.OPTION_EDITMODE_BTN_PARTY_NOTE.."|r";
  l.OPTION_DEBUG_ON_MESSAGE = "Testing party / raid frames (you can test in "..HUD_EDIT_MODE_MENU..")\n"
                    .."Reclick to stop it!";
end

-- end