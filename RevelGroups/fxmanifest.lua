fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'forum.cfx.re/u/notrevel/summary'

description 'RevelGroups by REVEL#9948'

version '1.0.0'

client_scripts { 
	'client.lua'
}

server_scripts { 
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server.lua' 
}

shared_script 'config.lua'

ui_page 'web/index.html'

files {
    'web/*.js',
	'web/*.html',
	'web/*.css',
	'web/*.mp3',
	'web/*.json',
	'web/*.ls',
	'web/*.pug',
	'web/*.styl',
	'web/fonts/*.otf',
	'web/fonts/*.js'
}

