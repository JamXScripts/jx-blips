-- ============================================
-- jx-blips - Locale FR
-- Created by JamX Scripts
-- Licensed under GPL v3
-- ============================================

Locales = Locales or {}

Locales['fr'] = {
    -- Menu principal
    ['menu_title']          = 'Menu Blips',
    ['create_blip']         = '➕ Créer un blip',
    ['manage_blips']        = '📋 Gérer les blips',

    -- Dialogues de création
    ['create_title']        = 'Créer un blip',
    ['name_label']          = 'Nom',
    ['default_blip_name']   = 'Mon blip',
    ['sprite_label']        = 'Sprite (ID)',
    ['color_label']         = 'Couleur',
    ['scale_label']         = 'Taille (ex: 0.8)',
    ['category_label']      = 'Catégorie',
    ['always_visible_label']= 'Toujours visible (minimap)',
    ['yes']                 = 'Oui',
    ['no']                  = 'Non',

    -- Dialogues de modification
    ['edit_title']          = 'Modifier ',
    ['confirm_delete']      = 'Supprimer le blip',
    ['delete_warning']      = 'Es-tu sûr de vouloir supprimer **%s** ? Cette action est irréversible.',

    -- Notifications
    ['success']             = 'Succès',
    ['error']               = 'Erreur',
    ['info']                = 'Info',
    ['blip_created']        = 'Blip créé',
    ['blip_updated']        = 'Blip modifié',
    ['blip_deleted']        = 'Blip supprimé',
    ['blip_not_found']      = 'Blip introuvable',
    ['access_denied']       = 'Accès refusé',
    ['access_denied_desc']  = 'Réservé aux administrateurs',
    ['no_blips']            = 'Aucun blip existant',
    ['teleported']          = 'Téléportation effectuée',
    ['teleport_error']      = 'Impossible de téléporter',

    -- Descriptions dans le menu de gestion
    ['blip_desc']           = 'Sprite: %d | Couleur: %d | Taille: %.2f | Catégorie: %s',

    -- Actions
    ['edit']                = '✏️ Modifier',
    ['teleport']            = '🗺️ Téléporter',
    ['delete']              = '🗑️ Supprimer',

    -- Catégorie par défaut
    ['category_none']       = 'Aucune',

    -- Catégories de blips (depuis config.lua)
    ['category_shops']      = 'Commerces',
    ['category_gangs']      = 'Gangs',
    ['category_services']   = 'Services',
    ['category_leisure']    = 'Loisirs',
    ['category_misc']       = 'Divers',

    -- Debug
    ['debug_blip_created']  = 'Blip créé id=%s name=%s',
    ['debug_blip_error']    = 'ERREUR - Impossible de créer le blip id=%s',
}