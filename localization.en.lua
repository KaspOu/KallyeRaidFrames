-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------

-- Whats new info
KALLYE_WHATSNEW = "|cffffffffWhats new:|r\n\n"
  .."- Updated TOC\n\n"
  .."- Added Demon Hunter class\n\n"
  .."- Adjusted colors\n\n"
  .."- Fixed LUA errors\n\n"
  .."- Thanks to the Guild Nocturnes.\n\n"
  ;

KALLYE_SUBTITLE      = "Raid frames support";
KALLYE_DESC          = "Enhance raid and bar frames on friendly units\n\n - Highlight raid frames on low health";
KALLYE_VERS_TITLE    = format("%s %s", KALLYE_TITLE, KALLYE_VERSION);
KALLYE_OPTIONS_TITLE = format("%s - Options", KALLYE_VERS_TITLE);

-- Messages
KALLYE_MSG_LOADED         = format("%s loaded", KALLYE_VERS_TITLE);
KALLYE_MSG_SDB            = "Kallye options frame";

KALLYE_INIT_FAILED = format("%s not initialized correctly!", KALLYE_VERS_TITLE);


KALLYE_OPTION_HIGHLIGHTLOWHP = "Raidframe: Highlight players under 50% HP";
KALLYE_OPTION_HIDEDAMAGEICONS = "Raidframe: Hide dps icon";
KALLYE_OPTION_MOVEROLEICONS = "Raidframe: Replace tank/heal icons";
KALLYE_OPTION_BUFFSSCALE = "Buffs relative size";
KALLYE_OPTION_DEBUFFSSCALE = "Debuffs relative size";
KALLYE_OPTION_MAXBUFFS = "Max buffs / debuffs to display";
KALLYE_OPTION_HIDEREALM = "Hide other players realm";
KALLYE_OPTION_FRIENDSCLASSCOLOR = "Friendly players names colored by class";
KALLYE_OPTION_NAMEPLATES_FRIENDSALPHAINCOMBAT = "Nameplates: Friendly players name transparency in combat";
KALLYE_OPTION_NAMEPLATES_FRIENDSALPHANOTINCOMBAT = "Nameplates: Friendly players name transparency out of combat";
KALLYE_OPTION_EXPERIMENTALREVERTBAR = "Revert HP bars (less life = bigger bar !) *";
KALLYE_OPTION_DEBUGRANDOMHEALTH = "Debug mode (random HP displayed)";
KALLYE_OPTION_SOLORAID = "Always display raid frames (even without party) *";
KALLYE_OPTION_SHOWMSGNORMAL = "Display all messages (verbose)";
KALLYE_OPTION_SHOWMSGERR = "Display errors messages";
KALLYE_OPTION_SHOWMSGWARNING = "Display warning messages";
KALLYE_OPTION_RELOAD_REQUIRED = "Some options need a reload (write: /reload )";


--[[
-- Debuff types
KALLYE_DISEASE = "Disease";
KALLYE_MAGIC   = "Magic";
KALLYE_POISON  = "Poison";
KALLYE_CURSE   = "Curse";
KALLYE_CHARMED = "Mind Control";
KALLYE_HEAL    = "Heal";


-- Creatures
KALLYE_HUMANOID  = "Humanoid";
KALLYE_DEMON     = "Demon";
KALLYE_BEAST     = "Beast";
KALLYE_ELEMENTAL = "Elemental";
KALLYE_IMP       = "Imp";
KALLYE_FELHUNTER = "Felhunter";
KALLYE_DOOMGUARD = "Doomguard";

-- Classes
KALLYE_CLASSES = { ["DRUID"] = "Druid", ["HUNTER"] = "Hunter", ["MAGE"] = "Mage", ["PALADIN"] = "Paladin", ["PRIEST"] = "Priest", ["ROGUE"] = "Rogue"
                , ["SHAMAN"] = "Shaman", ["WARLOCK"] = "Warlock", ["WARRIOR"] = "Warrior", ["DEATHKNIGHT"] = "Death Knight", ["MONK"] = "Monk", ["DEMONHUNTER"] = "Demon Hunter", ["HPET"] = "Hunter Pet", ["WPET"] = "Warlock Pet"};

-- Bindings
BINDING_NAME_KALLYE_BIND_OPTIONS = "Options frame";

KALLYE_KEYS = {["L"]  = "Left",
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
KALLYE_FT_MODES           = "Keys/Modes";
KALLYE_FT_MODENORMAL      = "Norm";
KALLYE_FT_MODETARGET      = "Trgt";


-- Options frame text
KALLYE_OFT                = "Show/Hide SmartDebuff options frame";
KALLYE_OFT_HUNTERPETS     = "Hunter pets";
KALLYE_OFT_WARLOCKPETS    = "Warlock pets";
KALLYE_OFT_DEATHKNIGHTPETS= "Death Knight pets";
KALLYE_OFT_HP             = "HP";
KALLYE_OFT_MANA           = "Mana";
KALLYE_OFT_HPTEXT         = "%";
KALLYE_OFT_INVERT         = "Invert";
KALLYE_OFT_CLASSVIEW      = "Class view";
KALLYE_OFT_CLASSCOLOR     = "Class colors";
KALLYE_OFT_SHOWLR         = "L / R / M";
KALLYE_OFT_HEADERS        = "Headers";
KALLYE_OFT_GROUPNR        = "Group Nr.";
KALLYE_OFT_SOUND          = "Sound";
KALLYE_OFT_TOOLTIP        = "Tooltip";
KALLYE_OFT_TARGETMODE     = "Target mode";
KALLYE_OFT_HEALRANGE      = "Heal range";
KALLYE_OFT_SHOWAGGRO      = "Aggro";
KALLYE_OFT_VERTICAL       = "Vertical arranged";
KALLYE_OFT_VERTICALUP     = "Vertical up";
KALLYE_OFT_HEADERROW      = "Title bar";
KALLYE_OFT_BACKDROP       = "Background";
KALLYE_OFT_SHOWGRADIENT   = "Gradient";
KALLYE_OFT_INFOFRAME      = "Summary frame";
KALLYE_OFT_AUTOHIDE       = "Auto hide";
KALLYE_OFT_COLUMNS        = "Columns";
KALLYE_OFT_INTERVAL       = "Interval";
KALLYE_OFT_FONTSIZE       = "Font size";
KALLYE_OFT_WIDTH          = "Width";
KALLYE_OFT_HEIGHT         = "Height";
KALLYE_OFT_BARHEIGHT      = "Bar height";
KALLYE_OFT_OPACITYNORMAL  = "Opacity in range";
KALLYE_OFT_OPACITYOOR     = "Opacity out of range";
KALLYE_OFT_OPACITYDEBUFF  = "Opacity debuff";
KALLYE_OFT_NOTREMOVABLE   = "Debuff Guard";
KALLYE_OFT_VEHICLE        = "Vehicles";
KALLYE_OFT_SHOWRAIDICON   = "Raid icons";
KALLYE_OFT_SHOWSPELLICON  = "Spell icon";
KALLYE_OFT_INFOROW        = "Info bar";
KALLYE_OFT_GLOBALSAVE     = "Save";
KALLYE_OFT_GLOBALLOAD     = "Load";
KALLYE_OFT_ROLE           = "Role";
KALLYE_OFT_ADVANCHORS     = "Anchor Setup";
KALLYE_OFT_ICONSIZE       = "Icon size";
KALLYE_OFT_COLORSETUP     = "Color Setup";
KALLYE_OFT_SPACEX         = "Space X";
KALLYE_OFT_SPACEY         = "Space Y";
KALLYE_OFT_TESTMODE       = "Test Mode";
KALLYE_OFT_STOPCAST       = "Stop Casting";
KALLYE_OFT_IGNOREDEBUFF   = "Ignore Debuffs";
KALLYE_OFT_RESET_KEYS     = "Reset the SmartDebuff spell bindings to default?\nThis action is only necessary, if you have the feeling\nthat not all debuffs are correctly detected.";

KALLYE_AOFT_SORTBYCLASS   = "Sort by class order";
KALLYE_NRDT_TITLE         = "Unremovable Debuffs";
KALLYE_SG_TITLE           = "Spell Guard";
KALLYE_S_TITLE            = "Debuff Alert Sound";


-- Tooltip text
KALLYE_TT                 = "Shift-Left drag: Move frame\n|cff20d2ff- S button -|r\nLeft click: Show by classes\nShift-Left click: Class colors\nAlt-Left click: Highlight L/R\nRight click: Background";
KALLYE_TT_TARGETMODE      = "In target mode |cff20d2ffLeft click|r selects the unit and |cff20d2ffRight click|r casts the fastest heal spell. Use |cff20d2ffAlt-Left/Right click|r to debuff.";
KALLYE_TT_NOTREMOVABLE    = "Displays critical debuffs\nwhich are not removable.";
KALLYE_TT_HP              = "Displays actual health\npoints of the unit.";
KALLYE_TT_MANA            = "Displays actual mana\npool of the unit.";
KALLYE_TT_HPTEXT          = "Displays actual hp/mana\npool as percentage of\nthe unit as text.";
KALLYE_TT_INVERT          = "Displays health points\nand mana pool inverted.";
KALLYE_TT_CLASSVIEW       = "Displays the unit buttons\norder by class.";
KALLYE_TT_CLASSCOLOR      = "Displays the unit buttons in\ntheir corresponding class colors.";
KALLYE_TT_SHOWLR          = "Displays the corresponding\nmouse button (L/R/M), if\na unit has a debuff.";
KALLYE_TT_HEADERS         = "Displays the class name\nas header row.";
KALLYE_TT_GROUPNR         = "Displays the group number\nin front of the unit name.";
KALLYE_TT_SOUND           = "Plays a sound, if a\nunit gets a debuff.";
KALLYE_TT_TOOLTIP         = "Displays the tooltip,\nonly out of combat.";
KALLYE_TT_HEALRANGE       = "Displays a red boarder,\nif your spell is out of range.";
KALLYE_TT_SHOWAGGRO       = "Displays which\nunit has aggro.";
KALLYE_TT_VERTICAL        = "Displays the units\nvertical arranged.";
KALLYE_TT_VERTICALUP      = "Displays the units\nfrom bottom to top.";
KALLYE_TT_HEADERROW       = "Displays header row,\nincluding menu buttons.";
KALLYE_TT_BACKDROP        = "Displays a black\nbackground frame.";
KALLYE_TT_SHOWGRADIENT    = "Displays the unit buttons\nwith color gradient.";
KALLYE_TT_INFOFRAME       = "Displays the summary frame,\nonly in group or raid setup.";
KALLYE_TT_AUTOHIDE        = "Hides the unit buttons automatically,\nif you are out of combat and\nno one has a debuff.";
KALLYE_TT_VEHICLE         = "Displays in addition the vehicle of\na unit  as own button.";
KALLYE_TT_SHOWRAIDICON    = "Displays the raid icon\nof the unit.";
KALLYE_TT_SHOWSPELLICON   = "Displays the HoT icon\non the unit.";
KALLYE_TT_INFOROW         = "Displays an info bar in short style #\nPlayers/Dead/AFK/Offline\nHP/Mana\nReady check state\n(only in a raid)";
KALLYE_TT_GLOBALSAVE      = "settings to global template.";
KALLYE_TT_GLOBALLOAD      = "settings from global template.";
KALLYE_TT_ROLE            = "Displays the unit buttons\norder by role.";
KALLYE_TT_ADVANCHORS      = "Displays and uses the advanced\nanchoring setup for the debuff\nframe.";
KALLYE_TT_STOPCAST        = "Stops immediately the current\ncasting or channeling,\nto cast the defined spell.\n(Debuff spells only)";
KALLYE_TT_IGNOREDEBUFF    = "Ignores the debuff on the unit\nif your debuff spell is on cooldown";

--KALLYE_TT_COLUMNS         = "Columns";
--KALLYE_TT_INTERVAL        = "Interval";
--KALLYE_TT_FONTSIZE        = "Font size";
--KALLYE_TT_WIDTH           = "Width";
--KALLYE_TT_HEIGHT          = "Height";
--KALLYE_TT_BARHEIGHT       = "Bar height";
--KALLYE_TT_OPACITYNORMAL   = "Opacity in range";
--KALLYE_TT_OPACITYOOR      = "Opacity out of range";
--KALLYE_TT_OPACITYDEBUFF   = "Opacity debuff";

-- Tooltip text key bindings
KALLYE_TT_DROP            = "Drop";
KALLYE_TT_DROPINFO        = "Drop a spell/item/macro\nof your book/inventory.\n|cff00ff00Left click set target function.\nShift-Left set menu function";
KALLYE_TT_DROPSPELL       = "Spell click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KALLYE_TT_DROPITEM        = "Item click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KALLYE_TT_DROPMACRO       = "Macro click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KALLYE_TT_TARGET          = "Target";
KALLYE_TT_TARGETINFO      = "Selects the specified unit\nas the current target.";
KALLYE_TT_DROPTARGET      = "Mouse click:\nRight to remove";
KALLYE_TT_DROPACTION      = "Pet action:\nRemove not possible!";
KALLYE_TT_MENU            = "Menu";
KALLYE_TT_MENUINFO        = "Opens the unit options menu.";
KALLYE_TT_DROPMENU        = "Mouse click:\nRight to remove";

-- Tooltip support
KALLYE_FUBAR_TT           = "\nLeft Click: Open options\nShift-Left Click: On/Off";
KALLYE_BROKER_TT          = "Left Click: Open options\nRight Click: On/Off";

--]]--