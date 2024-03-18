 
fx_version 'cerulean' 
lua54 'yes' 
games { 'rdr3', 'gta5' } 
author 'DirkScripts' 
description 'React Boilerplate for FiveM | Uses mantine for theming' 
version '1.0.0' 

client_script { 
  'src/client/ui.lua', 
  'src/client/example.lua',
} 
 
ui_page 'web/build/index.html'
files {
	'web/build/index.html',
	'web/build/**/*',
}