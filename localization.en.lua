-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------

-- Whats new info
KRF_WHATSNEW = "|cffffffffWhats new:|r\n\n"
  .."- Updated TOC\n\n"
  .."- Added Demon Hunter class\n\n"
  .."- Adjusted colors\n\n"
  .."- Fixed LUA errors\n\n"
  .."- Thanks to the Guild Nocturnes.\n\n"
  ;

KRF_SUBTITLE      = "Raid frames support";
KRF_DESC          = "Enhance raid and bar frames on friendly units\n\n - Highlight raid frames on low health";
KRF_VERS_TITLE    = format("%s %s", KRF_TITLE, KRF_VERSION);
KRF_OPTIONS_TITLE = format("%s - Options", KRF_VERS_TITLE);

-- Messages
KRF_MSG_LOADED         = format("%s loaded", KRF_VERS_TITLE);
KRF_MSG_SDB            = "Kallye options frame";

KRF_INIT_FAILED = format("%s not initialized correctly!", KRF_VERS_TITLE);

KRF_OPTION_RAID_HEADER = "Party / Raid";
KRF_OPTION_HIGHLIGHTLOWHP = "Highlight players HP loss";
KRF_OPTION_REVERTBAR = "Revert HP bars (less life = bigger bar !) *";
KRF_OPTION_HEALTH_LOW = "Near dead!";
KRF_OPTION_HEALTH_LOW_TOOLTIP = "Low health color applied BELOW this limit\ni.e.: Red below 30%";
KRF_OPTION_HEALTH_WARN = "Warning";
KRF_OPTION_HEALTH_WARN_TOOLTIP = "Warn health color applied AT this limit exactly\ni.e.: Yellow at 50%";
KRF_OPTION_HEALTH_OK = "Health ok";
KRF_OPTION_HEALTH_OK_TOOLTIP = "OK health color applied AFTER this limit\ni.e.: Green after 60%";
KRF_OPTION_HIDEDAMAGEICONS = "Hide dps icon";
KRF_OPTION_MOVEROLEICONS = "Replace icons on top left";
KRF_OPTION_SOLORAID = "Always display raid frames (even without party) *";
KRF_OPTION_DEBUG_ON = "! Test raidframes !";
KRF_OPTION_DEBUG_ON_MESSAGE = "Test activated, reclick to stop it!";
KRF_OPTION_DEBUG_OFF = "! STOP Test !";
KRF_OPTION_DEBUG_OFF_MESSAGE = "Test stopped, have fun!";

KRF_OPTION_BUFFS_HEADER = "Buffs / Debuffs";
KRF_OPTION_BUFFSSCALE = "Buffs relative size";
KRF_OPTION_DEBUFFSSCALE = "Debuffs relative size";
KRF_OPTION_MAXBUFFS = "Max buffs";
KRF_OPTION_MAXBUFFS_TOOLTIP = "Max buffs / debuffs to display";
KRF_OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";

KRF_OPTION_HIDEREALM = "Hide other players realm";
KRF_OPTION_FRIENDSCLASSCOLOR = "Friendly players names colored by class";
KRF_OPTION_NAMEPLATES_FRIENDSALPHAINCOMBAT = "Nameplates: Friendly players name transparency in combat";
KRF_OPTION_NAMEPLATES_FRIENDSALPHANOTINCOMBAT = "Nameplates: Friendly players name transparency out of combat";

KRF_OPTION_RESET_OPTIONS = "Reset options";
KRF_OPTION_RELOAD_REQUIRED = "Some options need a reload (write: /reload )";

KRF_OPTION_SHOWMSGNORMAL = "Display all messages (verbose)";
KRF_OPTION_SHOWMSGERR = "Display errors messages";
KRF_OPTION_SHOWMSGWARNING = "Display warning messages";


--[[
-- Debuff types
KRF_DISEASE = "Disease";
KRF_MAGIC   = "Magic";
KRF_POISON  = "Poison";
KRF_CURSE   = "Curse";
KRF_CHARMED = "Mind Control";
KRF_HEAL    = "Heal";


-- Creatures
KRF_HUMANOID  = "Humanoid";
KRF_DEMON     = "Demon";
KRF_BEAST     = "Beast";
KRF_ELEMENTAL = "Elemental";
KRF_IMP       = "Imp";
KRF_FELHUNTER = "Felhunter";
KRF_DOOMGUARD = "Doomguard";

-- Classes
KRF_CLASSES = { ["DRUID"] = "Druid", ["HUNTER"] = "Hunter", ["MAGE"] = "Mage", ["PALADIN"] = "Paladin", ["PRIEST"] = "Priest", ["ROGUE"] = "Rogue"
                , ["SHAMAN"] = "Shaman", ["WARLOCK"] = "Warlock", ["WARRIOR"] = "Warrior", ["DEATHKNIGHT"] = "Death Knight", ["MONK"] = "Monk", ["DEMONHUNTER"] = "Demon Hunter", ["HPET"] = "Hunter Pet", ["WPET"] = "Warlock Pet"};

-- Bindings
BINDING_NAME_KRF_BIND_OPTIONS = "Options frame";

KRF_KEYS = {["L"]  = "Left",
                    ["R"]  = "Right",
                    ["M"]  = "Middle",
                    ["SL"] = "Shift left",
                    ["SR"] = "Shift right",
                    ["SM"] = "Shift middle",
                    ["AL"] = "Alt left",
                    ["AR"] = "Alt right",
                    ["AM"] = "Alt middle",
                    ["CL"] = "Ctrl left",
                    ["CR"] = "Ctrl right",
                    ["CM"] = "Ctrl middle"
                    };


-- Frame text
KRF_FT_MODES           = "Keys/Modes";
KRF_FT_MODENORMAL      = "Norm";
KRF_FT_MODETARGET      = "Trgt";


-- Options frame text
KRF_OFT                = "Show/Hide SmartDebuff options frame";
KRF_OFT_HUNTERPETS     = "Hunter pets";
KRF_OFT_WARLOCKPETS    = "Warlock pets";
KRF_OFT_DEATHKNIGHTPETS= "Death Knight pets";
KRF_OFT_HP             = "HP";
KRF_OFT_MANA           = "Mana";
KRF_OFT_HPTEXT         = "%";
KRF_OFT_INVERT         = "Invert";
KRF_OFT_CLASSVIEW      = "Class view";
KRF_OFT_CLASSCOLOR     = "Class colors";
KRF_OFT_SHOWLR         = "L / R / M";
KRF_OFT_HEADERS        = "Headers";
KRF_OFT_GROUPNR        = "Group Nr.";
KRF_OFT_SOUND          = "Sound";
KRF_OFT_TOOLTIP        = "Tooltip";
KRF_OFT_TARGETMODE     = "Target mode";
KRF_OFT_HEALRANGE      = "Heal range";
KRF_OFT_SHOWAGGRO      = "Aggro";
KRF_OFT_VERTICAL       = "Vertical arranged";
KRF_OFT_VERTICALUP     = "Vertical up";
KRF_OFT_HEADERROW      = "Title bar";
KRF_OFT_BACKDROP       = "Background";
KRF_OFT_SHOWGRADIENT   = "Gradient";
KRF_OFT_INFOFRAME      = "Summary frame";
KRF_OFT_AUTOHIDE       = "Auto hide";
KRF_OFT_COLUMNS        = "Columns";
KRF_OFT_INTERVAL       = "Interval";
KRF_OFT_FONTSIZE       = "Font size";
KRF_OFT_WIDTH          = "Width";
KRF_OFT_HEIGHT         = "Height";
KRF_OFT_BARHEIGHT      = "Bar height";
KRF_OFT_OPACITYNORMAL  = "Opacity in range";
KRF_OFT_OPACITYOOR     = "Opacity out of range";
KRF_OFT_OPACITYDEBUFF  = "Opacity debuff";
KRF_OFT_NOTREMOVABLE   = "Debuff Guard";
KRF_OFT_VEHICLE        = "Vehicles";
KRF_OFT_SHOWRAIDICON   = "Raid icons";
KRF_OFT_SHOWSPELLICON  = "Spell icon";
KRF_OFT_INFOROW        = "Info bar";
KRF_OFT_GLOBALSAVE     = "Save";
KRF_OFT_GLOBALLOAD     = "Load";
KRF_OFT_ROLE           = "Role";
KRF_OFT_ADVANCHORS     = "Anchor Setup";
KRF_OFT_ICONSIZE       = "Icon size";
KRF_OFT_COLORSETUP     = "Color Setup";
KRF_OFT_SPACEX         = "Space X";
KRF_OFT_SPACEY         = "Space Y";
KRF_OFT_TESTMODE       = "Test Mode";
KRF_OFT_STOPCAST       = "Stop Casting";
KRF_OFT_IGNOREDEBUFF   = "Ignore Debuffs";
KRF_OFT_RESET_KEYS     = "Reset the SmartDebuff spell bindings to default?\nThis action is only necessary, if you have the feeling\nthat not all debuffs are correctly detected.";

KRF_AOFT_SORTBYCLASS   = "Sort by class order";
KRF_NRDT_TITLE         = "Unremovable Debuffs";
KRF_SG_TITLE           = "Spell Guard";
KRF_S_TITLE            = "Debuff Alert Sound";


-- Tooltip text
KRF_TT                 = "Shift-Left drag: Move frame\n|cff20d2ff- S button -|r\nLeft click: Show by classes\nShift-Left click: Class colors\nAlt-Left click: Highlight L/R\nRight click: Background";
KRF_TT_TARGETMODE      = "In target mode |cff20d2ffLeft click|r selects the unit and |cff20d2ffRight click|r casts the fastest heal spell. Use |cff20d2ffAlt-Left/Right click|r to debuff.";
KRF_TT_NOTREMOVABLE    = "Displays critical debuffs\nwhich are not removable.";
KRF_TT_HP              = "Displays actual health\npoints of the unit.";
KRF_TT_MANA            = "Displays actual mana\npool of the unit.";
KRF_TT_HPTEXT          = "Displays actual hp/mana\npool as percentage of\nthe unit as text.";
KRF_TT_INVERT          = "Displays health points\nand mana pool inverted.";
KRF_TT_CLASSVIEW       = "Displays the unit buttons\norder by class.";
KRF_TT_CLASSCOLOR      = "Displays the unit buttons in\ntheir corresponding class colors.";
KRF_TT_SHOWLR          = "Displays the corresponding\nmouse button (L/R/M), if\na unit has a debuff.";
KRF_TT_HEADERS         = "Displays the class name\nas header row.";
KRF_TT_GROUPNR         = "Displays the group number\nin front of the unit name.";
KRF_TT_SOUND           = "Plays a sound, if a\nunit gets a debuff.";
KRF_TT_TOOLTIP         = "Displays the tooltip,\nonly out of combat.";
KRF_TT_HEALRANGE       = "Displays a red boarder,\nif your spell is out of range.";
KRF_TT_SHOWAGGRO       = "Displays which\nunit has aggro.";
KRF_TT_VERTICAL        = "Displays the units\nvertical arranged.";
KRF_TT_VERTICALUP      = "Displays the units\nfrom bottom to top.";
KRF_TT_HEADERROW       = "Displays header row,\nincluding menu buttons.";
KRF_TT_BACKDROP        = "Displays a black\nbackground frame.";
KRF_TT_SHOWGRADIENT    = "Displays the unit buttons\nwith color gradient.";
KRF_TT_INFOFRAME       = "Displays the summary frame,\nonly in group or raid setup.";
KRF_TT_AUTOHIDE        = "Hides the unit buttons automatically,\nif you are out of combat and\nno one has a debuff.";
KRF_TT_VEHICLE         = "Displays in addition the vehicle of\na unit  as own button.";
KRF_TT_SHOWRAIDICON    = "Displays the raid icon\nof the unit.";
KRF_TT_SHOWSPELLICON   = "Displays the HoT icon\non the unit.";
KRF_TT_INFOROW         = "Displays an info bar in short style #\nPlayers/Dead/AFK/Offline\nHP/Mana\nReady check state\n(only in a raid)";
KRF_TT_GLOBALSAVE      = "settings to global template.";
KRF_TT_GLOBALLOAD      = "settings from global template.";
KRF_TT_ROLE            = "Displays the unit buttons\norder by role.";
KRF_TT_ADVANCHORS      = "Displays and uses the advanced\nanchoring setup for the debuff\nframe.";
KRF_TT_STOPCAST        = "Stops immediately the current\ncasting or channeling,\nto cast the defined spell.\n(Debuff spells only)";
KRF_TT_IGNOREDEBUFF    = "Ignores the debuff on the unit\nif your debuff spell is on cooldown";

--KRF_TT_COLUMNS         = "Columns";
--KRF_TT_INTERVAL        = "Interval";
--KRF_TT_FONTSIZE        = "Font size";
--KRF_TT_WIDTH           = "Width";
--KRF_TT_HEIGHT          = "Height";
--KRF_TT_BARHEIGHT       = "Bar height";
--KRF_TT_OPACITYNORMAL   = "Opacity in range";
--KRF_TT_OPACITYOOR      = "Opacity out of range";
--KRF_TT_OPACITYDEBUFF   = "Opacity debuff";

-- Tooltip text key bindings
KRF_TT_DROP            = "Drop";
KRF_TT_DROPINFO        = "Drop a spell/item/macro\nof your book/inventory.\n|cff00ff00Left click set target function.\nShift-Left set menu function";
KRF_TT_DROPSPELL       = "Spell click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KRF_TT_DROPITEM        = "Item click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KRF_TT_DROPMACRO       = "Macro click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KRF_TT_TARGET          = "Target";
KRF_TT_TARGETINFO      = "Selects the specified unit\nas the current target.";
KRF_TT_DROPTARGET      = "Mouse click:\nRight to remove";
KRF_TT_DROPACTION      = "Pet action:\nRemove not possible!";
KRF_TT_MENU            = "Menu";
KRF_TT_MENUINFO        = "Opens the unit options menu.";
KRF_TT_DROPMENU        = "Mouse click:\nRight to remove";

-- Tooltip support
KRF_FUBAR_TT           = "\nLeft Click: Open options\nShift-Left Click: On/Off";
KRF_BROKER_TT          = "Left Click: Open options\nRight Click: On/Off";

--]]--