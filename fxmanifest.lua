-- ============================================
-- jx-blips - fxmanifest.lua
-- Created by JamX Scripts
-- Licensed under GPL v3
-- ============================================

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'jx-blips'
author 'JamX Scripts'
description 'Permanent blip system with ox_lib menu, categories, Discord logs and minimap option'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locale/fr.lua',
    'locale/en.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib'
}