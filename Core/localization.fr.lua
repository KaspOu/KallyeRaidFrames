-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------

local _, ns = ...
local l = ns.I18N;

l.VERS_TITLE    = format("%s %s", ns.TITLE, ns.VERSION);

l.CONFLICT_MESSAGE = "Désactivé : Conflit avec %s";

-- Whats new info
l.WHATSNEW = [[ Nouveautés :
- Les paramètres sont maintenant appliqués en temps réel.
- Barres d'info : texture corrigée
- Barres d'info : noms corrigés
]];

l.WHATSNEW = l.YL..l.VERS_TITLE.." -"..l.YLL..l.WHATSNEW;

l.SUBTITLE      = "Assistance cadres de raid";
l.DESC          = "Améliore les cadres de raid.\n\n"
.." - Met en évidence le fond des joueurs en manque de vie\n\n"
.." - Les barres inversées utiliseront votre choix de couleurs\n\n"
.." - Transparence des unités hors de portée\n\n"
.." - Raid toujours visible\n\n"
.."\n"
.."Améliore les buffs / débuffs (taille, max affichés, ...)\n\n"
.."Colorise les noms en barre d'info, avec icônes JcJ |TInterface/PVPFrame/PVP-Currency-Alliance:16|t|TInterface/PVPFrame/PVP-Currency-Horde:16|t\n\n"
.."Affiche les icônes de cible (|TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t|TInterface/TargetingFrame/UI-RaidTargetingIcon_2:0|t...) sur les cadres de raid\n\n"
l.OPTIONS_TITLE = format("%s - Options", l.VERS_TITLE);

-- Messages
l.MSG_LOADED         = format("%s lancé", l.VERS_TITLE);
l.MSG_SDB            = "Kallye menu d\'Options";

l.INIT_FAILED = format("%s pas chargé correctement !", l.VERS_TITLE);

local required = l.YL.."*";
l.OPTION_RAID_HEADER = "Groupe / Raid";
l.OPTION_HIGHLIGHTLOWHP = "Mettre en évidence le manque de vie (couleurs dynamiques)"..required;
l.OPTION_REVERTBAR = "Barres de "..l.YL.."vies inversées|r (moins on a de vie, plus la barre grandit !) ";
l.OPTION_HEALTH_LOW = "Presque mort !";
l.OPTION_HEALTH_LOW_TOOLTIP = "La couleur sera appliquée "..l.YLL.."SOUS|r cette limite\n\n"
    .."ex : Rouge sous 25%";
l.OPTION_HEALTH_WARN = "Attention";
l.OPTION_HEALTH_WARN_TOOLTIP = "La couleur sera appliquée "..l.YLL.."À|r cette limite\n\n"
    .."ex : Jaune à 50%";
l.OPTION_HEALTH_OK = "Bonne santé";
l.OPTION_HEALTH_OK_TOOLTIP = "La couleur sera appliquée "..l.YLL.."AU-DESSUS|r DE cette limite\n\n"
    .."ex : Vert après 75%";
l.OPTION_HEALTH_ALPHA = l.WH.."Transparence"..required;
l.OPTION_HEALTH_ALPHA_TOOLTIP = "Transparence de la barre de vie (avec la couleur de classe)\n"..l.CY.."Par défaut dans Wow : 100%"
l.OPTION_MOVEROLEICONS = "Icône de rôle en haut à gauche";
l.OPTION_HIDEDAMAGEICONS = "Masquer l\'icône de rôle 'dégàts'";
l.OPTION_HIDEREALM = "Masquer le royaume des joueurs";
l.OPTION_HIDEREALM_TOOLTIP = "Les noms de royaumes seront masqués, ainsi "..l.YLL.."Illidan - Varimathras|r deviendra "..l.YLL.."Illidan (*)|r";
l.OPTION_ICONONDEATH = "Ajouter "..l.RT8.." aux noms des morts";
l.OPTION_FRIENDSCLASSCOLOR = "Noms colorés par classe";
l.OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Noms des joueurs colorés par classe (cadres de groupe/raid)";
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR = format("Blizzard : %s", RAID_USE_CLASS_COLORS)
l.OPTION_BLIZZARDFRIENDSCLASSCOLOR_TOOLTIP = format("%s : %s", INTERFACE_LABEL, OPTION_TOOLTIP_RAID_USE_CLASS_COLORS)
l.OPTION_BAR_TEXTURE = "Texture"
l.OPTION_BAR_TEXTURE_TOOLTIP = "Texture de la barre de vie"
l.OPTION_SOLORAID = l.CY.."Affiche les cadres de raid en mode solo"..required;
l.OPTION_SOLORAID_TOOLTIP = "Cadres de groupe/raid toujours visibles,\nactivera "..l.YLL..USE_RAID_STYLE_PARTY_FRAMES;

l.OPTION_EDITMODE_PARTY = format("Blizzard : %s", USE_RAID_STYLE_PARTY_FRAMES)
l.OPTION_EDITMODE_PARTY_TOOLTIP = "";
l.OPTION_DEBUG_ON = "! Tester les cadres de raid !";
l.OPTION_DEBUG_ON_MESSAGE = "Test des cadres de raid activé, recliquez pour stopper !";
l.OPTION_DEBUG_OFF = "! ARRÊTER LE TEST !";
l.OPTION_DEBUG_OFF_MESSAGE = "Test arrêté, vous pouvez reprendre une activité normale";

l.OPTION_ACTIVATE_MODULE = "Activer / Désactiver le module"
l.OPTION_HIDEDISABLED = l.GYL.."Masquer les modules désactivés"

-- KF START
l.OPTION_INRANGE = "Transparence à portée";
l.OPTION_INRANGE_TOOLTIP = l.CY.."Par défaut dans Wow : 100%";
l.OPTION_NOTINRANGE = "Transparence si hors de portée";
l.OPTION_NOTINRANGE_TOOLTIP = l.CY.."Par défaut dans Wow : "..l.DEFAULT_ALPHA_OUTOFRANGE.."%";
l.OPTION_NOTINCOMBAT = "Transparence du raid hors de combat";
l.OPTION_NOTINCOMBAT_TOOLTIP = l.CY.."Par défaut dans Wow : 100%";
l.OPTION_ALPHADISPELOVERLAY = "Transparence de l'indicateur de dissipations"
l.OPTION_ALPHADISPELOVERLAY_TOOLTIP = l.OPTION_NOTINCOMBAT_TOOLTIP
-- KF END

l.OPTION_ACTIVATE_MODULE_DEBUFFS = l.OPTION_ACTIVATE_MODULE
    .. ( ns.LoadRaidFramesAuras and "\n"..l.WH.."Les buffs/débuffs Blizzard seront remplacés par RaidFrameAuras" or "")
-- KBD START
l.OPTION_BUFFS_HEADER = "Debuffs / Buffs"
l.OPTION_ORIENTATION_LeftThenUp = "À Gauche, puis en Haut"
l.OPTION_ORIENTATION_LeftThenUp_Default = l.DEFAULT.."À Gauche, puis en Haut (par défaut)"
l.OPTION_ORIENTATION_UpThenLeft = "En Haut, puis à Gauche"
l.OPTION_ORIENTATION_RightThenUp = "À Droite, puis en Haut"
l.OPTION_ORIENTATION_RightThenUp_Default = l.DEFAULT.."À Droite, puis en Haut (par défaut)"
l.OPTION_ORIENTATION_UpThenRight = "En Haut, puis à Droite"
l.OPTION_BUFFSSCALE = "Taille des buffs";
l.OPTION_BUFFSSCALE_TOOLTIP = l.CY.."Par défaut dans Wow : 1"
l.OPTION_MAXBUFFS = "Limite de buffs";
l.OPTION_MAXBUFFS_TOOLTIP = "Nombre maximum de buffs à afficher\n"..l.CY.."Par défaut dans Wow : "..ns.DEFAULT_MAXBUFFS;
l.OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";
l.OPTION_BUFFSPERLINE = "Buffs par ligne";
l.OPTION_BUFFSPERLINE_TOOLTIP = "Nombre de buffs par ligne\n"..l.CY.."Ignoré si supérieur à la Limite";
l.OPTION_BUFFSPERLINE_FORMAT = "%d par ligne";
l.OPTION_BUFFSORIENTATION = "Orientation des buffs";
l.OPTION_BUFFSORIENTATION_TOOLTIP = "Choisissez l\'arrangement des buffs (supporte le multiligne)\n"..l.CY.."Par défaut : "..l.OPTION_ORIENTATION_LeftThenUp
l.OPTION_BUFFS_RELATIVE_X = "Position horizontale";
l.OPTION_BUFFS_RELATIVE_X_TOOLTIP = "Ajustez la position horizontale relative des buffs";
l.OPTION_BUFFS_RELATIVE_Y = "Position verticale";
l.OPTION_BUFFS_RELATIVE_Y_TOOLTIP = "Ajustez la position verticale relative des buffs";
l.OPTION_DEBUFFSSCALE = "Taille des débuffs";
l.OPTION_DEBUFFSSCALE_TOOLTIP = l.CY.."Par défaut dans Wow : 1"
l.OPTION_MAXDEBUFFS = "Limite de débuffs";
l.OPTION_MAXDEBUFFS_TOOLTIP = "Nombre maximum de débuffs à afficher\n"..l.CY.."Par défaut dans Wow : "..ns.DEFAULT_MAXDEBUFFS;
l.OPTION_MAXDEBUFFS_FORMAT = "%d |4débuff:débuffs";
l.OPTION_DEBUFFSPERLINE = "Débuffs par ligne";
l.OPTION_DEBUFFSPERLINE_TOOLTIP = "Nombre d'icônes de débuff par ligne\n"..l.CY.."Ignoré si supérieur à la Limite";
l.OPTION_DEBUFFSPERLINE_FORMAT = "%d par ligne";
l.OPTION_DEBUFFSORIENTATION = "Orientation des débuffs";
l.OPTION_DEBUFFSORIENTATION_TOOLTIP = "Choisissez l\'arrangement des débuffs (supporte le multiligne)\n"..l.CY.."Par défaut : "..l.OPTION_ORIENTATION_RightThenUp;
l.OPTION_DEBUFFS_RELATIVE_X = "Position horizontale";
l.OPTION_DEBUFFS_RELATIVE_X_TOOLTIP = "Ajustez la position horizontale relative des débuffs";
l.OPTION_DEBUFFS_RELATIVE_Y = "Position verticale";
l.OPTION_DEBUFFS_RELATIVE_Y_TOOLTIP = "Ajustez la position verticale relative des débuffs";
l.OPTION_USETAINTMETHOD = l.CY.."Affichage classique de la Limite de buffs / débuffs"..required.." "..l.ALERT
l.OPTION_USETAINTMETHOD_TOOLTIP = "Décoché, utilise l'affichage expérimental\nCoché, utilise l'affichage stable, mais avec une "..l.RDL.."erreur par session|r, pas si grave..."
l.OPTION_BUFFS_TAINTWARNING = l.ALERT.." Changer la Limite provoque une "..l.RDL.."erreur par session|r, pas si grave..."
l.OPTION_BUFFS_FLICKERWARNING = l.INFO.." Le repositionnement peut être affecté quelques secondes à la mort d'un boss"
l.OPTION_BUFFS_HIDEBLIZZARDAURAS = " Masquer les auras Blizzard"
l.OPTION_BUFFS_RESET = "Annuler tout repositionnement"
l.OPTION_FILTER_AUTO_DEFAULT = l.DEFAULT.."Auto — suit le combat (défaut)";
l.OPTION_FILTER_RAID = "Toujours la liste hors combat";
l.OPTION_FILTER_RAID_IN_COMBAT = "Toujours la liste en combat";
l.OPTION_BUFFS_SPACING_X = "Espacement horizontal";
l.OPTION_BUFFS_SPACING_X_TOOLTIP = "Écart horizontal, en pixels, entre les icônes de buffs\n"..l.CY.."Défaut : 0";
l.OPTION_BUFFS_SPACING_Y = "Espacement vertical";
l.OPTION_BUFFS_SPACING_Y_TOOLTIP = "Écart vertical, en pixels, entre les icônes de buffs\n"..l.CY.."Défaut : 1";
l.OPTION_BUFFSFILTER = "Filtre des buffs";
l.OPTION_BUFFSFILTER_TOOLTIP = "Quelle liste de buffs Blizzard fournit\n"..l.CY.."Auto bascule à l'entrée et à la sortie du combat";
l.OPTION_BUFFS_HIDETOOLTIP = "Masquer les infobulles des buffs"..required;
l.OPTION_BUFFS_HIDETOOLTIP_TOOLTIP = "Aucune infobulle au survol d'une icône de buff\n"..l.RDL.."Désactive aussi le clic droit pour annuler un buff";
l.OPTION_BUFFS_EXCLUDED = "Buffs filtrés";
l.OPTION_BUFFS_EXCLUDED_TITLE = "Buffs à ne pas afficher";
l.OPTION_BUFFS_EXCLUDED_PLACEHOLDER = "Nom du sort ou Spell ID";
l.OPTION_DEBUFFS_SPACING_X = "Espacement horizontal";
l.OPTION_DEBUFFS_SPACING_X_TOOLTIP = "Écart horizontal, en pixels, entre les icônes de débuffs\n"..l.CY.."Défaut : 0";
l.OPTION_DEBUFFS_SPACING_Y = "Espacement vertical";
l.OPTION_DEBUFFS_SPACING_Y_TOOLTIP = "Écart vertical, en pixels, entre les icônes de débuffs\n"..l.CY.."Défaut : 1";
l.OPTION_DEBUFFSFILTER = "Filtre des débuffs";
l.OPTION_DEBUFFSFILTER_TOOLTIP = "Quelle liste de débuffs Blizzard fournit\n"..l.CY.."Auto bascule à l'entrée et à la sortie du combat";
l.OPTION_DEBUFFS_HIDETOOLTIP = "Masquer les infobulles des débuffs"..required;
l.OPTION_DEBUFFS_HIDETOOLTIP_TOOLTIP = "Aucune infobulle au survol d'une icône de débuff\n"..l.RDL.."Désactive aussi le clic droit pour annuler un débuff";
-- KBD END

-- KNC START
l.OPTION_OTHERS_HEADER = "Barres d'infos";
l.OPTION_NAMEPLATES_USECOLOR_BLIZZARD = l.DEFAULT.."Par défaut";
l.OPTION_NAMEPLATES_USECOLOR_CLASS = "Couleurs de classe";
l.OPTION_NAMEPLATES_USECOLOR_CUSTOM = "Votre choix de couleur : ";
l.OPTION_NAMEPLATES_SHOWPVPICONS_BLIZZARD = l.DEFAULT.."Pas d'icône";
l.OPTION_NAMEPLATES_SHOWPVPICONS_FACTION = "Icône de faction |TInterface/PVPFrame/PVP-Currency-Alliance:16|t - |TInterface/PVPFrame/PVP-Currency-Horde:16|t";
l.OPTION_NAMEPLATES_COLOR_UNDER = "Couleur si inférieur";
l.OPTION_NAMEPLATES_COLOR_UNDER_TOOLTIP = "Sélectionnez la couleur du niveau s'il est inférieur au vôtre";
l.OPTION_NAMEPLATES_COLOR_OVER = "Couleur si supérieur";
l.OPTION_NAMEPLATES_COLOR_OVER_TOOLTIP = "Sélectionnez la couleur du niveau s'il est supérieur au vôtre";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER = l.DEFAULT.."Jamais";
l.OPTION_NAMEPLATES_SHOWLEVEL_NEVER_TOOLTIP = "Ne montre jamais le niveau sur les barres d'info.";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT = "Si différent du vôtre";
l.OPTION_NAMEPLATES_SHOWLEVEL_DIFFERENT_COLORED = "Si différent du vôtre, coloré";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS = "Toujours";
l.OPTION_NAMEPLATES_SHOWLEVEL_ALWAYS_COLORED = "Toujours, coloré";

l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR = "Noms alliés";
l.OPTION_FRIENDSNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Couleur du nom sur les barres d'info alliées (hors instances)";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR = "Barres alliées";
l.OPTION_FRIENDSNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Couleur des barres d'info alliées (hors instances)"
l.OPTION_FRIENDSNAMEPLATES_BAR_TEXTURE = "Texture Barres alliées"
l.OPTION_FRIENDSNAMEPLATES_BAR_TEXTURE_TOOLTIP = "Texture des barres d'info alliées (hors instances)"
l.OPTION_FRIENDSNAMEPLATES_PVPICONS = "Icônes JcJ alliées";
l.OPTION_FRIENDSNAMEPLATES_PVPICONS_TOOLTIP = "Affiche les icônes JcJ sur les noms alliés.";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL = "Niveaux alliés";
l.OPTION_FRIENDSNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Affiche le niveau sur les barres d'info alliées.";

l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR = "Noms ennemis";
l.OPTION_ENEMIESNAMEPLATES_TXT_USECOLOR_TOOLTIP = "Couleur du nom sur les barres d'info ennemies (hors instances)";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR = "Barres ennemies";
l.OPTION_ENEMIESNAMEPLATES_BAR_USECOLOR_TOOLTIP = "Couleur des barres d'info ennemies (hors instances)";
l.OPTION_ENEMIESNAMEPLATES_BAR_TEXTURE = "Texture Barres ennemies"
l.OPTION_ENEMIESNAMEPLATES_BAR_TEXTURE_TOOLTIP = "Texture des barres d'info ennemies (hors instances)"
l.OPTION_ENEMIESNAMEPLATES_PVPICONS = "Icônes JcJ ennemies";
l.OPTION_ENEMIESNAMEPLATES_PVPICONS_TOOLTIP = "Affiche les icônes JcJ sur les noms ennemis.";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL = "Niveaux ennemis";
l.OPTION_ENEMIESNAMEPLATES_TXT_SHOWLEVEL_TOOLTIP = "Affiche le niveau sur les barres d'info ennemies.";
-- KNC END

l.OPTION_ACTIVATE_MODULE_RAIDICONS = l.OPTION_ACTIVATE_MODULE .. "\n"
    ..l.WH.."Affiche les icônes de cible (|TInterface/TargetingFrame/UI-RaidTargetingIcon_1:0|t|TInterface/TargetingFrame/UI-RaidTargetingIcon_2:0|t...) sur les cadres de raid"
-- KRI START
l.OPTION_RAIDICONS_HEADER = "Icônes de raid";
l.OPTION_RAIDICONS_ANCHOR = "Alignement des icônes";
l.OPTION_RAIDICONS_ANCHOR_TOOLTIP = "Position de l'icône cible dans le cadre de raid";
l.OPTION_CENTER = "Centre"
l.OPTION_TOPLEFT = "Haut Gauche";
l.OPTION_TOPRIGHT = "Haut Droit";
l.OPTION_BOTTOMLEFT = "Bas Gauche";
l.OPTION_BOTTOMRIGHT = "Bas Droit";
l.OPTION_RAIDICONS_SIZE = "Taille des icônes";
l.OPTION_RAIDICONS_SIZE_TOOLTIP = "Ajustez la taille des icônes de raid";
l.OPTION_RAIDICONS_RELATIVE_X = "Position horizontale";
l.OPTION_RAIDICONS_RELATIVE_X_TOOLTIP = "Ajustez la position horizontale relative des icônes de raid";
l.OPTION_RAIDICONS_RELATIVE_Y = "Position verticale";
l.OPTION_RAIDICONS_RELATIVE_Y_TOOLTIP = "Ajustez la position verticale relative des icônes de raid";
-- KRI END

l.OPTION_RESET_OPTIONS = "Réinitialiser le profil";
l.OPTION_RELOAD_REQUIRED = "Certains changements nécessitent un rechargement (écrivez : "..l.YL.."/reload|r )";
l.OPTIONS_ASTERIX = l.YL.."*|r"..l.WH..": Options nécessitant un rechargement";

l.OPTION_SHOWMSGNORMAL = l.GYL.."Afficher les messages";
l.OPTION_SHOWMSGWARNING = l.GYL.."Afficher les alertes";
l.OPTION_SHOWMSGERR = l.GYL.."Afficher les erreurs";
l.OPTION_COMPARTMENT_FILTER = "Afficher dans le Compartment Filter"..required;
l.OPTION_COMPARTMENT_FILTER_TOOLTIP = "Dans la liste des addons en haut à droite";
l.OPTION_WHATSNEW = "Nouveautés";

--? Edit Mode - Since DragonFlight (10)
if (EditModeManagerFrame.UseRaidStylePartyFrames) then
    -- Edit mode takes a while...
    l.UpdateLocales = function ()
        C_Timer.After(1, function()
        if (not ns.CanEditActiveLayout()) then
            l.OPTION_SOLORAID_TOOLTIP = "Pensez à activer l'option "..l.YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
            l.DESC = l.DESC.."\n"..l.CY..l.OPTION_SOLORAID_TOOLTIP.."|r\n\n";
        end
        end)
    end
    l.OPTION_SOLORAID = l.CY.."Affiche les cadres de groupe en mode solo"..required;
    l.OPTION_SOLORAID_GROUPINRAID = "Affiche aussi les cadres de groupe en raid"..required
    l.OPTION_SOLORAID_GROUPINRAID_TOOLTIP = "Lorsque vous êtes en raid, affiche les cadres de groupe et de raid en même temps"
    l.OPTION_EDITMODE_PARTY_TOOLTIP = format("%s / %s l'option %s|r des %s|r\n(%s|r)", ENABLE, DISABLE, l.YL..USE_RAID_STYLE_PARTY_FRAMES, l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL, l.RDD..HUD_EDIT_MODE_MENU)
    l.OPTION_EDITMODE_BTN_PARTY = HUD_EDIT_MODE_MENU.." : "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
    l.OPTION_EDITMODE_BTN_PARTY_NOTE = "Note : Tapez "..l.YL.."/reload|r après le "..HUD_EDIT_MODE_MENU..", pour éviter toute erreur";
    l.OPTION_EDITMODE_BTN_PARTY_TOOLTIP = "Active le "..l.YL..HUD_EDIT_MODE_MENU.."|r, et affiche directement les options de "..l.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r.\n\n"..l.CY..l.OPTION_EDITMODE_BTN_PARTY_NOTE.."|r";
    l.OPTION_DEBUG_ON_MESSAGE = "Test des cadres de raid activé (testable en "..HUD_EDIT_MODE_MENU..")\n"
                    .."Recliquez pour stopper !";
end

--@do-not-package@
-- ? GlobalStrings: https://www.townlong-yak.com/framexml/live/Helix/GlobalStrings.lua
-- https://code.google.com/archive/p/mangadmin/wikis/SpecialCharacters.wiki
-- https://wowwiki.fandom.com/wiki/Localizing_an_addon
--@end-do-not-package@