-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------

if (GetLocale() == "frFR") then

KRF_VERS_TITLE    = format("%s %s", KRF_TITLE, KRF_VERSION);

-- Whats new info
KRF_WHATSNEW = " Nouveaut\195\169s :\n"
    .."- Ajout de l'option de coloration des barres de noms ennemies.\n"
    .."- Versions |cffff1111Wow Classic|r & |cffc16600Cata|r !\n"
    ;
KRF_WHATSNEW = YL..KRF_VERS_TITLE.." -"..YLL..KRF_WHATSNEW;

KRF_SUBTITLE      = "Assistance cadres de raid";
KRF_DESC          = "Am\195\169liore les cadres de raid.\n\n"
.." - Met en \195\169vidence le fond des joueurs en manque de vie\n\n"
.." - Les barres invers\195\169es utiliseront votre choix de couleurs\n\n"
.." - Transparence des unit\195\169s hors de port\195\169e";
KRF_OPTIONS_TITLE = format("%s - Options", KRF_VERS_TITLE);

-- Messages
KRF_MSG_LOADED         = format("%s lanc\195\169", KRF_VERS_TITLE);
KRF_MSG_SDB            = "Kallye menu d\'Options";

KRF_INIT_FAILED = format("%s pas charg\195\169 correctement !", KRF_VERS_TITLE);


KRF_OPTION_RAID_HEADER = "Groupe / Raid";
KRF_OPTION_HIGHLIGHTLOWHP = "Mettre en \195\169vidence le manque de vie (couleurs dynamiques)"..YL.."*";
KRF_OPTION_REVERTBAR = "Barres de "..YL.."vies invers\195\169es|r (moins on a de vie, plus la barre grandit !) ";
KRF_OPTION_HEALTH_LOW = "Presque mort !";
KRF_OPTION_HEALTH_LOW_TOOLTIP = "La couleur sera appliqu\195\169e "..YLL.."SOUS|r cette limite\n\n"
    .."ex : Rouge sous 25%";
KRF_OPTION_HEALTH_WARN = "Attention";
KRF_OPTION_HEALTH_WARN_TOOLTIP = "La couleur sera appliqu\195\169e "..YLL.."\195\128|r cette limite\n\n"
    .."ex : Jaune \195\160 50%";
KRF_OPTION_HEALTH_OK = "Bonne sant\195\169";
KRF_OPTION_HEALTH_OK_TOOLTIP = "La couleur sera appliqu\195\169e "..YLL.."AU-DESSUS|r DE cette limite\n\n"
    .."ex : Vert apr\195\170s 75%";
KRF_OPTION_MOVEROLEICONS = "Ic\195\180ne de r\195\180le en haut \195\160 gauche";
KRF_OPTION_HIDEDAMAGEICONS = "Masquer l\'ic\195\180ne de r\195\180le 'd\195\169g\195\160ts'";
KRF_OPTION_HIDEREALM = "Masquer le royaume des joueurs";
KRF_OPTION_HIDEREALM_TOOLTIP = "Les noms de royaumes seront masqu\195\169s, ainsi "..YLL.."Illidan - Varimathras|r deviendra "..YLL.."Illidan (*)|r";
KRF_OPTION_ICONONDEATH = "Ajouter "..RT8.." aux noms des morts";
KRF_OPTION_FRIENDSCLASSCOLOR = "Noms color\195\169s par classe";
KRF_OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Am\195\169liore la couleur des cadres des joueurs d'apr\195\168s leur classe";
KRF_OPTION_NOTINRANGE = "Transparence si hors de port\195\169e";
KRF_OPTION_NOTINRANGE_TOOLTIP = "Par d\195\169faut dans Wow : 55%";
KRF_OPTION_NOTINCOMBAT = "Transparence du raid hors de combat";
KRF_OPTION_NOTINCOMBAT_TOOLTIP = "Par d\195\169faut dans Wow : 100%";
KRF_OPTION_SOLORAID = CY.."Affiche les cadres de raid en mode solo "..YL.."*";
KRF_OPTION_SOLORAID_TOOLTIP = "Cadres de groupe/raid toujours visibles";

KRF_OPTION_EDITMODE_PARTY = "#";
KRF_OPTION_EDITMODE_PARTY_NOTE = "Note : Tapez "..YL.."/reload|r apr\195\168s pour \195\169viter les erreurs qui suivraient";
KRF_OPTION_EDITMODE_PARTY_TOOLTIP = "#";
KRF_OPTION_DEBUG_ON = "! Tester les cadres de raid !";
KRF_OPTION_DEBUG_ON_MESSAGE = "Test des cadres de raid activ\195\169, recliquez pour stopper !";
KRF_OPTION_DEBUG_OFF = "! ARR\195\138TER LE TEST !";
KRF_OPTION_DEBUG_OFF_MESSAGE = "Test arr\195\170t\195\169, vous pouvez reprendre une activit\195\169 normale";

KRF_OPTION_BUFFS_HEADER = "Buffs / Debuffs";
KRF_OPTION_BUFFSSCALE = "Taille des buffs "..YL.."*";
KRF_OPTION_BUFFSSCALE_TOOLTIP = "Laissez \195\160 1 en cas de conflit d'addon";
KRF_OPTION_DEBUFFSSCALE = "Taille des d\195\169buffs "..YL.."*";
KRF_OPTION_DEBUFFSSCALE_TOOLTIP = "Laissez \195\160 1 en cas de conflit d'addon";
KRF_OPTION_MAXBUFFS = "Afficher maximum";
KRF_OPTION_MAXBUFFS_TOOLTIP = "Nombre maximum de buffs \195\160 afficher";
KRF_OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";

KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES = "Barre d'info des unit\195\169s color\195\169e par classe (hors instances)";
KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES_TOOLTIP = "Colore le nom du joueur (sur la t\195\170te) d'apr\195\168s sa classe (ne fonctionne pas en instance)";
KRF_OPTION_ENEMIESCLASSCOLOR_NAMEPLATES = "Activer pour les ennemis";
KRF_OPTION_ENEMIESCLASSCOLOR_NAMEPLATES_TOOLTIP = KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES_TOOLTIP;

KRF_OPTION_RESET_OPTIONS = "R\195\169initialiser le profil";
KRF_OPTION_RELOAD_REQUIRED = "Certains changements n\195\169cessitent un rechargement (\195\169crivez : "..YL.."/reload|r )";

KRF_OPTION_SHOWMSGNORMAL = GYL.."Afficher les messages";
KRF_OPTION_SHOWMSGWARNING = GYL.."Afficher les alertes";
KRF_OPTION_SHOWMSGERR = GYL.."Afficher les erreurs";
KRF_OPTION_WHATSNEW = "Nouveaut\195\169s";

-- Edit Mode - Since DragonFlight (10)
if (EditModeManagerFrame.UseRaidStylePartyFrames) then
    if (not EditModeManagerFrame:UseRaidStylePartyFrames()) then
        KRF_OPTION_SOLORAID_TOOLTIP = "Pensez \195\160 activer l'option "..YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
        KRF_DESC = KRF_DESC.."\n\n - "..KRF_OPTION_SOLORAID_TOOLTIP;
    end
    KRF_OPTION_EDITMODE_PARTY = HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
    KRF_OPTION_EDITMODE_PARTY_TOOLTIP = "Active le "..YL..HUD_EDIT_MODE_MENU.."|r, et affiche directement les options de "..YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r.\n\n"..CY..KRF_OPTION_EDITMODE_PARTY_NOTE.."|r";
    KRF_OPTION_DEBUG_ON_MESSAGE = "Test des cadres de raid activ\195\169 (testable en "..HUD_EDIT_MODE_MENU..")\n"
                    .."Recliquez pour stopper !";
end

--@do-not-package@
-- https://code.google.com/archive/p/mangadmin/wikis/SpecialCharacters.wiki
-- https://wowwiki.fandom.com/wiki/Localizing_an_addon
--@end-do-not-package@
end
