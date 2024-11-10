fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '.kosmonautas'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

client_scripts { 
    'client.lua',
    'bridge/*.lua'
}

server_scripts {
    'config.lua',
    'server.lua',
    '@oxmysql/lib/MySQL.lua',
    'bridge/framework/*.lua'
}

files {
    'locales/*.json'
}
