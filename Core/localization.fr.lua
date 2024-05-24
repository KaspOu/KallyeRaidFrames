-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------

if (GetLocale() == "frFR") then
local _, ns = ...
local l = ns.I18N;

l.VERS_TITLE    = format("%s %s", ns.TITLE, ns.VERSION);

-- Whats new info
l.WHATSNEW = " Nouveaut\195\169s :\n"
    .."- Ajout de l'option de coloration des barres de noms ennemies.\n"
    .."- Am\195\169liorations UI (bouton info, fond d\195\169grad\195\169).\n"
    .."- Versions |cffff1111Wow Classic|r & |cffc16600Cata|r !\n"
    ;
l.WHATSNEW = l.YL..l.VERS_TITLE.." -"..l.YLL..l.WHATSNEW;

l.SUBTITLE      = "Assistance cadres de raid";
l.DESC          = "Am\195\169liore les cadres de raid.\n\n"
.." - Met en \195\169vidence le fond des joueurs en manque de vie\n\n"
.." - Les barres invers\195\169es utiliseront votre choix de couleurs\n\n"
.." - Transparence des unit\195\169s hors de port\195\169e";
l.OPTIONS_TITLE = format("%s - Options", l.VERS_TITLE);

-- Messages
l.MSG_LOADED         = format("%s lanc\195\169", l.VERS_TITLE);
l.MSG_SDB            = "Kallye menu d\'Options";

l.INIT_FAILED = format("%s pas charg\195\169 correctement !", l.VERS_TITLE);


l.OPTION_RAID_HEADER = "Groupe / Raid";
l.OPTION_HIGHLIGHTLOWHP = "Mettre en \195\169vidence le manque de vie (couleurs dynamiques)"..l.YL.."*";
l.OPTION_REVERTBAR = "Barres de "..l.YL.."vies invers\195\169es|r (moins on a de vie, plus la barre grandit !) ";
l.OPTION_HEALTH_LOW = "Presque mort !";
l.OPTION_HEALTH_LOW_TOOLTIP = "La couleur sera appliqu\195\169e "..l.YLL.."SOUS|r cette limite\n\n"
    .."ex : Rouge sous 25%";
l.OPTION_HEALTH_WARN = "Attention";
l.OPTION_HEALTH_WARN_TOOLTIP = "La couleur sera appliqu\195\169e "..l.YLL.."\195\128|r cette limite\n\n"
    .."ex : Jaune \195\160 50%";
l.OPTION_HEALTH_OK = "Bonne sant\195\169";
l.OPTION_HEALTH_OK_TOOLTIP = "La couleur sera appliqu\195\169e "..l.YLL.."AU-DESSUS|r DE cette limite\n\n"
    .."ex : Vert apr\195\170s 75%";
l.OPTION_MOVEROLEICONS = "Ic\195\180ne de r\195\180le en haut \195\160 gauche";
l.OPTION_HIDEDAMAGEICONS = "Masquer l\'ic\195\180ne de r\195\180le 'd\195\169g\195\160ts'";
l.OPTION_HIDEREALM = "Masquer le royaume des joueurs";
l.OPTION_HIDEREALM_TOOLTIP = "Les noms de royaumes seront masqu\195\169s, ainsi "..l.YLL.."Illidan - Varimathras|r deviendra "..l.YLL.."Illidan (*)|r";
l.OPTION_ICONONDEATH = "Ajouter "..l.RT8.." aux noms des morts";
l.OPTION_FRIENDSCLASSCOLOR = "Noms color\195\169s par classe";
l.OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Am\195\169liore la couleur des cadres des joueurs d'apr\195\168s leur classe";
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR = "Blizzard : "..l.OPTION_FRIENDSCLASSCOLOR;
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR_TOOLTIP = "Option de base des couleurs de classe sur les cadres de raid";
l.OPTION_NOTINRANGE = "Transparence si hors de port\195\169e";
l.OPTION_NOTINRANGE_TOOLTIP = "Par d\195\169faut dans Wow : 55%";
l.OPTION_NOTINCOMBAT = "Transparence du raid hors de combat";
l.OPTION_NOTINCOMBAT_TOOLTIP = "Par d\195\169faut dans Wow : 100%";
l.OPTION_SOLORAID = l.CY.."Affiche les cadres de raid en mode solo "..l.YL.."*";
l.OPTION_SOLORAID_TOOLTIP = "Cadres de groupe/raid toujours visibles";

l.OPTION_EDITMODE_PARTY = "#";
l.OPTION_EDITMODE_PARTY_NOTE = "#";
l.OPTION_EDITMODE_PARTY_TOOLTIP = "#";
l.OPTION_DEBUG_ON = "! Tester les cadres de raid !";
l.OPTION_DEBUG_ON_MESSAGE = "Test des cadres de raid activ\195\169, recliquez pour stopper !";
l.OPTION_DEBUG_OFF = "! ARR\195\138TER LE TEST !";
l.OPTION_DEBUG_OFF_MESSAGE = "Test arr\195\170t\195\169, vous pouvez reprendre une activit\195\169 normale";

l.OPTION_BUFFS_HEADER = "Buffs / Debuffs";
l.OPTION_BUFFSSCALE = "Taille des buffs "..l.YL.."*";
l.OPTION_BUFFSSCALE_TOOLTIP = "Laissez \195\160 1 en cas de conflit d'addon";
l.OPTION_DEBUFFSSCALE = "Taille des d\195\169buffs "..l.YL.."*";
l.OPTION_DEBUFFSSCALE_TOOLTIP = "Laissez \195\160 1 en cas de conflit d'addon";
l.OPTION_MAXBUFFS = "Afficher maximum";
l.OPTION_MAXBUFFS_TOOLTIP = "Nombre maximum de buffs \195\160 afficher";
l.OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";

l.OPTION_OTHERS_HEADER = "Nameplates";
l.OPTION_FRIENDSCLASSCOLOR_NAMEPLATES = "Barre d'info des unit\195\169s color\195\169e par classe (hors instances)";
l.OPTION_FRIENDSCLASSCOLOR_NAMEPLATES_TOOLTIP = "Colore le nom du joueur (sur la t\195\170te) d'apr\195\168s sa classe (ne fonctionne pas en instance)";
l.OPTION_ENEMIESCLASSCOLOR_NAMEPLATES = "Activer pour les ennemis";
l.OPTION_ENEMIESCLASSCOLOR_NAMEPLATES_TOOLTIP = l.OPTION_FRIENDSCLASSCOLOR_NAMEPLATES_TOOLTIP;

l.OPTION_RESET_OPTIONS = "R\195\169initialiser le profil";
l.OPTION_RELOAD_REQUIRED = "Certains changements n\195\169cessitent un rechargement (\195\169crivez : "..l.YL.."/reload|r )";
l.OPTIONS_ASTERIX = l.YL.."*|r"..l.WH..": Options n\195\169cessitant un rechargement";

l.OPTION_SHOWMSGNORMAL = l.GYL.."Afficher les messages";
l.OPTION_SHOWMSGWARNING = l.GYL.."Afficher les alertes";
l.OPTION_SHOWMSGERR = l.GYL.."Afficher les erreurs";
l.OPTION_WHATSNEW = "Nouveaut\195\169s";

-- Edit Mode - Since DragonFlight (10)
if (EditModeManagerFrame.UseRaidStylePartyFrames) then
    if (not EditModeManagerFrame:UseRaidStylePartyFrames()) then
        l.OPTION_SOLORAID_TOOLTIP = "Pensez \195\160 activer l'option "..l.YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
        l.DESC = l.DESC.."\n\n - "..l.OPTION_SOLORAID_TOOLTIP;
    end
    l.OPTION_EDITMODE_PARTY = HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
    l.OPTION_EDITMODE_PARTY_NOTE = "Note : Tapez "..l.YL.."/reload|r apr\195\168s le "..HUD_EDIT_MODE_MENU..", pour \195\169viter toute erreur";
    l.OPTION_EDITMODE_PARTY_TOOLTIP = "Active le "..l.YL..HUD_EDIT_MODE_MENU.."|r, et affiche directement les options de "..l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r.\n\n"..l.CY..l.OPTION_EDITMODE_PARTY_NOTE.."|r";
    l.OPTION_DEBUG_ON_MESSAGE = "Test des cadres de raid activ\195\169 (testable en "..HUD_EDIT_MODE_MENU..")\n"
                    .."Recliquez pour stopper !";
end

--@do-not-package@
-- https://code.google.com/archive/p/mangadmin/wikis/SpecialCharacters.wiki
-- https://wowwiki.fandom.com/wiki/Localizing_an_addon
--@end-do-not-package@
end