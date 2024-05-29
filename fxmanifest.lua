fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'EddieCarson'
description 'Player Loot Script it works for. ox_inventory'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_inventory',
    'ox_lib'
}
