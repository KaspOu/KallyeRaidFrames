-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------

if (GetLocale() == "frFR") then

KRF_VERS_TITLE    = format("%s %s", KRF_TITLE, KRF_VERSION);

-- Whats new info
KRF_WHATSNEW = OR.."- "..KRF_VERS_TITLE..YLL.." - Nouveaut\195\169s :|r\n"
    .."- Mis \195\160 jour pour Shadowlands 9.1\n"
    ;

KRF_SUBTITLE      = "Assistance frames de raid";
KRF_DESC          = "Am\195\169liore les frames de groupe/raid et des unit\195\169s amies.\n\n"
.." - Met en \195\169vidence le fond des joueurs en manque de soin\n\n"
.." - Les barres invers\195\169es utiliseront directement vos couleurs\n\n"
.." - Transparence des unit\195\169s hors de port\195\169e";
KRF_OPTIONS_TITLE = format("%s - Options", KRF_VERS_TITLE);

-- Messages
KRF_MSG_LOADED         = format("%s lanc\195\169", KRF_VERS_TITLE);
KRF_MSG_SDB            = "Kallye menu d\'Options";

KRF_INIT_FAILED = format("%s pas charg\195\169 correctement !", KRF_VERS_TITLE);


KRF_OPTION_RAID_HEADER = "Groupe / Raid";
KRF_OPTION_HIGHLIGHTLOWHP = "Mettre en \195\169vidence la perte de PV des joueurs";
KRF_OPTION_REVERTBAR = "Barres de vies "..YL.."invers\195\169es|r (moins on a de vie, plus la barre grandit !) "..YL.."*";
KRF_OPTION_HEALTH_LOW = "Presque mort !";
KRF_OPTION_HEALTH_LOW_TOOLTIP = "La couleur sera appliqu\195\169e "..YLL.."SOUS|r cette limite\n\n"
    .."ex : Rouge sous 30%";
KRF_OPTION_HEALTH_WARN = "Attention";
KRF_OPTION_HEALTH_WARN_TOOLTIP = "La couleur sera appliqu\195\169e "..YLL.."\195\128|r cette limite\n\n"
    .."ex : Jaune \195\160 50%";
KRF_OPTION_HEALTH_OK = "Vie ok";
KRF_OPTION_HEALTH_OK_TOOLTIP = "La couleur sera appliqu\195\169e "..YLL.."AU-DESSUS|r DE cette limite\n\n"
    .."ex : Vert apr\195\170s 60%";
KRF_OPTION_MOVEROLEICONS = "Ic\195\180ne de r\195\180le en haut \195\160 gauche";
KRF_OPTION_HIDEDAMAGEICONS = "Masquer l\'ic\195\180ne de r\195\180le 'd\195\169g\195\160ts'";
KRF_OPTION_HIDEREALM = "Masquer le royaume des joueurs";
KRF_OPTION_FRIENDSCLASSCOLOR = "Noms color\195\169s par classe";
KRF_OPTION_NOTINRANGE = "Transparence si hors de port\195\169e";
KRF_OPTION_NOTINCOMBAT = "Transparence du raid hors de combat";
KRF_OPTION_SOLORAID = CY.."Toujours afficher les frames de raid "..YL.."*";
KRF_OPTION_DEBUG_ON = "! Tester les frames !";
KRF_OPTION_DEBUG_ON_MESSAGE = "Test des frames de raid activ\195\168, recliquez pour stopper !";
KRF_OPTION_DEBUG_OFF = "! ARR\195\138TER LE TEST !";
KRF_OPTION_DEBUG_OFF_MESSAGE = "Test arr\195\170t\195\168, vous pouvez reprendre une activit\195\168 normale";

KRF_OPTION_BUFFS_HEADER = "Buffs / Debuffs";
KRF_OPTION_BUFFSSCALE = "Taille des buffs";
KRF_OPTION_DEBUFFSSCALE = "Taille des d\195\169buffs";
KRF_OPTION_MAXBUFFS = "Afficher maximum";
KRF_OPTION_MAXBUFFS_TOOLTIP = "Nombre maximum de buffs \195\160 afficher";
KRF_OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";

KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES = "Barre d'info des unit\195\169s color\195\169e par classe (hors raid)";

KRF_OPTION_RESET_OPTIONS = "R\195\169initialiser le profil";
KRF_OPTION_RELOAD_REQUIRED = "Certaines options requi\195\168rent un rechargement (\195\169crivez : /reload )";

KRF_OPTION_SHOWMSGNORMAL = GYL.."Afficher les messages";
KRF_OPTION_SHOWMSGWARNING = GYL.."Afficher les alertes";
KRF_OPTION_SHOWMSGERR = GYL.."Afficher les erreurs";

--@do-not-package@
-- https://code.google.com/archive/p/mangadmin/wikis/SpecialCharacters.wiki
-- https://wowwiki.fandom.com/wiki/Localizing_an_addon
--@end-do-not-package@
end
