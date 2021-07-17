fx_version "adamant"

game "gta5"

client_scripts {
	'@HT_base/client/wrapper.lua',
	'client/main.lua'
}

dependencies {
	'HT_base'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf'
}