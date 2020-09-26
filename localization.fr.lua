-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------

if (GetLocale() == "frFR") then

KRF_SUBTITLE      = "Assistance barres de raid";
KRF_DESC          = "Am\195\169liore les barres de raids sur les unit\195\169s amies.\n\n - Met en \195\169vidence les joueurs en manque de soin";
KRF_VERS_TITLE    = format("%s %s", KRF_TITLE, KRF_VERSION);
KRF_OPTIONS_TITLE = format("%s - Options", KRF_VERS_TITLE);

-- Messages
KRF_MSG_LOADED         = format("%s lanc\195\169", KRF_VERS_TITLE);
KRF_MSG_SDB            = "Kallye menu d\'Options";

KRF_INIT_FAILED = format("%s pas charg\195\169 correctement !", KRF_VERS_TITLE);


KRF_OPTION_HIGHLIGHTLOWHP = "Mettre en \195\169vidence la perte de PV des joueurs";
KRF_OPTION_REVERTBAR = "Barres de vies invers\195\169es (moins on a de vie, plus la barre grandit !) *";
KRF_OPTION_HIDEDAMAGEICONS = "Raidframe : Masquer l\'ic\195\180ne des dps";
KRF_OPTION_MOVEROLEICONS = "Raidframe : Ajuster la position l\'ic\195\180ne des tanks/heals";
KRF_OPTION_BUFFSSCALE = "Taille relative des d\195\169buffs";
KRF_OPTION_DEBUFFSSCALE = "Taille relative des buffs";
KRF_OPTION_MAXBUFFS = "Nombre maximum de buffs / d\195\169buffs \195\160 afficher";
KRF_OPTION_HIDEREALM = "Masquer le royaume des autres joueurs";
KRF_OPTION_FRIENDSCLASSCOLOR = "Noms color\195\169s par classe";
KRF_OPTION_NAMEPLATES_FRIENDSALPHAINCOMBAT = "Nameplates : Transparence des noms amis en combat";
KRF_OPTION_NAMEPLATES_FRIENDSALPHANOTINCOMBAT = "Nameplates : Transparence des noms amis hors combat";
KRF_OPTION_DEBUGRANDOMHEALTH = "Mode debug (affichage al\195\169atoire des PV)";
KRF_OPTION_SOLORAID = "Toujours afficher les barres de raid (m\195\170me seul) *";
KRF_OPTION_SHOWMSGNORMAL = "Afficher tous les messages";
KRF_OPTION_SHOWMSGERR = "Afficher les messages d\'erreur";
KRF_OPTION_SHOWMSGWARNING = "Afficher les messages d\'alerte";
KRF_OPTION_RELOAD_REQUIRED = "Certaines options requi\195\168rent un rechargement (\195\169crivez : /reload )";
KRF_OPTION_RESET_OPTIONS = "Reset options";

-- https://wowwiki.fandom.com/wiki/Localizing_an_addon

-- Debuff types, in english in game!
--[[
KRF_DISEASE = "Maladie";
KRF_MAGIC   = "Magie";
KRF_POISON  = "Poison";
KRF_CURSE   = "Mal\195\169diction";
KRF_CHARMED = "Contr\195\180le mentale";


-- Creatures
KRF_HUMANOID  = "Humano\195\175de";
KRF_DEMON     = "D\195\169mon";
KRF_BEAST     = "B\195\170te";
KRF_ELEMENTAL = "\195\137l\195\169mentaire";
KRF_IMP       = "Diablotin";
KRF_FELHUNTER = "Chasseur corrompu";
KRF_DOOMGUARD = "Garde funeste";

-- Classes
KRF_CLASSES = { ["DRUID"] = "Druide", ["HUNTER"] = "Chasseur", ["MAGE"] = "Mage", ["PALADIN"] = "Paladin", ["PRIEST"] = "Pr\195\170tre", ["ROGUE"] = "Voleur"
                , ["SHAMAN"] = "Chaman", ["WARLOCK"] = "D\195\169moniste", ["WARRIOR"] = "Guerrier", ["DEATHKNIGHT"] = "Chevalier de la mort", ["MONK"] = "Moine", ["DEMONHUNTER"] = "Chasseur de démons", ["HPET"] = "Chasseur Pet", ["WPET"] = "D\195\169moniste Pet"};

-- Bindings
BINDING_NAME_KRF_BIND_OPTIONS = "Menu d\'Options";

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
KRF_OFT_SHOWRAIDICON   = "Raid icons"; -- NOT TRANSLATED

KRF_AOFT_SORTBYCLASS   = "Sort by class order";
KRF_NRDT_TITLE         = "Unremovable Debuffs";
KRF_S_TITLE            = "Debuff Alert Sound";


-- Tooltip text
KRF_TT                 = "Shift-Left drag: Move frame\n|cff20d2ff- S button -|r\nLeft click: Show by classes\nShift-Left click: Class colors\nAlt-Left click: Highlight L/R\nRight click: Background"; -- NOT TRANSLATED
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
KRF_TT_DROPINFO        = "Drop a spell/item/macro\nof your book/inventory.\n|cff00ff00Left click set target function.";
KRF_TT_DROPSPELL       = "Spell click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KRF_TT_DROPITEM        = "Item click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KRF_TT_DROPMACRO       = "Macro click:\nLeft to pickup\nShift-Left to clone\nRight to remove";
KRF_TT_TARGET          = "Target";
KRF_TT_TARGETINFO      = "Selects the specified unit\nas the current target.";
KRF_TT_DROPTARGET      = "Unit click:\nRemove";
KRF_TT_DROPACTION      = "Pet action:\nRemove not possible!";

-- Tooltip support
KRF_FUBAR_TT           = "\nLeft Click: Menu d\'options\nShift-Left Click: ON/OFF"; -- NOT TRANSLATED
KRF_BROKER_TT          = "\nLeft Click: Menu d\'options\nRight Click: ON/OFF"; -- NOT TRANSLATED

-- ]]--
end
