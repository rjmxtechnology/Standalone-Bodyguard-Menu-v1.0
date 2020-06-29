fx_version 'bodacious'
games { 'gta5' }

author 'ethanol20#4434'
description 'Bodyguard menu for FiveM'
repository 'https://github.com/ethanol20'
version '1.0.0'

client_scripts { 
	"@NativeUI/NativeUI.lua",
	"client/main.lua",
	"client/global.lua",
	"config/config.lua",
}
server_scripts {
	"server/main.lua",
	"config/config.lua",
}	

-- For support or any script ideas/requests, please join my Discord. https://discord.gg/SQXvn5a