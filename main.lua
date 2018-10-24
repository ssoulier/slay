Class = require 'libs/class'
Settings = require 'config/settings'
Utils = require 'libs/utils'
MapManager = require 'managers/map'

World = require 'classes/world'
County = require 'classes/county'
Tile = require 'classes/tile'
Town = require 'classes/town'
Tower = require 'classes/tower'
Soldier = require 'classes/soldier'


world = nil

io.stdout:setvbuf("no")

function love.load()
	math.randomseed( os.time() )

	-- Init click duration variables
	clik_duration = nil

	-- Init some graphical variables
	tile_size = Settings.tile_size

	local map_center_x, map_center_y = Utils.center(math.floor(Settings.n_x / 2) , math.floor(Settings.n_y / 2))
	translationX = math.floor(love.graphics.getWidth() * Settings.split_ratio / 2 - map_center_x)
	translationY = math.floor(love.graphics.getHeight() / 2 - map_center_y)

	-- Init several fonts
	smallFont = love.graphics.newFont(8)
	hexFont = love.graphics.newFont(Settings.tile_size / 4)

	-- Assets
	assets = {
		house = love.graphics.newImage('assets/house.png'),
		tree = love.graphics.newImage('assets/tree.png'),
		soldier_1 = love.graphics.newImage('assets/soldier_1.png'),
		soldier_2 = love.graphics.newImage('assets/soldier_2.png'),
		soldier_3 = love.graphics.newImage('assets/soldier_3.png'),
		soldier_4 = love.graphics.newImage('assets/soldier_4.png'),
		tower = love.graphics.newImage('assets/tower.png'),
		dead = love.graphics.newImage('assets/dead.png')
	}


	tiles = MapManager.generateMap()
	world = World(tiles)
end

function love.draw()

	love.graphics.push('all')
	love.graphics.translate(translationX, translationY)
	for _, tile in pairs(tiles) do
		tile:draw()
	end

	world:draw()

	love.

	love.graphics.pop()


	printFPS()

end

function love.resize( w, h )
	local map_center_x, map_center_y = Utils.center(math.floor(Settings.n_x / 2) , math.floor(Settings.n_y / 2))
	translationX, translationY = math.floor(w * Settings.split_ratio / 2 - map_center_x), math.floor(h / 2 - map_center_y)
end

function love.wheelmoved(x, y)

	-- before scaling on which hex am I
	local before_x, before_y = Utils.pixelTocenter(love.mouse.getX(), love.mouse.getY())
	local before_map_center_x, before_map_center_y = Utils.center(before_x , before_y)

	if y > 0 then
		tile_size = math.min(tile_size + 2, Settings.tile_size * 2)
	else
		tile_size = math.max(tile_size - 2, Settings.tile_size / 2)
	end

	local after_map_center_x, after_map_center_y = Utils.center(before_x , before_y)

	translationX, translationY = translationX + math.floor(before_map_center_x - after_map_center_x), translationY + math.floor(before_map_center_y - after_map_center_y)

	hexFont = love.graphics.newFont(tile_size / 4)

end

function love.mousemoved(x, y, dx, dy, istouch)

	if love.mouse.isDown(1) and x < love.graphics.getWidth() * Settings.split_ratio then
		if not click_duration then
			click_duration = 0
		end

		click_duration = click_duration + 1
		translationX, translationY = translationX + dx, translationY + dy

	else
		world:mousemoved(x, y)
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	if button == 2 then
		world:resetFlotingSoldier()
	end
end

function love.mousereleased(x, y, button, istouch, presses)

	if (click_duration or 0) < 4  then -- it was a simple click not a press and hold
		if button == 1 then
			world:tileClicked(x, y)
		end
	else
		print("Hold Click")
	end
	click_duration = nil 

end

function printFPS()

	love.graphics.push('all')
	love.graphics.setFont(smallFont)
	love.graphics.setColor(1,1,1)
	love.graphics.print('Current FPS: '..tostring(love.timer.getFPS( )), 10, 10)
	love.graphics.print('(' .. love.mouse.getX() .. ',' ..  love.mouse.getY() .. ')', 10, 20)
	love.graphics.print('(' .. translationX .. ',' ..  translationY .. ')', 10, 30)
	local x, y = Utils.pixelTocenter(love.mouse.getX(), love.mouse.getY())
	love.graphics.print('(' .. x .. ',' ..  y .. ')', 10, 40)
	love.graphics.pop()

end


