io.stdout:setvbuf("no")


function love.load()
	math.randomseed( os.time())

	local map = require 'map'
	local game_settings = require 'config/game_settings'
	world = map()
	delta_x, delta_y = 0,0

	font = love.graphics.newFont(game_settings.fontSize)
	love.graphics.setFont(font)
	
end

function love.draw()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	world:draw(delta_x, delta_y)
end

function love.update(dt)
	delta_x, delta_y = world:update(dt, delta_x, delta_y)
end

function love.mousepressed(x, y, button, istouch)
   
end
