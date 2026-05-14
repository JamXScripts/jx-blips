-- ============================================
-- jx-blips - Locale EN
-- Created by JamX Scripts
-- Licensed under GPL v3
-- ============================================

Locales = Locales or {}

Locales['en'] = {
    -- Main menu
    ['menu_title']           = 'Blips Menu',
    ['create_blip']          = '➕ Create a blip',
    ['manage_blips']         = '📋 Manage blips',

    -- Creation dialog
    ['create_title']         = 'Create a blip',
    ['name_label']           = 'Name',
    ['default_blip_name']    = 'My blip',
    ['sprite_label']         = 'Sprite (ID)',
    ['color_label']          = 'Color',
    ['scale_label']          = 'Scale (e.g. 0.8)',
    ['category_label']       = 'Category',
    ['always_visible_label'] = 'Always visible (minimap)',
    ['yes']                  = 'Yes',
    ['no']                   = 'No',

    -- Edit dialog
    ['edit_title']           = 'Edit ',
    ['confirm_delete']       = 'Delete blip',
    ['delete_warning']       = 'Are you sure you want to delete **%s**? This action is irreversible.',

    -- Notifications
    ['success']              = 'Success',
    ['error']                = 'Error',
    ['info']                 = 'Info',
    ['blip_created']         = 'Blip created',
    ['blip_updated']         = 'Blip updated',
    ['blip_deleted']         = 'Blip deleted',
    ['blip_not_found']       = 'Blip not found',
    ['access_denied']        = 'Access denied',
    ['access_denied_desc']   = 'Admins only',
    ['no_blips']             = 'No blips exist',
    ['teleported']           = 'Teleported',
    ['teleport_error']       = 'Unable to teleport',

    -- Description in manage menu
    ['blip_desc']            = 'Sprite: %d | Color: %d | Scale: %.2f | Category: %s',

    -- Actions
    ['edit']                 = '✏️ Edit',
    ['teleport']             = '🗺️ Teleport',
    ['delete']               = '🗑️ Delete',

    -- Default category
    ['category_none']        = 'None',

    -- Blip categories (from config.lua)
    ['category_shops']       = 'Shops',
    ['category_gangs']       = 'Gangs',
    ['category_services']    = 'Services',
    ['category_leisure']     = 'Leisure',
    ['category_misc']        = 'Misc',

    -- Debug
    ['debug_blip_created']   = 'Blip created id=%s name=%s',
    ['debug_blip_error']     = 'ERROR - Cannot create blip id=%s',
}
