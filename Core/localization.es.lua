-------------------------------------------------------------------------------
-- Spanish localization (ChatGPT)
-------------------------------------------------------------------------------

if (GetLocale() ~= "esES") then return; end
local _, ns = ...
local l = ns.I18N;

l.VERS_TITLE    = format("%s %s", ns.TITLE, ns.VERSION);

l.CONFLICT_MESSAGE = "Desactivado: Conflicto con %s";


l.SUBTITLE      = "Asistencia de marcos de banda";
l.DESC          = "Mejora los marcos de banda.\n\n"
.." - Resalta el fondo de los jugadores con poca vida\n\n"
.." - Las barras invertidas usarán tu elección de colores\n\n"
.." - Transparencia de unidades fuera de rango\n\n"
.." - Banda siempre visible\n\n"
.."\n"
.."Mejora los beneficios / perjuicios (tamaño, máximo mostrado, ...)\n\n"
.."Colorea los nombres en la barra de información, con iconos JcJ |TInterface/PVPFrame/PVP-Currency-Alliance:16|t|TInterface/PVPFrame/PVP-Currency-Horde:16|t\n\n"
.."Muestra los iconos de objetivo (|TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t|TInterface/TargetingFrame/UI-RaidTargetingIcon_2:0|t...) en los marcos de banda\n\n"
l.OPTIONS_TITLE = format("%s - Opciones", l.VERS_TITLE);

-- Messages
l.MSG_LOADED         = format("%s iniciado", l.VERS_TITLE);
l.MSG_SDB            = "Menú de Opciones de Kallye";

l.INIT_FAILED = format("%s no se cargó correctamente!", l.VERS_TITLE);

local required = l.YL.."*";
l.OPTION_RAID_HEADER = "Grupo / Banda";
l.OPTION_HIGHLIGHTLOWHP = "Resaltar poca vida (colores dinámicos)"..required;
l.OPTION_REVERTBAR = "Barras de "..l.YL.."vida invertidas|r (cuanta menos vida, más grande es la barra!) ";
l.OPTION_HEALTH_LOW = "¡Casi muerto!";
l.OPTION_HEALTH_LOW_TOOLTIP = "El color se aplicará "..l.YLL.."POR DEBAJO|r de este límite\n\n"
    .."ej: Rojo por debajo del 25%";
l.OPTION_HEALTH_WARN = "Atención";
l.OPTION_HEALTH_WARN_TOOLTIP = "El color se aplicará "..l.YLL.."EN|r este límite\n\n"
    .."ej: Amarillo al 50%";
l.OPTION_HEALTH_OK = "Buena salud";
l.OPTION_HEALTH_OK_TOOLTIP = "El color se aplicará "..l.YLL.."POR ENCIMA|r de este límite\n\n"
    .."ej: Verde después del 75%";
l.OPTION_HEALTH_ALPHA = l.WH.."Transparencia"..required;
l.OPTION_HEALTH_ALPHA_TOOLTIP = "Transparencia de la barra de vida (con el color de clase)\n"..l.CY.."Por defecto en Wow: 100%"
l.OPTION_MOVEROLEICONS = "Icono de rol arriba a la izquierda";
l.OPTION_HIDEDAMAGEICONS = "Ocultar el icono de rol 'daño'";
l.OPTION_HIDEREALM = "Ocultar el reino de los jugadores";
l.OPTION_HIDEREALM_TOOLTIP = "Los nombres de los reinos se ocultarán, así "..l.YLL.."Illidan - Varimathras|r se convertirá en "..l.YLL.."Illidan (*)|r";
l.OPTION_ICONONDEATH = "Añadir "..l.RT8.." a los nombres de los muertos";
l.OPTION_FRIENDSCLASSCOLOR = "Nombres coloreados por clase";
l.OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Nombres de los jugadores coloreados por clase (marcos de grupo/banda)";
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR = format("Blizzard: %s", RAID_USE_CLASS_COLORS)
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR_TOOLTIP = format("%s: %s", INTERFACE_LABEL, OPTION_TOOLTIP_RAID_USE_CLASS_COLORS)
l.OPTION_BAR_TEXTURE = "Textura"
l.OPTION_BAR_TEXTURE_TOOLTIP = "Textura de la barra de vida"
l.OPTION_NOTINRANGE = "Transparencia si está fuera de rango";
l.OPTION_NOTINRANGE_TOOLTIP = l.CY.."Por defecto en Wow: 55%";
l.OPTION_NOTINCOMBAT = "Transparencia de la banda fuera de combate";
l.OPTION_NOTINCOMBAT_TOOLTIP = l.CY.."Por defecto en Wow: 100%";
l.OPTION_SOLORAID = l.CY.."Mostrar marcos de banda en modo solo "..required;
l.OPTION_SOLORAID_TOOLTIP = "Marcos de grupo/banda siempre visibles,\nactivará "..l.YLL..USE_RAID_STYLE_PARTY_FRAMES;

l.OPTION_EDITMODE_PARTY = format("Blizzard: %s", USE_RAID_STYLE_PARTY_FRAMES)
l.OPTION_EDITMODE_PARTY_TOOLTIP = "";
l.OPTION_DEBUG_ON = "¡Probar marcos de banda!";
l.OPTION_DEBUG_ON_MESSAGE = "Prueba de marcos de banda activada, ¡haz clic de nuevo para detener!";
l.OPTION_DEBUG_OFF = "¡DETENER LA PRUEBA!";
l.OPTION_DEBUG_OFF_MESSAGE = "Prueba detenida, puedes reanudar la actividad normal";

l.OPTION_ACTIVATE_MODULE = "Activar / Desactivar módulo"
l.OPTION_HIDEDISABLED = l.GYL.."Ocultar módulos desactivados"

-- KBD START
l.OPTION_BUFFS_HEADER = "Beneficios / Perjuicios"
l.OPTION_ORIENTATION_LeftThenUp = "A la izquierda, luego arriba"
l.OPTION_ORIENTATION_LeftThenUp_Default = l.DEFAULT.."A la izquierda, luego arriba (por defecto)"
l.OPTION_ORIENTATION_UpThenLeft = "Arriba, luego a la izquierda"
l.OPTION_ORIENTATION_RightThenUp = "A la derecha, luego arriba"
l.OPTION_ORIENTATION_RightThenUp_Default = l.DEFAULT.."A la derecha, luego arriba (por defecto)"
l.OPTION_ORIENTATION_UpThenRight = "Arriba, luego a la derecha"
l.OPTION_BUFFSSCALE = "Tamaño de beneficios "..required;
l.OPTION_BUFFSSCALE_TOOLTIP = l.CY.."Por defecto en Wow: 1"
l.OPTION_MAXBUFFS = "Límite de beneficios"..required;
l.OPTION_MAXBUFFS_TOOLTIP = "Número máximo de beneficios a mostrar\n"..l.CY.."Por defecto en Wow: "..ns.DEFAULT_MAXBUFFS;
l.OPTION_MAXBUFFS_FORMAT = "%d |4beneficio:beneficios";
l.OPTION_BUFFSPERLINE = "Beneficios por línea"..required;
l.OPTION_BUFFSPERLINE_TOOLTIP = "Número de beneficios por línea\n"..l.CY.."Ignorado si es superior al Límite";
l.OPTION_BUFFSPERLINE_FORMAT = "%d por línea";
l.OPTION_BUFFSORIENTATION = "Orientación de beneficios"..required;
l.OPTION_BUFFSORIENTATION_TOOLTIP = "Elige la disposición de los beneficios (soporta múltiples líneas)\n"..l.CY.."Por defecto: "..l.OPTION_ORIENTATION_LeftThenUp
l.OPTION_BUFFS_RELATIVE_X = "Posición horizontal"..required;
l.OPTION_BUFFS_RELATIVE_X_TOOLTIP = "Ajusta la posición horizontal relativa de los beneficios";
l.OPTION_BUFFS_RELATIVE_Y = "Posición vertical"..required;
l.OPTION_BUFFS_RELATIVE_Y_TOOLTIP = "Ajusta la posición vertical relativa de los beneficios";
l.OPTION_DEBUFFSSCALE = "Tamaño de perjuicios "..required;
l.OPTION_DEBUFFSSCALE_TOOLTIP = l.CY.."Por defecto en Wow: 1"
l.OPTION_MAXDEBUFFS = "Límite de perjuicios"..required;
l.OPTION_MAXDEBUFFS_TOOLTIP = "Número máximo de perjuicios a mostrar\n"..l.CY.."Por defecto en Wow: "..ns.DEFAULT_MAXBUFFS;
l.OPTION_MAXDEBUFFS_FORMAT = "%d |4perjuicio:perjuicios";
l.OPTION_DEBUFFSPERLINE = "Perjuicios por línea"..required;
l.OPTION_DEBUFFSPERLINE_TOOLTIP = "Número de iconos de perjuicio por línea\n"..l.CY.."Ignorado si es superior al Límite";
l.OPTION_DEBUFFSPERLINE_FORMAT = "%d por línea";
l.OPTION_DEBUFFSORIENTATION = "Orientación de perjuicios"..required;
l.OPTION_DEBUFFSORIENTATION_TOOLTIP = "Elige la disposición de los perjuicios (soporta múltiples líneas)\n"..l.CY.."Por defecto: "..l.OPTION_ORIENTATION_RightThenUp;
l.OPTION_DEBUFFS_RELATIVE_X = "Posición horizontal"..required;
l.OPTION_DEBUFFS_RELATIVE_X_TOOLTIP = "Ajusta la posición horizontal relativa de los perjuicios";
l.OPTION_DEBUFFS_RELATIVE_Y = "Posición vertical"..required;
l.OPTION_DEBUFFS_RELATIVE_Y_TOOLTIP = "Ajusta la posición vertical relativa de los perjuicios";
l.OPTION_USETAINTMETHOD = l.CY.."Visualización clásica del Límite de beneficios / perjuicios"..required.." "..l.ALERT
l.OPTION_USETAINTMETHOD_TOOLTIP = "Desmarcado, usa la visualización experimental\nMarcado, usa la visualización estable, pero con un "..l.RDL.."error por sesión|r, no tan grave..."
l.OPTION_BUFFS_TAINTWARNING = l.ALERT.." Cambiar el Límite provoca un "..l.RDL.."error por sesión|r, no tan grave..."
l.OPTION_BUFFS_FLICKERWARNING = l.INFO.." El reposicionamiento puede verse afectado unos segundos al morir un jefe"
l.OPTION_BUFFS_RESET = "Cancelar todo reposicionamiento"
-- KBD END

-- KNC START
l.OPTION_OTHERS_HEADER = "Barras de información";
l.OPTION_NAMEPLATES_USECOLOR_BLIZZARD = l.DEFAULT.."Por defecto";
l.OPTION_NAMEPLATES_USECOLOR_CLASS = "Colores de clase";
l.OPTION_NAMEPLATES_USECOLOR_CUSTOM = "Tu elección de color: ";
l.OPTION_NAMEPLATES_SHOWPVPICONS_BLIZZARD = l.DEFAULT.."Sin icono";
l.OPTION_NAMEPLATES_SHOWPVPICONS_FACTION = "Icono de facción |TInterface/PVPFrame/PVP-Currency-Alliance:16|t - |TInterface/PVPFrame/PVP-Currency-Horde:16|t";
l.OPTION_NAMEPLATES_COLOR_UNDER = "Color si es inferior";
l.OPTION_NAMEPLATES_COLOR_UNDER_TOOLTIP = "Selecciona el color del nivel si es inferior al tuyo";
l.OPTION_NAMEPLATES_COLOR_OVER = "Color si es superior";
l.OPTION_NAMEPLATES_COLOR_OVER_TOOLTIP = "Selecciona el color del nivel si es superior al tuyo";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER = l.DEFAULT.."Nunca";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER_TOOLTIP = "Nunca muestra el nivel en las barras de información.";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT = "Si es diferente al tuyo";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT_COLORED = "Si es diferente al tuyo, coloreado";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS = "Siempre";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS_COLORED = "Siempre, coloreado";

l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR = "Nombres aliados";
l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Color del nombre en las barras de información aliadas (fuera de instancias)";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR = "Barras aliadas";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Color de las barras de información aliadas (fuera de instancias)"
l.OPTION_FRIENDSNAMEPLATES_BAR_TEXTURE = "Textura Barras aliadas"
l.OPTION_FRIENDSNAMEPLATES_BAR_TEXTURE_TOOLTIP = "Textura de las barras de información aliadas (fuera de instancias)"
l.OPTION_FRIENDSNAMEPLATES_PVPICONS = "Iconos JcJ aliados";
l.OPTION_FRIENDSNAMEPLATES_PVPICONS_TOOLTIP = "Muestra los iconos JcJ en los nombres aliados.";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL = "Niveles aliados";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Muestra el nivel en las barras de información aliadas.";

l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR = "Nombres enemigos";
l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Color del nombre en las barras de información enemigas (fuera de instancias)";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR = "Barras enemigas";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Color de las barras de información enemigas (fuera de instancias)";
l.OPTION_ENEMIESNAMEPLATES_BAR_TEXTURE = "Textura Barras enemigas"
l.OPTION_ENEMIESNAMEPLATES_BAR_TEXTURE_TOOLTIP = "Textura de las barras de información enemigas (fuera de instancias)"
l.OPTION_ENEMIESNAMEPLATES_PVPICONS = "Iconos JcJ enemigos";
l.OPTION_ENEMIESNAMEPLATES_PVPICONS_TOOLTIP = "Muestra los iconos JcJ en los nombres enemigos.";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL = "Niveles enemigos";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Muestra el nivel en las barras de información enemigas.";
-- KNC END

l.OPTION_ACTIVATE_MODULE_RAIDICONS = l.OPTION_ACTIVATE_MODULE .. "\n"
    ..l.WH.."Muestra los iconos de objetivo (|TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t|TInterface/TargetingFrame/UI-RaidTargetingIcon_2:0|t...) en los marcos de banda"
-- KRI START
l.OPTION_RAIDICONS_HEADER = "Iconos de banda";
l.OPTION_RAIDICONS_ANCHOR = "Alineación de los iconos";
l.OPTION_RAIDICONS_ANCHOR_TOOLTIP = "Posición del icono de objetivo en el marco de banda";
l.OPTION_CENTER = "Centro"
l.OPTION_TOPLEFT = "Arriba Izquierda";
l.OPTION_TOPRIGHT = "Arriba Derecha";
l.OPTION_BOTTOMLEFT = "Abajo Izquierda";
l.OPTION_BOTTOMRIGHT = "Abajo Derecha";
l.OPTION_RAIDICONS_SIZE = "Tamaño de los iconos";
l.OPTION_RAIDICONS_SIZE_TOOLTIP = "Ajusta el tamaño de los iconos de banda";
l.OPTION_RAIDICONS_RELATIVE_X = "Posición horizontal";
l.OPTION_RAIDICONS_RELATIVE_X_TOOLTIP = "Ajusta la posición horizontal relativa de los iconos de banda";
l.OPTION_RAIDICONS_RELATIVE_Y = "Posición vertical";
l.OPTION_RAIDICONS_RELATIVE_Y_TOOLTIP = "Ajusta la posición vertical relativa de los iconos de banda";
-- KRI END

l.OPTION_RESET_OPTIONS = "Restablecer perfil";
l.OPTION_RELOAD_REQUIRED = "Algunos cambios requieren una recarga (escribe: "..l.YL.."/reload|r )";
l.OPTIONS_ASTERIX = l.YL.."*|r"..l.WH..": Opciones que requieren una recarga";

l.OPTION_SHOWMSGNORMAL = l.GYL.."Mostrar mensajes";
l.OPTION_SHOWMSGWARNING = l.GYL.."Mostrar alertas";
l.OPTION_SHOWMSGERR = l.GYL.."Mostrar errores";
l.OPTION_COMPARTMENT_FILTER = "Mostrar en el Filtro de Compartimentos";
l.OPTION_COMPARTMENT_FILTER_TOOLTIP = "En la lista de addons en la parte superior derecha";
l.OPTION_WHATSNEW = "Novedades";

--? Edit Mode - Since DragonFlight (10)
if (EditModeManagerFrame.UseRaidStylePartyFrames) then
    -- Edit mode takes a while...
    l.UpdateLocales = function ()
        C_Timer.After(1, function()
        if (not ns.CanEditActiveLayout()) then
            l.OPTION_SOLORAID_TOOLTIP = "Recuerda activar la opción "..l.YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
            l.DESC = l.DESC.."\n"..l.CY..l.OPTION_SOLORAID_TOOLTIP.."|r\n\n";
        end
        end)
    end
    l.OPTION_EDITMODE_PARTY_TOOLTIP = format("%s / %s la opción %s|r de los %s|r\n(%s|r)", ENABLE, DISABLE, l.YL..USE_RAID_STYLE_PARTY_FRAMES, l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL, l.RDD..HUD_EDIT_MODE_MENU)
    l.OPTION_EDITMODE_BTN_PARTY = HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
    l.OPTION_EDITMODE_BTN_PARTY_NOTE = "Nota: Escribe "..l.YL.."/reload|r después del "..HUD_EDIT_MODE_MENU..", para evitar cualquier error";
    l.OPTION_EDITMODE_BTN_PARTY_TOOLTIP = "Activa el "..l.YL..HUD_EDIT_MODE_MENU.."|r, y muestra directamente las opciones de "..l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r.\n\n"..l.CY..l.OPTION_EDITMODE_BTN_PARTY_NOTE.."|r";
    l.OPTION_DEBUG_ON_MESSAGE = "Prueba de marcos de banda activada (se puede probar en "..HUD_EDIT_MODE_MENU..")\n"
                    .."¡Haz clic de nuevo para detener!";
end
