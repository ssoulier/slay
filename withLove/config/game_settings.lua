local game_settings = {}
game_settings.size = 32
game_settings.font_size =  game_settings.size / 4
game_settings.scale = 1
game_settings.debug = true
game_settings.split_ratio = 0.8

game_settings.colors = {
	{66 / 255, 134 / 255, 244 / 255}, -- ocean
	{226 / 255, 201 / 255, 108 / 255}, -- player 1
	{103 / 255, 155 / 255, 77 / 255}, -- player 2
	{226/ 255, 158 / 255, 108 / 255}, -- player 3
	{170/ 255, 156 / 255, 146 / 255} -- player 4
}

game_settings.probability = { 40, 20, 20, 20}

return game_settings