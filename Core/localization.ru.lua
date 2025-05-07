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


-- KBD START
l.OPTION_BUFFS_HEADER = "Баффы / Дебаффы";
l.OPTION_BUFFSSCALE = "Относительный размер баффов"..required;
l.OPTION_BUFFSSCALE_TOOLTIP = l.CY.."По умолчанию в WoW: 1"
l.OPTION_MAXBUFFS = "Максимум баффов"..required;
l.OPTION_MAXBUFFS_TOOLTIP = "Максимальное количество отображаемых баффов\n"..l.CY.."По умолчанию в WoW: "..ns.DEFAULT_MAXBUFFS
l.OPTION_MAXBUFFS_FORMAT = "%d |4бафф:баффа:баффов";
l.OPTION_BUFFSPERLINE = "Баффов в строке";
l.OPTION_BUFFSPERLINE_TOOLTIP = "Количество иконок баффов в строке\n"..l.CY.."По умолчанию в WoW: максимум"
l.OPTION_BUFFSPERLINE_FORMAT = "%d в строке"..required;
l.OPTION_BUFFSVERTICAL = "Вертикальное выравнивание баффов"..required;
l.OPTION_BUFFSVERTICAL_TOOLTIP = "Баффы будут выровнены вертикально,\nв столбцах\n"..l.CY.."Может быть отключено через несколько секунд после убийства босса"
l.OPTION_DEBUFFSSCALE = "Относительный размер дебаффов"..required;
l.OPTION_DEBUFFSSCALE_TOOLTIP = l.CY.."По умолчанию в WoW: 1"
l.OPTION_MAXDEBUFFS = "Максимум дебаффов"..required;
l.OPTION_MAXDEBUFFS_TOOLTIP = "Максимальное количество отображаемых дебаффов\n"..l.CY.."По умолчанию в WoW: "..ns.DEFAULT_MAXBUFFS
l.OPTION_MAXDEBUFFS_FORMAT = "%d |4дебафф:дебаффа:дебаффов";
l.OPTION_DEBUFFSPERLINE = "Дебаффов в строке"..required;
l.OPTION_DEBUFFSPERLINE_TOOLTIP = "Количество иконок дебаффов в строке\n"..l.CY.."По умолчанию в WoW: максимум"
l.OPTION_DEBUFFSPERLINE_FORMAT = "%d в строке";
l.OPTION_DEBUFFSVERTICAL = "Вертикальное выравнивание дебаффов"..required;
l.OPTION_DEBUFFSVERTICAL_TOOLTIP = "Дебаффы будут выровнены вертикально,\nв столбцах\n"..l.CY.."Может быть отключено через несколько секунд после убийства босса"
l.OPTION_USETAINTMETHOD = l.CY.."Устаревший метод отображения для максимума баффов/дебаффов"..required.." "..l.ALERT
l.OPTION_USETAINTMETHOD_TOOLTIP = "Если не отмечено, используется экспериментальный метод отображения\nЕсли отмечено, используется стабильный метод, но с одной "..l.RDL.."ошибкой за сессию|r, не критично..."
l.OPTION_BUFFS_TAINTWARNING = l.ALERT.." Изменение максимума баффов/дебаффов вызывает одну "..l.RDL.."ошибку за сессию|r, не критично..."
l.OPTION_BUFFS_FLICKERWARNING = l.INFO.." Перепозиционирование может быть затронуто в течение нескольких секунд после убийства босса"
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
l.OPTION_FRIENDSNAMEPLATES_PVPICONS = "PvP-иконки союзников";
l.OPTION_FRIENDSNAMEPLATES_PVPICONS_TOOLTIP = "Отображает PvP-иконки на именах союзников.";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL = "Уровень союзников";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Отображает уровень на информационных полосах союзников.";

l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR = "Имена врагов";
l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Цвет текста имени над табличками врагов (вне подземелий)";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR = "Полосы врагов";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Цвет табличек врагов (вне подземелий)";
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