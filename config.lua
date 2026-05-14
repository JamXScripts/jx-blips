-- ============================================
-- jx-blips - config.lua
-- Created by JamX Scripts
-- Licensed under GPL v3
-- ============================================

Config                      = {}

Config.AdminOnly            = true -- Only players with ACE 'jx-blips.admin' can use the menu
Config.BlipsFile            = 'blips.json'
Config.Debug                = false
Config.Locale               = 'fr' -- 'fr' or 'en'

Config.DefaultSprite        = 1
Config.DefaultColor         = 2
Config.DefaultScale         = 0.8
Config.DefaultAlwaysVisible = true -- true = always visible on minimap, false = short range only

Config.DiscordWebhook       = ''   -- Replace with your webhook URL to enable Discord logs

-- Blip categories (ID must be between 12 and 254)
-- Labels use locale keys defined in locale/fr.lua and locale/en.lua
Config.BlipCategories       = {
    { label = 'category_shops',    category = 12 },
    { label = 'category_gangs',    category = 13 },
    { label = 'category_services', category = 14 },
    { label = 'category_leisure',  category = 15 },
    { label = 'category_misc',     category = 16 },
}
