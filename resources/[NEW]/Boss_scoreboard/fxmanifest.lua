fx_version 'cerulean'
game 'gta5'

ui_page 'cfg/html/index.html'

description 'Boss Scoreboard'
dependency "vrp"

server_script { 
	"@vrp/lib/utils.lua",
	"server.lua",
}

client_script {
	"@vrp/lib/utils.lua",
	'client.lua',
}

files {
	--html files
	'cfg/html/index.html',
	--css files
    'cfg/html/css/style.css',
	--js files
	'cfg/html/js/config.js',
	'cfg/html/js/main.js',
	--images
	'cfg/html/img/arrow.png',
	'cfg/html/img/icon.png',
}