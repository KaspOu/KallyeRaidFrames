-------------------------------------------------------------------------------
-- Russian localization ZamestoTV
-------------------------------------------------------------------------------
if (GetLocale() ~= "ruRU") then return end
local _, ns = ...
local l = ns.I18N;

l.VERS_TITLE    = format("%s %s", ns.TITLE, ns.VERSION);

l.CONFLICT_MESSAGE = "Отключено: Конфликт с %s";

l.SUBTITLE      = "Цель рейдовых значков";
l.DESC          = "Показывает значки целей (|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t...) на рейдовых рамках\n\n"
l.OPTIONS_TITLE = format("%s - Параметры", l.VERS_TITLE);

l.MSG_LOADED         = format("%s загружен и активен", l.VERS_TITLE);

l.INIT_FAILED = format("%s неправильно инициализирован (конфликт?)!", l.VERS_TITLE);


local required = l.YL.."*";
-- l.OPTION_RAID_HEADER = "Party / Raid";
-- l.OPTION_HIGHLIGHTLOWHP = "Highlight players HP loss (dynamic colors)";
-- l.OPTION_REVERTBAR = l.YL.."Revert|r HP bars (less life = bigger bar !) "..required;
-- l.OPTION_HEALTH_LOW = "Almost dead!";
-- l.OPTION_HEALTH_LOW_TOOLTIP = "Low health color applied "..l.YLL.."BELOW|r this limit\n\n"
--   .."i.e.: Red below 25%";
-- l.OPTION_HEALTH_WARN = "Warning";
-- l.OPTION_HEALTH_WARN_TOOLTIP = "Warn health color applied "..l.YLL.."AT|r this limit exactly\n\n"
--   .."i.e.: Yellow at 50%";
-- l.OPTION_HEALTH_OK = "Health ok";
-- l.OPTION_HEALTH_OK_TOOLTIP = "OK health color applied "..l.YLL.."AFTER|r this limit\n\n"
--   .."i.e.: Green after 75%";
-- l.OPTION_HEALTH_ALPHA = l.WH.."Health Alpha"..required;
-- l.OPTION_HEALTH_ALPHA_TOOLTIP = "Alpha of the health bar (with class colors)\n"..l.CY.."Wow default: 100%";
-- l.OPTION_MOVEROLEICONS = "Adjust role icons on top left";
-- l.OPTION_HIDEDAMAGEICONS = "Hide 'dps' role icon";
-- l.OPTION_HIDEREALM = "Hide players realm";
-- l.OPTION_HIDEREALM_TOOLTIP = "Realm names will be masked, "..l.YLL.."Illidan - Varimathras|r will become "..l.YLL.."Illidan (*)|r";
-- l.OPTION_ICONONDEATH = "Add "..l.RT8.." to dead players names";
-- l.OPTION_FRIENDSCLASSCOLOR = "Names colored by class";
-- l.OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Player names colored by class (party/raid frames)";
-- l.OPTION_BLIZZARDFRIENDSCLASSCOLOR = format("Blizzard: %s", RAID_USE_CLASS_COLORS)
-- l.OPTION_BLIZZARDFRIENDSCLASSCOLOR_TOOLTIP = format("%s: %s", INTERFACE_LABEL, OPTION_TOOLTIP_RAID_USE_CLASS_COLORS)
-- l.OPTION_NOTINRANGE = "Transparency when out of range";
-- l.OPTION_NOTINRANGE_TOOLTIP = l.CY.."Wow default: 55%";
-- l.OPTION_NOTINCOMBAT = "Raid transparency out of combat";
-- l.OPTION_NOTINCOMBAT_TOOLTIP = l.CY.."Wow default: 100%";
-- l.OPTION_SOLORAID = l.CY.."Display raid frames while solo "..required;
-- l.OPTION_SOLORAID_TOOLTIP = "Always display party/raid frames,\nwill active "..l.YLL..USE_RAID_STYLE_PARTY_FRAMES

-- l.OPTION_EDITMODE_PARTY = format("Blizzard: %s", USE_RAID_STYLE_PARTY_FRAMES)
-- l.OPTION_EDITMODE_PARTY_TOOLTIP = "";
-- l.OPTION_DEBUG_ON = "! Test raid frames !";
-- l.OPTION_DEBUG_ON_MESSAGE = "Testing party / raid frames, reclick to stop it!";
-- l.OPTION_DEBUG_OFF = "! STOP Test !";
-- l.OPTION_DEBUG_OFF_MESSAGE = "Test stopped, have fun!";

-- l.OPTION_ACTIVATE_MODULE = "Activate / Desactivate module"
-- l.OPTION_HIDEDISABLED = l.GYL.."Hide disabled modules"

-- KBD START
l.OPTION_BUFFS_HEADER = "Баффы / Дебаффы";
-- l.OPTION_ORIENTATION_LeftThenUp = "Left, then Up"
-- l.OPTION_ORIENTATION_LeftThenUp_Default = l.DEFAULT.."Left, then Up (default)"
-- l.OPTION_ORIENTATION_UpThenLeft = "Up, then Left"
-- l.OPTION_ORIENTATION_RightThenUp = "Right, then Up"
-- l.OPTION_ORIENTATION_RightThenUp_Default = l.DEFAULT.."Right, then Up (default)"
-- l.OPTION_ORIENTATION_UpThenRight = "Up, then Right"
l.OPTION_BUFFSSCALE = "Относительный размер баффов"..required;
l.OPTION_BUFFSSCALE_TOOLTIP = l.CY.."По умолчанию в WoW: 1"
l.OPTION_MAXBUFFS = "Максимум баффов"..required;
l.OPTION_MAXBUFFS_TOOLTIP = "Максимальное количество отображаемых баффов\n"..l.CY.."По умолчанию в WoW: "..ns.DEFAULT_MAXBUFFS
l.OPTION_MAXBUFFS_FORMAT = "%d |4бафф:баффа:баффов";
l.OPTION_BUFFSPERLINE = "Баффов в строке";
l.OPTION_BUFFSPERLINE_TOOLTIP = "Количество иконок баффов в строке\n"..l.CY.."По умолчанию в WoW: максимум"
l.OPTION_BUFFSPERLINE_FORMAT = "%d в строке"..required;
-- l.OPTION_BUFFSORIENTATION = "Buffs orientation"..required;
-- l.OPTION_BUFFSORIENTATION_TOOLTIP = "Choose how buffs are arranged (/w multiline support)\n"..l.CY.."Default: Left to Right, then Up"
-- l.OPTION_BUFFS_RELATIVE_X = "Horizontal position"..required;
-- l.OPTION_BUFFS_RELATIVE_X_TOOLTIP = "Adjust the relative horizontal position of the buffs";
-- l.OPTION_BUFFS_RELATIVE_Y = "Vertical position"..required;
-- l.OPTION_BUFFS_RELATIVE_Y_TOOLTIP = "Adjust the relative vertical position of the buffs";
l.OPTION_DEBUFFSSCALE = "Относительный размер дебаффов"..required;
l.OPTION_DEBUFFSSCALE_TOOLTIP = l.CY.."По умолчанию в WoW: 1"
l.OPTION_MAXDEBUFFS = "Максимум дебаффов"..required;
l.OPTION_MAXDEBUFFS_TOOLTIP = "Максимальное количество отображаемых дебаффов\n"..l.CY.."По умолчанию в WoW: "..ns.DEFAULT_MAXBUFFS
l.OPTION_MAXDEBUFFS_FORMAT = "%d |4дебафф:дебаффа:дебаффов";
l.OPTION_DEBUFFSPERLINE = "Дебаффов в строке"..required;
l.OPTION_DEBUFFSPERLINE_TOOLTIP = "Количество иконок дебаффов в строке\n"..l.CY.."По умолчанию в WoW: максимум"
l.OPTION_DEBUFFSPERLINE_FORMAT = "%d в строке";
-- l.OPTION_DEBUFFSORIENTATION = "Debuffs orientation"..required;
-- l.OPTION_DEBUFFSORIENTATION_TOOLTIP = "Choose how debuffs are arranged ((/w multiline support)\n"..l.CY.."Default: Right to Left, then Up"
-- l.OPTION_DEBUFFS_RELATIVE_X = "Horizontal position"..required;
-- l.OPTION_DEBUFFS_RELATIVE_X_TOOLTIP = "Adjust the relative horizontal position of the debuffs";
-- l.OPTION_DEBUFFS_RELATIVE_Y = "Vertical position"..required;
-- l.OPTION_DEBUFFS_RELATIVE_Y_TOOLTIP = "Adjust the relative vertical position of the debuffs";
l.OPTION_USETAINTMETHOD = l.CY.."Устаревший метод отображения для максимума баффов/дебаффов"..required.." "..l.ALERT
l.OPTION_USETAINTMETHOD_TOOLTIP = "Если не отмечено, используется экспериментальный метод отображения\nЕсли отмечено, используется стабильный метод, но с одной "..l.RDL.."ошибкой за сессию|r, не критично..."
l.OPTION_BUFFS_TAINTWARNING = l.ALERT.." Изменение максимума баффов/дебаффов вызывает одну "..l.RDL.."ошибку за сессию|r, не критично..."
l.OPTION_BUFFS_FLICKERWARNING = l.INFO.." Перепозиционирование может быть затронуто в течение нескольких секунд после убийства босса"
-- l.OPTION_BUFFS_RESET = "Cancel any repositioning"
-- KBD END

-- KNC START
l.OPTION_OTHERS_HEADER = "Таблички с именами";
l.OPTION_NAMEPLATES_USECOLOR_BLIZZARD = l.DEFAULT.."Цвета Blizzard по умолчанию";
l.OPTION_NAMEPLATES_USECOLOR_CLASS ="Использовать цвет класса";
l.OPTION_NAMEPLATES_USECOLOR_CUSTOM ="Ваш выбор цвета: ";
l.OPTION_NAMEPLATES_SHOWPVPICONS_BLIZZARD = l.DEFAULT.."Без иконки";
l.OPTION_NAMEPLATES_SHOWPVPICONS_FACTION = "Иконка фракции |TInterface/PVPFrame/PVP-Currency-Alliance:16|t - |TInterface/PVPFrame/PVP-Currency-Horde:16|t"
l.OPTION_NAMEPLATES_COLOR_UNDER = "Цвет, если ниже";
l.OPTION_NAMEPLATES_COLOR_UNDER_TOOLTIP = "Выберите цвет уровня, если он ниже вашего";
l.OPTION_NAMEPLATES_COLOR_OVER = "Цвет, если выше";
l.OPTION_NAMEPLATES_COLOR_OVER_TOOLTIP = "Выберите цвет уровня, если он выше вашего";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER = l.DEFAULT.."Никогда";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER_TOOLTIP = "Никогда не показывать уровень на информационных полосах.";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT = "Если отличается от вашего";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT_COLORED = "Если отличается от вашего, с цветом";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS = "Всегда";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS_COLORED = "Всегда, с цветом";

l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR = "Имена союзников";
l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Цвет текста имени над табличками союзников (вне подземелий)";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR = "Полосы союзников";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Цвет табличек союзников (вне подземелий)";
-- l.OPTION_FRIENDSNAMEPLATES_BAR_TEXTURE = "Allied bars texture"
-- l.OPTION_FRIENDSNAMEPLATES_BAR_TEXTURE_TOOLTIP = "Texture of allied nameplates (outside instances)"
l.OPTION_FRIENDSNAMEPLATES_PVPICONS = "PvP-иконки союзников";
l.OPTION_FRIENDSNAMEPLATES_PVPICONS_TOOLTIP = "Отображает PvP-иконки на именах союзников.";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL = "Уровень союзников";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Отображает уровень на информационных полосах союзников.";

l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR = "Имена врагов";
l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Цвет текста имени над табличками врагов (вне подземелий)";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR = "Полосы врагов";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Цвет табличек врагов (вне подземелий)";
-- l.OPTION_ENEMIESNAMEPLATES_BAR_TEXTURE = "Enemy bars texture"
-- l.OPTION_ENEMIESNAMEPLATES_BAR_TEXTURE_TOOLTIP = "Texture of enemy nameplates (outside instances)"
l.OPTION_ENEMIESNAMEPLATES_PVPICONS = "PvP-иконки врагов";
l.OPTION_ENEMIESNAMEPLATES_PVPICONS_TOOLTIP = "Отображает PvP-иконки на именах врагов.";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL = "Уровень врагов";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Отображает уровень на информационных полосах врагов.";
-- KNC END

l.OPTION_ACTIVATE_MODULE_RAIDICONS = l.OPTION_ACTIVATE_MODULE

-- KRI START
l.OPTION_RAIDICONS_HEADER = "Значки рейдов |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t";
l.OPTION_RAIDICONS_ANCHOR = "Выравнивание значков";
l.OPTION_RAIDICONS_ANCHOR_TOOLTIP = "Положение значка цели в рамке рейда";
l.OPTION_CENTER = "Центр"
l.OPTION_TOPLEFT = "Вверху слева";
l.OPTION_TOPRIGHT = "Вверху справа";
l.OPTION_BOTTOMLEFT = "Внизу слева";
l.OPTION_BOTTOMRIGHT = "Внизу справа";
l.OPTION_RAIDICONS_SIZE = "Размер значка рейда";
l.OPTION_RAIDICONS_SIZE_TOOLTIP = "Отрегулируйте размер значков рейда";
l.OPTION_RAIDICONS_RELATIVE_X = "Горизонтальное положение";
l.OPTION_RAIDICONS_RELATIVE_X_TOOLTIP = "Отрегулируйте относительное горизонтальное положение значков рейда.";
l.OPTION_RAIDICONS_RELATIVE_Y = "Вертикальное положение";
l.OPTION_RAIDICONS_RELATIVE_Y_TOOLTIP = "Отрегулируйте относительное вертикальное положение значков рейда.";
-- KRI END

l.OPTION_RESET_OPTIONS = "Сбросить настройки";
l.OPTION_RELOAD_REQUIRED = "Некоторые изменения требуют перезагрузки (введите: "..l.YL.."/reload|r )";
l.OPTIONS_ASTERIX = l.YL.."*|r"..l.WH..": Настройки, требующие перезагрузки";

l.OPTION_SHOWMSGNORMAL = l.GYL.."Отображать сообщения";
l.OPTION_SHOWMSGWARNING = l.GYL.."Отображать предупреждения";
l.OPTION_SHOWMSGERR = l.GYL.."Отображать ошибки";
l.OPTION_WHATSNEW = "Что нового";