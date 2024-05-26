-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------
local _, ns = ...
local l = ns.I18N;

l.VERS_TITLE    = format("%s %s", ns.TITLE, ns.VERSION);

-- Whats new info
l.WHATSNEW = " What's new:\n"
    .."- Added enemy colored nameplates option.\n"
    .."- UI enhancements (info button, gradient background).\n"
    .."- |cffff1111Wow Classic|r & |cffc16600Cata|r versions!\n"
  ;
l.WHATSNEW = l.YL..l.VERS_TITLE.." -"..l.YLL..l.WHATSNEW;

l.SUBTITLE      = "Raid frames support";
l.DESC          = "Enhance raid frames and nameplates on friendly units\n\n"
.." - Highlight raid frames background on low health\n\n"
.." - Inverted frames will use your choice of colors\n\n"
.." - Transparency when unit out of range";
l.OPTIONS_TITLE = format("%s - Options", l.VERS_TITLE);

-- Messages
l.MSG_LOADED         = format("%s loaded", l.VERS_TITLE);
l.MSG_SDB            = "Kallye options frame";

l.INIT_FAILED = format("%s not initialized correctly!", l.VERS_TITLE);


l.OPTION_RAID_HEADER = "Party / Raid";
l.OPTION_HIGHLIGHTLOWHP = "Highlight players HP loss (dynamic colors)";
l.OPTION_REVERTBAR = l.YL.."Revert|r HP bars (less life = bigger bar !) "..l.YL.."*";
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
l.OPTION_SOLORAID = l.CY.."Display raid frames while solo "..l.YL.."*";
l.OPTION_SOLORAID_TOOLTIP = "Always display party/raid frames";

l.OPTION_EDITMODE_PARTY = "#";
l.OPTION_EDITMODE_PARTY_NOTE = "#";
l.OPTION_EDITMODE_PARTY_TOOLTIP = "#";
l.OPTION_DEBUG_ON = "! Test raid frames !";
l.OPTION_DEBUG_ON_MESSAGE = "Testing party / raid frames, reclick to stop it!";
l.OPTION_DEBUG_OFF = "! STOP Test !";
l.OPTION_DEBUG_OFF_MESSAGE = "Test stopped, have fun!";

l.OPTION_BUFFS_HEADER = "Buffs / Debuffs";
l.OPTION_BUFFSSCALE = "Buffs relative size"..l.YL.."*";
l.OPTION_BUFFSSCALE_TOOLTIP = l.CY.."Set to 1 if you experience some addon conflict";
l.OPTION_DEBUFFSSCALE = "Debuffs relative size"..l.YL.."*";
l.OPTION_DEBUFFSSCALE_TOOLTIP = l.CY.."Set to 1 if you experience some addon conflict";
l.OPTION_MAXBUFFS = "Max buffs";
l.OPTION_MAXBUFFS_TOOLTIP = "Max buffs to display";
l.OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";

l.OPTION_OTHERS_HEADER = "Nameplates";
l.OPTION_NAMEPLATES_USECOLOR_BLIZZARD = l.RDL.."Blizzard default colors";
l.OPTION_NAMEPLATES_USECOLOR_CLASS ="Use class color";
l.OPTION_NAMEPLATES_USECOLOR_CUSTOM ="Your color choice: ";
l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR = "Allied names coloration";
l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Text color of the name above allied nameplates (outside instances)";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR = "Allied bars coloration"..l.GYL.." (Classic)";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Color of allied nameplates (outside instances)";
l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR = "Enemy names coloration";
l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Text color of the name above enemy nameplates (outside instances)";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR = "Enemy bars coloration"..l.GYL.." (Classic)";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Color of enemy nameplates (outside instances)";
l.OPTION_SHOWPVPICONS = "Show PvP icons";
l.OPTION_SHOWPVPICONS_TOOLTIP = "Displays PvP icons on info bars, both friendly and enemy.";

l.OPTION_RESET_OPTIONS = "Reset options";
l.OPTION_RELOAD_REQUIRED = "Some changes require reloading (write: "..l.YL.."/reload|r )";
l.OPTIONS_ASTERIX = l.YL.."*|r"..l.WH..": Options requiring reloading";

l.OPTION_SHOWMSGNORMAL = l.GYL.."Display messages";
l.OPTION_SHOWMSGWARNING = l.GYL.."Display warnings";
l.OPTION_SHOWMSGERR = l.GYL.."Display errors";
l.OPTION_WHATSNEW = "What's new";

-- Edit Mode - Since DragonFlight (10)
if (EditModeManagerFrame.UseRaidStylePartyFrames) then
  if (not EditModeManagerFrame:UseRaidStylePartyFrames()) then
    l.OPTION_SOLORAID_TOOLTIP = "I suggest you to activate option "..l.YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU..": "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
    l.DESC = l.DESC.."\n\n - "..l.OPTION_SOLORAID_TOOLTIP;
  end
  l.OPTION_EDITMODE_PARTY = HUD_EDIT_MODE_MENU..": "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
  l.OPTION_EDITMODE_PARTY_NOTE = "Note: Use "..l.YL.."/reload|r after "..HUD_EDIT_MODE_MENU..", to avoid possibles errors";
  l.OPTION_EDITMODE_PARTY_TOOLTIP = "Enter "..l.YL..HUD_EDIT_MODE_MENU.."|r, and open "..l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r options window.\n\n"..l.CY..l.OPTION_EDITMODE_PARTY_NOTE.."|r";
  l.OPTION_DEBUG_ON_MESSAGE = "Testing party / raid frames (you can test in "..HUD_EDIT_MODE_MENU..")\n"
                    .."Reclick to stop it!";
end

-- end