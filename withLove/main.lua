io.stdout:setvbuf("no")
--require 'lovedebug'

function love.load()
	math.randomseed( os.time())

	local map = require 'map'
	game_settings = require 'config/game_settings'
	map_settings = require 'config/map_settings'
	draw = require 'utils/draw'
	world = map()

	s = game_settings.size
	local h = s * math.sqrt(3) / 2
	font_size = game_settings.font_size
	local map_center_x, map_center_y = draw.center(math.floor(map_settings.n_x / 2) , math.floor(map_settings.n_y / 2))
	translationX, translationY = math.floor(love.graphics.getWidth() * game_settings.split_ratio / 2 -map_center_x), math.floor(love.graphics.getHeight() / 2 -map_center_y)

	debug_font = love.graphics.newFont(8)

	font = love.graphics.newFont(font_size)
	love.graphics.setFont(font)

	-- Table that store the mouse state
	previousMouseState = {}
	currentMouseState = {}
	
end

function love.draw()

	love.graphics.push()
	love.graphics.setFont(debug_font)
	love.graphics.setColor(1,1,1)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	love.graphics.print('(' .. love.mouse.getX() .. ',' ..  love.mouse.getY() .. ')', 10, 20)
	love.graphics.print('(' .. translationX .. ',' ..  translationY .. ')', 10, 30)
	love.graphics.pop()

	love.graphics.setScissor(0, 0,love.graphics.getWidth( )* game_settings.split_ratio, love.graphics.getHeight() )

	love.graphics.push()
	love.graphics.setFont(font)
	love.graphics.translate(translationX, translationY)
	world:draw()
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

	-- before scaling on which hex am I
	local before_x, before_y = draw.pixelTocenter(love.mouse.getX(), love.mouse.getY())
	local before_map_center_x, before_map_center_y = draw.center(before_x , before_y)

	if y > 0 then
		s = math.min(s + 2, game_settings.size * 2)
	else
		s = math.max(s - 2, game_settings.size / 2)
	end

	local after_map_center_x, after_map_center_y = draw.center(before_x , before_y)

	translationX, translationY = translationX + math.floor(before_map_center_x - after_map_center_x), translationY + math.floor(before_map_center_y - after_map_center_y)

	font_size = math.floor( game_settings.font_size * s / game_settings.size)
	font = love.graphics.newFont(font_size)
	love.graphics.setFont(font)

end


function love.resize( w, h )
	local map_center_x, map_center_y = draw.center(math.floor(map_settings.n_x / 2) , math.floor(map_settings.n_y / 2))
	translationX, translationY = math.floor(w * game_settings.split_ratio / 2 - map_center_x), math.floor(h / 2 - map_center_y)
end