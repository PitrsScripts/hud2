fx_version 'cerulean'
game 'gta5'

description 'Custom HUD for ESX/QBCore Framework'
author 'Pitrs'
version '1.0.0'

lua54 'yes'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
