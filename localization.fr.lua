-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------

if (GetLocale() == "frFR") then

KALLYE_SUBTITLE      = "Assistance barres de raid";
KALLYE_DESC          = "Am\195\169liore les barres de raids sur les unit\195\169s amies.\n\n - Met en \195\169vidence les joueurs en manque de soin";
KALLYE_VERS_TITLE    = format("%s %s", KALLYE_TITLE, KALLYE_VERSION);
KALLYE_OPTIONS_TITLE = format("%s - Options", KALLYE_VERS_TITLE);

-- Messages
KALLYE_MSG_LOADED         = format("%s lanc\195\169", KALLYE_VERS_TITLE);
KALLYE_MSG_SDB            = "Kallye menu d\'Options";

KALLYE_INIT_FAILED = format("%s pas charg\195\169 correctement !", KALLYE_VERS_TITLE);


KALLYE_OPTION_HIGHLIGHTLOWHP = "Raidframe: Mettre en \195\169vidence les joueurs sous 50% de PV";
KALLYE_OPTION_HIDEDAMAGEICONS = "Raidframe : Masquer l\'ic\195\180ne des dps";
KALLYE_OPTION_MOVEROLEICONS = "Raidframe : Ajuster la position l\'ic\195\180ne des tanks/heals";
KALLYE_OPTION_BUFFSSCALE = "Taille relative des d\195\169buffs";
KALLYE_OPTION_DEBUFFSSCALE = "Taille relative des buffs";
KALLYE_OPTION_MAXBUFFS = "Nombre maximum de buffs / d\195\169buffs \195\160 afficher";
KALLYE_OPTION_HIDEREALM = "Masquer le royaume des autres joueurs";
KALLYE_OPTION_FRIENDSCLASSCOLOR = "Noms color\195\169s par classe";
KALLYE_OPTION_NAMEPLATES_FRIENDSALPHAINCOMBAT = "Nameplates : Transparence des noms amis en combat";
KALLYE_OPTION_NAMEPLATES_FRIENDSALPHANOTINCOMBAT = "Nameplates : Transparence des noms amis hors combat";
KALLYE_OPTION_EXPERIMENTALREVERTBAR = "Barres de vies invers\195\169es (moins on a de vie, plus la barre grandit !) *";
KALLYE_OPTION_DEBUGRANDOMHEALTH = "Mode debug (affichage al\195\169atoire des PV)";
KALLYE_OPTION_SOLORAID = "Toujours afficher les barres de raid (m\195\170me seul) *";
KALLYE_OPTION_SHOWMSGNORMAL = "Afficher tous les messages";
KALLYE_OPTION_SHOWMSGERR = "Afficher les messages d\'erreur";
KALLYE_OPTION_SHOWMSGWARNING = "Afficher les messages d\'alerte";
KALLYE_OPTION_RELOAD_REQUIRED = "Certaines options requi\195\168rent un rechargement (\195\169crivez : /reload )";


-- https://wowwiki.fandom.com/wiki/Localizing_an_addon

-- Debuff types, in english in game!
--[[
KALLYE_DISEASE = "Maladie";
KALLYE_MAGIC   = "Magie";
KALLYE_POISON  = "Poison";
KALLYE_CURSE   = "Mal\195\169diction";
KALLYE_CHARMED = "Contr\195\180le mentale";


-- Creatures
KALLYE_HUMANOID  = "Humano\195\175de";
KALLYE_DEMON     = "D\195\169mon";
KALLYE_BEAST     = "B\195\170te";
KALLYE_ELEMENTAL = "\195\137l\195\169mentaire";
KALLYE_IMP       = "Diablotin";
KALLYE_FELHUNTER = "Chasseur corrompu";
KALLYE_DOOMGUARD = "Garde funeste";

-- Classes
KALLYE_CLASSES = { ["DRUID"] = "Druide", ["HUNTER"] = "Chasseur", ["MAGE"] = "Mage", ["PALADIN"] = "Paladin", ["PRIEST"] = "Pr\195\170tre", ["ROGUE"] = "Voleur"
                , ["SHAMAN"] = "Chaman", ["WARLOCK"] = "D\195\169moniste", ["WARRIOR"] = "Guerrier", ["DEATHKNIGHT"] = "Chevalier de la mort", ["MONK"] = "Moine", ["DEMONHUNTER"] = "Chasseur de démons", ["HPET"] = "Chasseur Pet", ["WPET"] = "D\195\169moniste Pet"};

-- Bindings
BINDING_NAME_KALLYE_BIND_OPTIONS = "Menu d\'Options";

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
KALLYE_OFT_SHOWRAIDICON   = "Raid icons"; -- NOT TRANSLATED

KALLYE_AOFT_SORTBYCLASS   = "Sort by class order";
KALLYE_NRDT_TITLE         = "Unremovable Debuffs";
KALLYE_S_TITLE            = "Debuff Alert Sound";


-- Tooltip text
KALLYE_TT                 = "Shift-Left drag: Move frame\n|cff20d2ff- S button -|r\nLeft click: Show by classes\nShift-Left click: Class colors\nAlt-Left click: Highlight L/R\nRight click: Background"; -- NOT TRANSLATED
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
KALLYE_TT_DROPINFO        = "Drop a spell/item/macro\nof your book/inventory.\n|cff00ff00Left click set target function.";
KALLYE_TT_DROPSPELL       = "Spell click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KALLYE_TT_DROPITEM        = "Item click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KALLYE_TT_DROPMACRO       = "Macro click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KALLYE_TT_TARGET          = "Target";
KALLYE_TT_TARGETINFO      = "Selects the specified unit\nas the current target.";
KALLYE_TT_DROPTARGET      = "Unit click:\nRemove";
KALLYE_TT_DROPACTION      = "Pet action:\nRemove not possible!";

-- Tooltip support
KALLYE_FUBAR_TT           = "\nLeft Click: Menu d\'options\nShift-Left Click: ON/OFF"; -- NOT TRANSLATED
KALLYE_BROKER_TT          = "\nLeft Click: Menu d\'options\nRight Click: ON/OFF"; -- NOT TRANSLATED

-- ]]--
end
