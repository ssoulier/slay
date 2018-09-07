io.stdout:setvbuf("no")


function love.load()
	math.randomseed( os.time())

	local map = require 'map'
	local game_settings = require 'config/game_settings'
	world = map()
	delta_x, delta_y = 0,0

	font = love.graphics.newFont(game_settings.fontSize)
	love.graphics.setFont(font)

	-- Table that store the mouse state
	previousMouseState = {}
	
end

function love.draw()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	world:draw(delta_x, delta_y)

	love.graphics.print('(' .. love.mouse.getX() .. ',' ..  love.mouse.getY() .. ')', 10, 20)
	love.graphics.print('(' .. delta_x .. ',' ..  delta_y .. ')', 10, 30)
end

function love.update(dt)
	delta_x, delta_y = world:move(dt, delta_x, delta_y)
	world:highlight(delta_x, delta_y)

	-- Store mouse state
	previousMouseState.leftDown = love.mouse.isDown(1)

end

function love.mousepressed(x, y, button, istouch)
   
end


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
