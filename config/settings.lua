local settings = {}

settings.tile_size = 24
settings.n_x = 20
settings.n_y = 20
settings.split_ratio = 1
settings.altitude_min = 0.05
settings.altitude_max = 4
settings.sigma = 1
settings.smooth_window_size = 3
settings.island_threshold = 0.3
settings.debug = true
settings.players = 4
settings.asset_scaling = 0.22

settings.colors = {
	[1]={226 / 255, 201 / 255, 108 / 255}, -- player 1
	[2]={103 / 255, 155 / 255, 77 / 255}, -- player 2
	[3]={226/ 255, 158 / 255, 108 / 255}, -- player 3
	[4]={170/ 255, 156 / 255, 146 / 255}, -- player 4
	['tile_edge'] = {90/ 255, 90 / 255, 90 / 255},
	['county_edge']= {30/ 255, 30 / 255, 30 / 255},
	['good'] = {0 / 255, 255 / 255, 0 / 255},
	['bad'] = {255 / 255 ,0 / 255,0 / 255}
}


-- SOLDIER
settings.level_max = 4


return settings