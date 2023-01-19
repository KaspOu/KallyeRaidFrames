-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------



KRF_VERS_TITLE    = format("%s %s", KRF_TITLE, KRF_VERSION);

-- Whats new info
KRF_WHATSNEW = OR.."- "..KRF_VERS_TITLE.." -"..YLL.." What's new:\n"
  .."- Add "..RT8.." to death players names\n"
  .."- Fixes (Deaths name color, Out of range transparency, minor errors...)\n"
  ;

KRF_SUBTITLE      = "Raid frames support";
KRF_DESC          = "Enhance party/raid frames and nameplates on friendly units\n\n"
.." - Highlight raid frames background on low health\n\n"
.." - Inverted frames will use your choice of colors\n\n"
.." - Transparency when unit out of range";
KRF_OPTIONS_TITLE = format("%s - Options", KRF_VERS_TITLE);

-- Messages
KRF_MSG_LOADED         = format("%s loaded", KRF_VERS_TITLE);
KRF_MSG_SDB            = "Kallye options frame";

KRF_INIT_FAILED = format("%s not initialized correctly!", KRF_VERS_TITLE);


KRF_OPTION_RAID_HEADER = "Party / Raid";
KRF_OPTION_HIGHLIGHTLOWHP = "Highlight players HP loss (dynamic colors)";
KRF_OPTION_REVERTBAR = YL.."Revert|r HP bars (less life = bigger bar !) "..YL.."*";
KRF_OPTION_HEALTH_LOW = "Almost dead!";
KRF_OPTION_HEALTH_LOW_TOOLTIP = "Low health color applied "..YLL.."BELOW|r this limit\n\n"
  .."i.e.: Red below 25%";
KRF_OPTION_HEALTH_WARN = "Warning";
KRF_OPTION_HEALTH_WARN_TOOLTIP = "Warn health color applied "..YLL.."AT|r this limit exactly\n\n"
  .."i.e.: Yellow at 50%";
KRF_OPTION_HEALTH_OK = "Health ok";
KRF_OPTION_HEALTH_OK_TOOLTIP = "OK health color applied "..YLL.."AFTER|r this limit\n\n"
  .."i.e.: Green after 75%";
KRF_OPTION_MOVEROLEICONS = "Adjust role icons on top left";
KRF_OPTION_HIDEDAMAGEICONS = "Hide 'dps' role icon";
KRF_OPTION_HIDEREALM = "Hide players realm";
KRF_OPTION_HIDEREALM_TOOLTIP = "Realm names will be masked, "..YLL.."Illidan - Varimathras|r will become "..YLL.."Illidan (*)|r";
KRF_OPTION_ICONONDEATH = "Add "..RT8.." to dead players names";
KRF_OPTION_FRIENDSCLASSCOLOR = "Names colored by class";
KRF_OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Change player nameplate (on the head) color according to class (doesn't work inside instances)";
KRF_OPTION_NOTINRANGE = "Transparency when out of range";
KRF_OPTION_NOTINRANGE_TOOLTIP = CY.."Wow default: 55%";
KRF_OPTION_NOTINCOMBAT = "Raid transparency out of combat";
KRF_OPTION_NOTINCOMBAT_TOOLTIP = CY.."Wow default: 100%";
KRF_OPTION_SOLORAID = CY.."Always show party frames "..YL.."*";
KRF_OPTION_SOLORAID_TOOLTIP = "Require option "..YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU..": "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
KRF_OPTION_SOLORAID_REQUIRE_USERAIDPARTYFRAMES = RDL.."Option 'Always show party frames' enabled:|r "..YL..KRF_OPTION_SOLORAID_TOOLTIP;

KRF_OPTION_EDITMODE_PARTY = HUD_EDIT_MODE_MENU..": "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
KRF_OPTION_EDITMODE_PARTY_NOTE = "Note: Use "..YL.."/reload|r after editing, to avoid possibles errors";
KRF_OPTION_EDITMODE_PARTY_TOOLTIP = "Enter "..YL..HUD_EDIT_MODE_MENU.."|r, and open "..YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r options window.\n\n"..CY..KRF_OPTION_EDITMODE_PARTY_NOTE.."|r";
KRF_OPTION_DEBUG_ON = "! Test party/raid frames !";
KRF_OPTION_DEBUG_ON_MESSAGE = "Testing party / raid frames (you can test in "..HUD_EDIT_MODE_MENU..")\n"
                  .."Reclick to stop it!";
KRF_OPTION_DEBUG_OFF = "! STOP Test !";
KRF_OPTION_DEBUG_OFF_MESSAGE = "Test stopped, have fun!";

KRF_OPTION_BUFFS_HEADER = "Buffs / Debuffs";
KRF_OPTION_BUFFSSCALE = "Buffs relative size"..YL.."*";
KRF_OPTION_BUFFSSCALE_TOOLTIP = CY.."Set to 1 if you experience some addon conflict";
KRF_OPTION_DEBUFFSSCALE = "Debuffs relative size"..YL.."*";
KRF_OPTION_DEBUFFSSCALE_TOOLTIP = CY.."Set to 1 if you experience some addon conflict";
KRF_OPTION_MAXBUFFS = "Max buffs";
KRF_OPTION_MAXBUFFS_TOOLTIP = "Max buffs to display";
KRF_OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";

KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES = "Players nameplates colored by class (outside instances)";

KRF_OPTION_RESET_OPTIONS = "Reset options";
KRF_OPTION_RELOAD_REQUIRED = "Some changes require reloading (write: "..YL.."/reload|r )";

KRF_OPTION_SHOWMSGNORMAL = GYL.."Display messages";
KRF_OPTION_SHOWMSGWARNING = GYL.."Display warnings";
KRF_OPTION_SHOWMSGERR = GYL.."Display errors";





-- end
