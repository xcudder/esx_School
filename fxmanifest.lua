fx_version 'adamant'

game 'gta5'

description 'ESX School'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'helpers/functions.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'helpers/functions.lua',
	'client/main.lua',
}

dependencies {
    'es_extended',
}