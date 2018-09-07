local Object = require 'utils/classic'
local map_settings = require 'config/map_settings'
local line = require 'classes/line'
local point = require 'classes/point'

local county = Object:extend()

function county:new(hexagons)
	self.hexagons = hexagons
	self.isHighligthed = false
	self.shape = nil
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
	if self.shape == nil then
		self.shape = self:computeShape(delta_x, delta_y)
	end

	for i, line in pairs(self.shape) do
		line:draw()
	end
end

return county