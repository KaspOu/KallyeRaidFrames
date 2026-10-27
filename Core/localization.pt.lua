-------------------------------------------------------------------------------
-- Portuguese localization (ChatGPT)
-------------------------------------------------------------------------------

local _, ns = ...
local l = ns.I18N;
if _G[ns.OPTIONS_NAME] and _G[ns.OPTIONS_NAME].ForceEnglish then return end

l.VERS_TITLE    = format("%s %s", ns.TITLE, ns.VERSION);

l.CONFLICT_MESSAGE = "Desativado: Conflito com %s";


l.WHATSNEW = l.YL..l.VERS_TITLE.." -"..l.YLL..l.WHATSNEW;

l.SUBTITLE      = "Assistência de quadros de raide";
l.DESC          = "Melhora os quadros de raide.\n\n"
.." - Destaca o fundo de jogadores com pouca vida\n\n"
.." - Barras invertidas usarão sua escolha de cores\n\n"
.." - Transparência de unidades fora de alcance\n\n"
.." - Raide sempre visível\n\n"
.."\n"
.."Melhora os búfes / debufes (tamanho, máximo exibido, ...)\n\n"
.."Coloriza os nomes na barra de informaçöes, com îcones JxJ |TInterface/PVPFrame/PVP-Currency-Alliance:16|t|TInterface/PVPFrame/PVP-Currency-Horde:16|t\n\n"
.."Exibe os îcones de alvo (|TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t|TInterface/TargetingFrame/UI-RaidTargetingIcon_2:0|t...) nos quadros de raide\n\n"
l.OPTIONS_TITLE = format("%s - Opçöes", l.VERS_TITLE);

-- Messages
l.MSG_LOADED         = format("%s carregado", l.VERS_TITLE);
l.MSG_SDB            = "Kallye menu de Opçöes";

l.INIT_FAILED = format("%s não carregado corretamente!", l.VERS_TITLE);

local required = l.YL.."*";
l.OPTION_RAID_HEADER = "Grupo / Raide";
l.OPTION_HIGHLIGHTLOWHP = "Destacar pouca vida (cores dinâmicas)"..required;
l.OPTION_REVERTBAR = "Barras de "..l.YL.."vida invertidas|r (quanto menos vida, maior a barra!) ";
l.OPTION_HEALTH_LOW = "Quase morto!";
l.OPTION_HEALTH_LOW_TOOLTIP = "A cor será aplicada "..l.YLL.."ABAIXO|r deste limite\n\n"
    .."ex: Vermelho abaixo de 25%";
l.OPTION_HEALTH_WARN = "Atenção";
l.OPTION_HEALTH_WARN_TOOLTIP = "A cor será aplicada "..l.YLL.."NESTE|r limite\n\n"
    .."ex: Amarelo em 50%";
l.OPTION_HEALTH_OK = "Boa saúde";
l.OPTION_HEALTH_OK_TOOLTIP = "A cor será aplicada "..l.YLL.."ACIMA|r deste limite\n\n"
    .."ex: Verde apôs 75%";
l.OPTION_HEALTH_ALPHA = l.WH.."Transparência"..required;
l.OPTION_HEALTH_ALPHA_TOOLTIP = "Transparência da barra de vida (com a cor da classe)\n"..l.CY.."Padrão no Wow: 100%"
l.OPTION_MOVEROLEICONS = "îcone de função no canto superior esquerdo";
l.OPTION_HIDEDAMAGEICONS = "Ocultar o îcone de função 'dano'";
l.OPTION_HIDEREALM = "Ocultar o reino dos jogadores";
l.OPTION_HIDEREALM_TOOLTIP = "Os nomes dos reinos serão ocultados, assim "..l.YLL.."Illidan - Varimathras|r se tornará "..l.YLL.."Illidan (*)|r";
l.OPTION_ICONONDEATH = "Adicionar "..l.RT8.." aos nomes dos mortos";
l.OPTION_FRIENDSCLASSCOLOR = "Nomes coloridos por classe";
l.OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Nomes dos jogadores coloridos por classe (quadros de grupo/raide)";
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR = format("Blizzard : %s", RAID_USE_CLASS_COLORS)
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR_TOOLTIP = format("%s : %s", INTERFACE_LABEL, OPTION_TOOLTIP_RAID_USE_CLASS_COLORS)
l.OPTION_BAR_TEXTURE = "Textura"
l.OPTION_BAR_TEXTURE_TOOLTIP = "Textura da barra de vida"
l.OPTION_SOLORAID = l.CY.."Exibe os quadros de raide em modo solo "..required;
l.OPTION_SOLORAID_TOOLTIP = "Quadros de grupo/raide sempre visíveis,\nativará "..l.YLL..USE_RAID_STYLE_PARTY_FRAMES;

l.OPTION_EDITMODE_PARTY = format("Blizzard : %s", USE_RAID_STYLE_PARTY_FRAMES)
l.OPTION_EDITMODE_PARTY_TOOLTIP = "";
l.OPTION_DEBUG_ON = "! Testar os quadros de raide !";
l.OPTION_DEBUG_ON_MESSAGE = "Teste dos quadros de raide ativado, clique novamente para parar!";
l.OPTION_DEBUG_OFF = "! PARAR O TESTE !";
l.OPTION_DEBUG_OFF_MESSAGE = "Teste parado, você pode retomar a atividade normal";

l.OPTION_ACTIVATE_MODULE = "Ativar / Desativar o múdulo"
l.OPTION_HIDEDISABLED = l.GYL.."Ocultar múdulos desativados"

-- KF START
l.OPTION_INRANGE = "Transparência quando em alcance";
l.OPTION_INRANGE_TOOLTIP = l.CY.."Padrão no Wow: 100%";
l.OPTION_NOTINRANGE = "Transparência se fora de alcance";
l.OPTION_NOTINRANGE_TOOLTIP = l.CY.."Padrão no Wow: "..l.DEFAULT_ALPHA_OUTOFRANGE.."%";
l.OPTION_NOTINCOMBAT = "Transparência do raide fora de combate";
l.OPTION_NOTINCOMBAT_TOOLTIP = l.CY.."Padrão no Wow: 100%";
l.OPTION_ALPHADISPELOVERLAY = "Transparência do Overlay de Dissipação"
l.OPTION_ALPHADISPELOVERLAY_TOOLTIP = l.OPTION_NOTINCOMBAT_TOOLTIP
-- KF END

l.OPTION_ACTIVATE_MODULE_DEBUFFS = l.OPTION_ACTIVATE_MODULE .. "\n"
  .. ( ns.LoadRaidFramesAuras and "\n"..l.WH.."Os búfes/debuffs da Blizzard serão substituídos por RaidFrameAuras" or "")
-- KBD START
l.OPTION_BUFFS_HEADER = "Debufes / Búfes"
l.OPTION_ORIENTATION_LeftThenUp = "À Esquerda, depois para Cima"
l.OPTION_ORIENTATION_LeftThenUp_Default = l.DEFAULT.."À Esquerda, depois para Cima (padrão)"
l.OPTION_ORIENTATION_UpThenLeft = "Para Cima, depois À Esquerda"
l.OPTION_ORIENTATION_RightThenUp = "À Direita, depois para Cima"
l.OPTION_ORIENTATION_RightThenUp_Default = l.DEFAULT.."À Direita, depois para Cima (padrão)"
l.OPTION_ORIENTATION_UpThenRight = "Para Cima, depois À Direita"
l.OPTION_BUFFSSCALE = "Tamanho dos búfes ";
l.OPTION_BUFFSSCALE_TOOLTIP = l.CY.."Padrão no Wow: 1"
l.OPTION_MAXBUFFS = "Limite de búfes";
l.OPTION_MAXBUFFS_TOOLTIP = "Número máximo de búfes a exibir\n"..l.CY.."Padrão no Wow: "..ns.DEFAULT_MAXBUFFS;
l.OPTION_MAXBUFFS_FORMAT = "%d |4búfe:búfes";
l.OPTION_BUFFSPERLINE = "Búfes por linha";
l.OPTION_BUFFSPERLINE_TOOLTIP = "Número de búfes por linha\n"..l.CY.."Ignorado se superior ao Limite";
l.OPTION_BUFFSPERLINE_FORMAT = "%d por linha";
l.OPTION_BUFFSORIENTATION = "Orientação dos búfes";
l.OPTION_BUFFSORIENTATION_TOOLTIP = "Escolha o arranjo dos búfes (suporta múltiplas linhas)\n"..l.CY.."Padrão: "..l.OPTION_ORIENTATION_LeftThenUp
l.OPTION_BUFFS_RELATIVE_X = "Posição horizontal";
l.OPTION_BUFFS_RELATIVE_X_TOOLTIP = "Ajuste a posição horizontal relativa dos búfes";
l.OPTION_BUFFS_RELATIVE_Y = "Posição vertical";
l.OPTION_BUFFS_RELATIVE_Y_TOOLTIP = "Ajuste a posição vertical relativa dos búfes";
l.OPTION_DEBUFFSSCALE = "Tamanho dos debufes ";
l.OPTION_DEBUFFSSCALE_TOOLTIP = l.CY.."Padrão no Wow: 1"
l.OPTION_MAXDEBUFFS = "Limite de debufes";
l.OPTION_MAXDEBUFFS_TOOLTIP = "Número máximo de debufes a exibir\n"..l.CY.."Padrão no Wow: "..ns.DEFAULT_MAXDEBUFFS;
l.OPTION_MAXDEBUFFS_FORMAT = "%d |4debufe:debufes";
l.OPTION_DEBUFFSPERLINE = "Debufes por linha";
l.OPTION_DEBUFFSPERLINE_TOOLTIP = "Número de îcones de debufe por linha\n"..l.CY.."Ignorado se superior ao Limite";
l.OPTION_DEBUFFSPERLINE_FORMAT = "%d por linha";
l.OPTION_DEBUFFSORIENTATION = "Orientação dos debufes";
l.OPTION_DEBUFFSORIENTATION_TOOLTIP = "Escolha o arranjo dos debufes (suporta múltiplas linhas)\n"..l.CY.."Padrão: "..l.OPTION_ORIENTATION_RightThenUp;
l.OPTION_DEBUFFS_RELATIVE_X = "Posição horizontal";
l.OPTION_DEBUFFS_RELATIVE_X_TOOLTIP = "Ajuste a posição horizontal relativa dos debufes";
l.OPTION_DEBUFFS_RELATIVE_Y = "Posição vertical";
l.OPTION_DEBUFFS_RELATIVE_Y_TOOLTIP = "Ajuste a posição vertical relativa dos debufes";
l.OPTION_BUFFS_HIDEBLIZZARDAURAS = " Ocultar auras da Blizzard"
l.OPTION_BUFFS_RESET = "Cancelar reposicionamento"
l.OPTION_FILTER_AUTO_DEFAULT = l.DEFAULT.."Auto — acompanha o combate (padrão)";
l.OPTION_FILTER_RAID = "Sempre a lista fora de combate";
l.OPTION_FILTER_RAID_IN_COMBAT = "Sempre a lista em combate";
l.OPTION_BUFFS_SPACING_X = "Espaçamento horizontal";
l.OPTION_BUFFS_SPACING_X_TOOLTIP = "Espaço horizontal, em pixels, entre os ícones de bônus\n"..l.CY.."Padrão: 0";
l.OPTION_BUFFS_SPACING_Y = "Espaçamento vertical";
l.OPTION_BUFFS_SPACING_Y_TOOLTIP = "Espaço vertical, em pixels, entre os ícones de bônus\n"..l.CY.."Padrão: 1";
l.OPTION_BUFFSFILTER = "Filtro de bônus";
l.OPTION_BUFFSFILTER_TOOLTIP = "Qual lista de bônus a Blizzard fornece\n"..l.CY.."Auto alterna ao entrar e sair de combate";
l.OPTION_BUFFS_HIDETOOLTIP = "Ocultar dicas dos bônus"..required;
l.OPTION_BUFFS_HIDETOOLTIP_TOOLTIP = "Sem dica ao passar o cursor sobre um ícone de bônus\n"..l.RDL.."Também desativa o clique direito para cancelar um bônus";
l.OPTION_BUFFS_EXCLUDED = "Buffs ignorados";
l.OPTION_BUFFS_EXCLUDED_TITLE = "Buffs que não serão exibidos";
l.OPTION_BUFFS_EXCLUDED_PLACEHOLDER = "Nome do feitiço ou ID do feitiço";
l.OPTION_DEBUFFS_SPACING_X = "Espaçamento horizontal";
l.OPTION_DEBUFFS_SPACING_X_TOOLTIP = "Espaço horizontal, em pixels, entre os ícones de penalidades\n"..l.CY.."Padrão: 0";
l.OPTION_DEBUFFS_SPACING_Y = "Espaçamento vertical";
l.OPTION_DEBUFFS_SPACING_Y_TOOLTIP = "Espaço vertical, em pixels, entre os ícones de penalidades\n"..l.CY.."Padrão: 1";
l.OPTION_DEBUFFSFILTER = "Filtro de penalidades";
l.OPTION_DEBUFFSFILTER_TOOLTIP = "Qual lista de penalidades a Blizzard fornece\n"..l.CY.."Auto alterna ao entrar e sair de combate";
l.OPTION_DEBUFFS_HIDETOOLTIP = "Ocultar dicas das penalidades"..required;
l.OPTION_DEBUFFS_HIDETOOLTIP_TOOLTIP = "Sem dica ao passar o cursor sobre um ícone de penalidade\n"..l.RDL.."Também desativa o clique direito para cancelar uma penalidade";
-- KBD END

-- KNC START
l.OPTION_OTHERS_HEADER = "Barras de informaçöes";
l.OPTION_NAMEPLATES_USECOLOR_BLIZZARD = l.DEFAULT.."Padrão";
l.OPTION_NAMEPLATES_USECOLOR_CLASS = "Cores de classe";
l.OPTION_NAMEPLATES_USECOLOR_CUSTOM = "Sua escolha de cor: ";
l.OPTION_NAMEPLATES_SHOWPVPICONS_BLIZZARD = l.DEFAULT.."Sem îcone";
l.OPTION_NAMEPLATES_SHOWPVPICONS_FACTION = "îcone de facção |TInterface/PVPFrame/PVP-Currency-Alliance:16|t - |TInterface/PVPFrame/PVP-Currency-Horde:16|t";
l.OPTION_NAMEPLATES_COLOR_UNDER = "Cor se inferior";
l.OPTION_NAMEPLATES_COLOR_UNDER_TOOLTIP = "Selecione a cor do nível se for inferior ao seu";
l.OPTION_NAMEPLATES_COLOR_OVER = "Cor se superior";
l.OPTION_NAMEPLATES_COLOR_OVER_TOOLTIP = "Selecione a cor do nível se for superior ao seu";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER = l.DEFAULT.."Nunca";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER_TOOLTIP = "Nunca mostra o nível nas barras de informaçöes.";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT = "Se diferente do seu";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT_COLORED = "Se diferente do seu, colorido";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS = "Sempre";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS_COLORED = "Sempre, colorido";

l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR = "Nomes aliados";
l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Cor do nome nas barras de informaçöes aliadas (fora de instâncias)";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR = "Barras aliadas";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Cor das barras de informaçöes aliadas (fora de instâncias)"
l.OPTION_FRIENDSNAMEPLATES_BAR_TEXTURE = "Textura Barras aliadas"
l.OPTION_FRIENDSNAMEPLATES_BAR_TEXTURE_TOOLTIP = "Textura das barras de informaçöes aliadas (fora de instâncias)"
l.OPTION_FRIENDSNAMEPLATES_PVPICONS = "îcones JxJ aliados";
l.OPTION_FRIENDSNAMEPLATES_PVPICONS_TOOLTIP = "Exibe os îcones JxJ nos nomes aliados.";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL = "Níveis aliados";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Exibe o nível nas barras de informaçöes aliadas.";

l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR = "Nomes inimigos";
l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Cor do nome nas barras de informaçöes inimigas (fora de instâncias)";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR = "Barras inimigas";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Cor das barras de informaçöes inimigas (fora de instâncias)";
l.OPTION_ENEMIESNAMEPLATES_BAR_TEXTURE = "Textura Barras inimigas"
l.OPTION_ENEMIESNAMEPLATES_BAR_TEXTURE_TOOLTIP = "Textura das barras de informaçöes inimigas (fora de instâncias)"
l.OPTION_ENEMIESNAMEPLATES_PVPICONS = "îcones JxJ inimigos";
l.OPTION_ENEMIESNAMEPLATES_PVPICONS_TOOLTIP = "Exibe os îcones JxJ nos nomes inimigos.";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL = "Níveis inimigos";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Exibe o nível nas barras de informaçöes inimigas.";
-- KNC END

l.OPTION_ACTIVATE_MODULE_RAIDICONS = l.OPTION_ACTIVATE_MODULE .. "\n"
    ..l.WH.."Exibe os îcones de alvo (|TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t|TInterface/TargetingFrame/UI-RaidTargetingIcon_2:0|t...) nos quadros de raide"
-- KRI START
l.OPTION_RAIDICONS_HEADER = "îcones de raide";
l.OPTION_RAIDICONS_ANCHOR = "Alinhamento dos îcones";
l.OPTION_RAIDICONS_ANCHOR_TOOLTIP = "Posição do îcone de alvo no quadro de raide";
l.OPTION_CENTER = "Centro"
l.OPTION_TOPLEFT = "Superior Esquerdo";
l.OPTION_TOPRIGHT = "Superior Direito";
l.OPTION_BOTTOMLEFT = "Inferior Esquerdo";
l.OPTION_BOTTOMRIGHT = "Inferior Direito";
l.OPTION_RAIDICONS_SIZE = "Tamanho dos îcones";
l.OPTION_RAIDICONS_SIZE_TOOLTIP = "Ajuste o tamanho dos îcones de raide";
l.OPTION_RAIDICONS_RELATIVE_X = "Posição horizontal";
l.OPTION_RAIDICONS_RELATIVE_X_TOOLTIP = "Ajuste a posição horizontal relativa dos îcones de raide";
l.OPTION_RAIDICONS_RELATIVE_Y = "Posição vertical";
l.OPTION_RAIDICONS_RELATIVE_Y_TOOLTIP = "Ajuste a posição vertical relativa dos îcones de raide";
-- KRI END

l.OPTION_RESET_OPTIONS = "Redefinir o perfil";
l.OPTION_RELOAD_REQUIRED = "Algumas alteraçöes exigem um recarregamento (digite: "..l.YL.."/reload|r )";
l.OPTIONS_ASTERIX = l.YL.."*|r"..l.WH..": Opçöes que exigem um recarregamento";

l.OPTION_SHOWMSGNORMAL = l.GYL.."Exibir mensagens";
l.OPTION_SHOWMSGWARNING = l.GYL.."Exibir alertas";
l.OPTION_SHOWMSGERR = l.GYL.."Exibir erros";
l.OPTION_COMPARTMENT_FILTER = "Compartimento de addons"..required;
l.OPTION_COMPARTMENT_FILTER_TOOLTIP = "Exibir no compartimento de addons (canto superior direito)";
l.OPTION_WHATSNEW = "Novidades";

--? Edit Mode - Since DragonFlight (10)
if (EditModeManagerFrame.UseRaidStylePartyFrames) then
    -- Edit mode takes a while...
    l.UpdateLocales = function ()
        C_Timer.After(1, function()
        if (not ns.CanEditActiveLayout()) then
            l.OPTION_SOLORAID_TOOLTIP = "Lembre-se de ativar a opção "..l.YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
            l.DESC = l.DESC.."\n"..l.CY..l.OPTION_SOLORAID_TOOLTIP.."|r\n\n";
        end
        end)
    end
    l.OPTION_SOLORAID = l.CY.."Exibir quadros do grupo enquanto solo "..required;
    l.OPTION_SOLORAID_GROUPINRAID = "Mostrar também os quadros do grupo em raide"..required
    l.OPTION_SOLORAID_GROUPINRAID_TOOLTIP = "Mostrar tanto os quadros do grupo quanto os de raide (enquanto em raide)"
    l.OPTION_EDITMODE_PARTY_TOOLTIP = format("%s / %s a opção %s|r dos %s|r\n(%s|r)", ENABLE, DISABLE, l.YL..USE_RAID_STYLE_PARTY_FRAMES, l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL, l.RDD..HUD_EDIT_MODE_MENU)
    l.OPTION_EDITMODE_BTN_PARTY = HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
    l.OPTION_EDITMODE_BTN_PARTY_NOTE = "Nota: Digite "..l.YL.."/reload|r apôs o "..HUD_EDIT_MODE_MENU..", para evitar qualquer erro";
    l.OPTION_EDITMODE_BTN_PARTY_TOOLTIP = "Ativa o "..l.YL..HUD_EDIT_MODE_MENU.."|r, e exibe diretamente as opçöes de "..l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r.\n\n"..l.CY..l.OPTION_EDITMODE_BTN_PARTY_NOTE.."|r";
    l.OPTION_DEBUG_ON_MESSAGE = "Teste dos quadros de raide ativado (testável em "..HUD_EDIT_MODE_MENU..")\n"
                    .."Clique novamente para parar!";
end
