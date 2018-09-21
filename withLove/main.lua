Lume = require 'libs/lume.lume'
Gamestate = require 'libs/hump.gamestate'
Class = require 'libs/hump.class'
Suit = require 'libs/suit'
game_settings = require 'config/game_settings'
map_settings = require 'config/map_settings'
draw = require 'utils/draw'
local menu = require 'states/menu'


io.stdout:setvbuf("no")
--require 'lovedebug'

function love.load()
	math.randomseed( os.time())
	Gamestate.registerEvents()
	Gamestate.switch(menu)
end