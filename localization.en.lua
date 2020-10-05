-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------



KRF_VERS_TITLE    = format("%s %s", KRF_TITLE, KRF_VERSION);

-- Whats new info
KRF_WHATSNEW = OR.."- "..KRF_VERS_TITLE..YLL.." - Whats new:|r\n"
  .."- EVERYTHING !!\n"
  .."- Please feel free to give suggestions…...\n"
  ;

KRF_SUBTITLE      = "Raid frames support";
KRF_DESC          = "Enhance party/raid frames and nameplates on friendly units\n\n"
.." - Highlight raid frames background on low health\n\n"
.." - Inverted frames will use your colors directly\n\n"
.." - Transparency when unit out of range";
KRF_OPTIONS_TITLE = format("%s - Options", KRF_VERS_TITLE);

-- Messages
KRF_MSG_LOADED         = format("%s loaded", KRF_VERS_TITLE);
KRF_MSG_SDB            = "Kallye options frame";

KRF_INIT_FAILED = format("%s not initialized correctly!", KRF_VERS_TITLE);


KRF_OPTION_RAID_HEADER = "Party / Raid";
KRF_OPTION_HIGHLIGHTLOWHP = "Highlight players HP loss";
KRF_OPTION_REVERTBAR = YL.."Revert|r HP bars (less life = bigger bar !) "..YL.."*";
KRF_OPTION_HEALTH_LOW = "Near dead!";
KRF_OPTION_HEALTH_LOW_TOOLTIP = "Low health color applied "..YLL.."BELOW|r this limit\n\n"
  .."i.e.: Red below 30%";
KRF_OPTION_HEALTH_WARN = "Warning";
KRF_OPTION_HEALTH_WARN_TOOLTIP = "Warn health color applied "..YLL.."AT|r this limit exactly\n\n"
  .."i.e.: Yellow at 50%";
KRF_OPTION_HEALTH_OK = "Health ok";
KRF_OPTION_HEALTH_OK_TOOLTIP = "OK health color applied "..YLL.."AFTER|r this limit\n\n"
  .."i.e.: Green after 60%";
KRF_OPTION_MOVEROLEICONS = "Adjust role icons on top left";
KRF_OPTION_HIDEDAMAGEICONS = "Hide 'dps' role icon";
KRF_OPTION_HIDEREALM = "Hide players realm";
KRF_OPTION_FRIENDSCLASSCOLOR = "Names colored by class";
KRF_OPTION_NOTINRANGE = "Transparency when out of range";
KRF_OPTION_NOTINCOMBAT = "Raid transparency out of combat";
KRF_OPTION_SOLORAID = CY.."Always display raid frames "..YL.."*";
KRF_OPTION_DEBUG_ON = "! Test raidframes !";
KRF_OPTION_DEBUG_ON_MESSAGE = "Testing raid frames, reclick to stop it!";
KRF_OPTION_DEBUG_OFF = "! STOP Test !";
KRF_OPTION_DEBUG_OFF_MESSAGE = "Test stopped, have fun!";

KRF_OPTION_BUFFS_HEADER = "Buffs / Debuffs";
KRF_OPTION_BUFFSSCALE = "Buffs relative size";
KRF_OPTION_DEBUFFSSCALE = "Debuffs relative size";
KRF_OPTION_MAXBUFFS = "Max buffs";
KRF_OPTION_MAXBUFFS_TOOLTIP = "Max buffs to display";
KRF_OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";

KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES = "Players nameplates colored by class (outside raid)";

KRF_OPTION_RESET_OPTIONS = "Reset options";
KRF_OPTION_RELOAD_REQUIRED = "Some options need a reload (write: /reload )";

KRF_OPTION_SHOWMSGNORMAL = GYL.."Display messages";
KRF_OPTION_SHOWMSGWARNING = GYL.."Display warnings";
KRF_OPTION_SHOWMSGERR = GYL.."Display errors";



-- end
