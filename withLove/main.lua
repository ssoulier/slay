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
	currentMouseState = {}
	
end

function love.draw()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	world:draw(delta_x, delta_y)

	love.graphics.print('(' .. love.mouse.getX() .. ',' ..  love.mouse.getY() .. ')', 10, 20)
	love.graphics.print('(' .. delta_x .. ',' ..  delta_y .. ')', 10, 30)
end

function love.update(dt)
	delta_x, delta_y = world:move(delta_x, delta_y)
end

function love.mousepressed(x, y, button, istouch, presses)
   	previousMouseState = currentMouseState
   	if button == 1 then
   		currentMouseState.leftDown = true
   	end

end

function love.mousereleased(x, y, button, istouch, presses)
	
	if button == 1 then
		previousMouseState.leftDown = true
		currentMouseState.leftDown = false
		world:highlight(delta_x, delta_y)
	end
end
