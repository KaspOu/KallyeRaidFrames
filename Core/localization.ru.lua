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

-- local required = l.YL.."*";
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

l.OPTION_RESET_OPTIONS = "Сбросить настройки";
l.OPTION_RELOAD_REQUIRED = "Некоторые изменения требуют перезагрузки (введите: "..l.YL.."/reload|r )";
l.OPTIONS_ASTERIX = l.YL.."*|r"..l.WH..": Настройки, требующие перезагрузки";
l.OPTION_SHOWMSGNORMAL = l.GYL.."Отображать сообщения";
l.OPTION_SHOWMSGWARNING = l.GYL.."Отображать предупреждения";
l.OPTION_SHOWMSGERR = l.GYL.."Отображать ошибки";
l.OPTION_WHATSNEW = "Что нового";