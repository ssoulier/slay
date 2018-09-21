local map_settings = require 'config/map_settings'
local line = require 'classes/line'
local point = require 'classes/point'
local utils = require 'utils/utils'
local town = require 'classes/town'
local soldier = require 'soldier'

local county = Class{}

function county:init(hexagons)
	self.hexagons = hexagons
	self.isHighligthed = false
	self.shape = nil
	
	local size = self:size()
	if size  >= 2 then
		self.town = town(utils.randomchoice(self.hexagons))
		self.cash = size
	else
		self.town = nil
		self.cash = 0
	end

	self.soldiers = {}

	self.trees = {}
	self.graves = {}
	
end

function county:contain(hexagon)

	for index, hex in pairs(self.hexagons) do

		if hex.x == hexagon.x and hex.y == hexagon.y then
			return true
		end

	end
	return false
end

function county:size()
	local size = 0
	for i, h in pairs(self.hexagons) do
		size = size + 1
	end

	return size
end

function county:computeShape()

	local function testLine(hexagons, current_hexagon, lines, i, j, orientation)
		local index = i * map_settings.n_x + j

		if hexagons[index] == nil then
			local vertices = current_hexagon:vertices()
			if orientation == 'o' then
				table.insert(lines, line(point(vertices[3], vertices[4]), point(vertices[5], vertices[6])))
			elseif orientation == 'no' then
				table.insert(lines, line(point(vertices[1], vertices[2]), point(vertices[3], vertices[4])))
			elseif orientation == 'ne' then
				table.insert(lines, line(point(vertices[11], vertices[12]), point(vertices[1], vertices[2])))
			elseif orientation == 'e' then
				table.insert(lines, line(point(vertices[9], vertices[10]), point(vertices[11], vertices[12])))
			elseif orientation == 'se' then
				table.insert(lines, line(point(vertices[7], vertices[8]), point(vertices[9], vertices[10])))
			elseif orientation == 'so' then
				table.insert(lines, line(point(vertices[5], vertices[6]), point(vertices[7], vertices[8])))
			end 
		end
	end

	local shape = {}
	for index, hexagon in pairs(self.hexagons) do

		local m = math.floor(index / map_settings.n_x)
		local n = index - m * map_settings.n_x

		local delta = n % 2

		testLine(self.hexagons, hexagon, shape, m - 1, n, 'o')					-- (x-1 , y)
		testLine(self.hexagons, hexagon, shape, m + 1, n, 'e') 					-- (x+1 , y)
		testLine(self.hexagons, hexagon, shape, m - 1 + delta, n - 1, 'no') 	-- (x-1 , y - 1)
		testLine(self.hexagons, hexagon, shape, m + delta, n - 1, 'ne') 		-- (x , y - 1)
		testLine(self.hexagons, hexagon, shape, m + delta, n + 1, 'se') 		-- (x , y + 1)
		testLine(self.hexagons, hexagon, shape, m - 1 + delta, n + 1, 'so') 	-- (x-1 , y)

	end

	return shape

end

function county:draw()

	if self.isHighlighted then
		self.shape = self:computeShape()	

		love.graphics.push()
		love.graphics.setLineWidth(2)
		love.graphics.setColor(0,0,0)
		for i, line in pairs(self.shape) do
			line:draw()
		end
		love.graphics.setLineWidth(1)
		love.graphics.pop()
	end

	if self.town ~= nil then
		self.town:draw()
	end

	for i, s in pairs(self.soldiers) do
		s:draw()
	end

	love.graphics.push()
	--love.graphics.setScissor(love.graphics.getWidth( )* game_settings.split_ratio, 0,love.graphics.getWidth( )* (1-game_settings.split_ratio), love.graphics.getHeight())	love.graphics.setScissor()
	love.graphics.origin()
	local sx, sy, sw, sh = love.graphics.getScissor() 
	love.graphics.setScissor()
	Suit:draw()
	love.graphics.setScissor(sx, sy, sw, sh)
	love.graphics.pop()
	
	

end

function county:update()

	if self.isHighlighted then

		local padding = 10
		local split_ratio = game_settings.split_ratio
		local y_start = padding

		local x_start = math.floor(love.graphics.getWidth() * split_ratio) + padding
		local menu_layout_width = love.graphics.getWidth() - x_start - padding

		-- County Statistics



	    Suit.layout:reset(x_start, y_start)
	    local headerFont = love.graphics.newFont(18)
		Suit.Label('Finance', {font=headerFont}, Suit.layout:row(menu_layout_width , 20))

	    Suit.layout:reset(x_start, y_start + 20 + 2*padding)
	    Suit.layout:padding(padding)
	    
	    Suit.Label('Revenue', {align='left'}, Suit.layout:down(math.floor(menu_layout_width*0.75), padding))
	    Suit.Label('Wage', {align='left'}, Suit.layout:down())    
	    Suit.Label('Tree', {align='left'}, Suit.layout:down())
	    Suit.Label('Income', {align='left'}, Suit.layout:down())

	    Suit.layout:reset(x_start + math.floor(menu_layout_width * 0.75), y_start + 20 + 2*padding)
	    Suit.layout:padding(padding)
	    Suit.Label('12', {align='right'}, Suit.layout:down(math.floor(menu_layout_width * 0.25), padding))
	    Suit.Label('- 7', {align='right', color = {normal= {fg = {1,0,0}}}}, Suit.layout:down())
	    Suit.Label('- 2', {align='right'}, Suit.layout:down())
	    Suit.Label('3', {align='right'}, Suit.layout:down())

	    Suit.layout:reset(x_start + padding, y_start + 20 + 4*padding + 8*padding)
	    Suit.layout:padding(2*padding)
	    Suit.Button("Add Soldier", {align='center'}, Suit.layout:down(math.floor(menu_layout_width / 2) - 2*padding, 2*padding))
	    Suit.Button("Add Tower", Suit.layout:right())

	end
end

function county:menu()


end

function county:deploySoldier(x, y)

	if self.cash >= soldier.level1.cost then
		table.insert(self.soldiers, soldier(x, y))
		self.cash = self.cash - soldier.level1.cost
	end

end

return county