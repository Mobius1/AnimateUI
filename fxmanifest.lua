fx_version 'adamant'

game 'gta5'

description 'ESX Message'

author 'Karl Saunders'

version '0.2.0'


client_scripts {
    'config.lua',
    'client/easing.lua',
    'client/effects.lua',
    'client/demo.lua', 
    'client/main.lua',
}

exports {
    'showMessage',
    'removeMessage',
}