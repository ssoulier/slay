local game = {}

local world

function game:init()

	local map = require 'map'
	
	world = map()

	s = game_settings.size
	local h = s * math.sqrt(3) / 2
	local map_center_x, map_center_y = draw.center(math.floor(map_settings.n_x / 2) , math.floor(map_settings.n_y / 2))
	translationX, translationY = math.floor(love.graphics.getWidth() * game_settings.split_ratio / 2 -map_center_x), math.floor(love.graphics.getHeight() / 2 -map_center_y)

end

function game:update(dt)
	world:update()
end

function game:draw()
	love.graphics.push()
	love.graphics.setFont(fonts.debug)
	love.graphics.setColor(1,1,1)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	love.graphics.print('(' .. love.mouse.getX() .. ',' ..  love.mouse.getY() .. ')', 10, 20)
	love.graphics.print('(' .. translationX .. ',' ..  translationY .. ')', 10, 30)
	love.graphics.pop()

	
	world:draw()
	

	love.graphics.push()
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(4)
	love.graphics.setScissor(love.graphics.getWidth( )* game_settings.split_ratio, 0,love.graphics.getWidth( )* (1-game_settings.split_ratio), love.graphics.getHeight())
	love.graphics.line(love.graphics.getWidth( )* game_settings.split_ratio, 0, love.graphics.getWidth( )* game_settings.split_ratio, love.graphics.getHeight())
	love.graphics.setLineWidth(1)
	love.graphics.setScissor()
	love.graphics.pop()
end

function game:mousemoved(x, y, dx, dy, istouch)

	if love.mouse.isDown(1) and x < love.graphics.getWidth() * game_settings.split_ratio then
		world:mousemoved(x, y, dx, dy)
	end
end

function game:mousepressed(x, y, button, istouch, presses)

	if button == 2 then
		world:cancel()
	end
end

function game:mousereleased(x, y, button, istouch, presses)
	
	if button == 1 then
		world:highlight()
	end
end

function game:wheelmoved(x, y)

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
	fonts.hex = love.graphics.newFont(font_size)

end


function game:resize( w, h )
	local map_center_x, map_center_y = draw.center(math.floor(map_settings.n_x / 2) , math.floor(map_settings.n_y / 2))
	translationX, translationY = math.floor(w * game_settings.split_ratio / 2 - map_center_x), math.floor(h / 2 - map_center_y)
end

return game