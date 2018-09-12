io.stdout:setvbuf("no")
--require 'lovedebug'

function love.load()
	math.randomseed( os.time())

	local map = require 'map'
	game_settings = require 'config/game_settings'
	world = map()

	s = game_settings.size
	font_size = game_settings.font_size
	scaleX, scaleY = 1, 1
	translationX, translationY = 0,0

	font = love.graphics.newFont(font_size)
	love.graphics.setFont(font)

	-- Table that store the mouse state
	previousMouseState = {}
	currentMouseState = {}
	
end

function love.draw()

	love.graphics.setScissor(0, 0,love.graphics.getWidth( )* game_settings.split_ratio, love.graphics.getHeight() )
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

	love.graphics.push()
	love.graphics.translate(translationX, translationY)
	--love.graphics.scale(scaleX, scaleY)
	world:draw()
	love.graphics.pop()

	love.graphics.push()
	love.graphics.setColor(1,1,1)
	love.graphics.print('(' .. love.mouse.getX() .. ',' ..  love.mouse.getY() .. ')', 10, 20)
	love.graphics.print('(' .. translationX .. ',' ..  translationY .. ')', 10, 30)
	love.graphics.print('(' .. scaleX .. ',' ..  scaleY .. ')', 10, 40)
	love.graphics.pop()

end

function love.update(dt)
	world:move()
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
		world:highlight()
	end
end

function love.wheelmoved(x, y)

	if y > 0 then
		s = math.min(s + 2, game_settings.size * 2)
	else
		s = math.max(s - 2, game_settings.size / 2)
	end
	font_size = math.floor( game_settings.font_size * s / game_settings.size)
	font = love.graphics.newFont(font_size)
	love.graphics.setFont(font)

end
