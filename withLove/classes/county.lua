local Object = require 'utils/classic'
local map_settings = require 'config/map_settings'
local line = require 'classes/line'
local point = require 'classes/point'
local utils = require 'utils/utils'
local town = require 'classes/town'

local county = Object:extend()

function county:new(hexagons)
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

function county:computeShape(delta_x, delta_y)

	local function testLine(hexagons, current_hexagon, lines, i, j, orientation)
		local index = i * map_settings.n_x + j

		if hexagons[index] == nil then
			local vertices = current_hexagon:vertices(delta_x, delta_y)
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

function county:draw(delta_x, delta_y)

	if self.isHighlighted then
		self.shape = self:computeShape(delta_x, delta_y)	

		for i, line in pairs(self.shape) do
			line:draw()
		end
	end

	if self.town ~= nil then
		self.town:draw(delta_x, delta_y)
	end
	
end

return county