local Object = require 'utils/classic'
local map_settings = require 'config/map_settings'
local game_settings = require 'config/game_settings'
local hexagon = require 'hexagon'
local utils = require 'utils/utils'
local graph = require 'utils/graph'
local county = require 'classes/county'

local map = Object:extend()

local left_button_pressed = false
local ref_x, ref_y

function map:new()

	self.hexagons = {}

	local tiles = self:altitude()
	tiles = self:smooth(tiles)
	tiles = self:aboveWater(tiles)
	tiles = self:extractIslands(tiles)

	local island = self:extractLargestIsland(tiles)

	for i, v in pairs(island) do
		local index = (v[1] - 1) * map_settings.n_x + v[2]
		self.hexagons[index] = hexagon(v[1], v[2], 'center')
	end

	self:extractCounties()

end

function map:extractCounties()

	self.counties = {}
	local visited = {}
	for index, hexagon in pairs(self.hexagons) do

		if visited[index] == nil then

			local m = math.modf(index / map_settings.n_x) + 1
			local n = index  - (m - 1) * map_settings.n_x
			local county_indices = {}		
			local value = hexagon.color
			table.insert(county_indices, {m, n})
			visited[index] = 1

			graph.dfs(self.hexagons, visited, county_indices, m, n, value, function(x) return x.color end)

			local county_hexagons = {}
			for i, v in pairs(county_indices) do
				local index = (v[1] - 1) * map_settings.n_x + v[2]
				county_hexagons[index] = self.hexagons[index]
			end

			table.insert(self.counties, county(county_hexagons))
		end

	end
end

function map:altitude()

	local n_x, n_y = map_settings.n_x, map_settings.n_y
	local altitude_min, altitude_max = map_settings.altitude_min, map_settings.altitude_max
	local n = (map_settings.n_x - 1) / 2
	local alpha = math.exp(math.log( altitude_max/ altitude_min) / n) - 1
	local sigma = map_settings.sigma

	local result = {}
	for i = 1, n_x do
		local row = {}
		for j = 1, n_y do

			d = math.min(math.abs(i - 1), math.abs(i - n_x), math.abs(j - 1), math.abs(j - n_y))

			mu = altitude_min * math.pow(1 + alpha, d + 1)

			r = utils.randomGauss(mu, sigma)
			table.insert(row, r)

		end

		table.insert(result, row)
	end


	return result
end

function map:smooth(tiles)

	local smooth_window_size = map_settings.smooth_window_size
	local n_x, n_y = map_settings.n_x, map_settings.n_y
	local smooth_delta = (smooth_window_size - 1) / 2
	local count = math.pow(smooth_window_size, 2)

	local result = {}
	for i, row in pairs(tiles) do

		local new_row = {}
		for j, v in pairs(row) do

			local smooth_value = 0
			for m = i - smooth_delta, i + smooth_delta do

				for n = j - smooth_delta, j + smooth_delta do

					if m < 1 or m > n_x then
						smooth_value = smooth_value + 0
					elseif n < 1 or n > n_y then
						smooth_value = smooth_value + 0
					else
						smooth_value = smooth_value + v
					end
				end
			end

			table.insert(new_row, smooth_value / count)

		end
		table.insert(result, new_row)
	end

	return result
end

function map:aboveWater(tiles)

	local threshold = map_settings.island_threshold
	local result = {}
	for i, row in pairs(tiles) do
		for j, v in pairs(row) do
			local land = 0
			if v > threshold then
				land = 1
			end
			local index = (i - 1)*map_settings.n_x + j
			result[index] = land
		end

	end

	return result
end

function map:extractIslands(tiles)

	local islands = {}
	local visited = {}
	for index, v in pairs(tiles) do

		if visited[index] == nil then

			if v == 1 then
				isle = {}
				local m = math.modf(index / map_settings.n_x) + 1
				local n = index  - (m - 1) * map_settings.n_x
				table.insert(isle, {m,n})
				graph.dfs(tiles, visited, isle, m , n, 1, function(x) return x end)

				table.insert(islands, isle)

			end

		end

	end

	return islands

end

function map:extractLargestIsland(islands)

	local result = {}
	local maximum = 0
	for i = 1, #islands do

		if #islands[i] > maximum then
			maximum = #islands[i]
			result = islands[i]
		end
	end

	return result
end

function map:draw(delta_x,delta_y)

	for i, hexagon in pairs(self.hexagons) do
		hexagon:draw(delta_x, delta_y)
	end

	for i, hexagon in pairs(self.hexagons) do
		hexagon:addText(delta_x, delta_y)
	end

	for i, county in pairs(self.counties) do
		county:draw(delta_x,delta_y)
	end
end

function map:move(delta_x, delta_y)

	if love.mouse.isDown(1) then

		local x, y = love.mouse.getX(), love.mouse.getY()
		if not left_button_pressed then
   			ref_x = x + delta_x
   			ref_y = y + delta_y
   			left_button_pressed = true
   			self.county_selected = nil
   		end
   			delta_x = ref_x - x
      		delta_y = ref_y - y
   	else
    	left_button_pressed = false
	end

	return delta_x, delta_y

end


function map:highlight(delta_x, delta_y)

	-- Unselect previous county
	for index, county in pairs(self.counties) do
		county.isHighlighted = false
	end

	local s = game_settings.size
	local y = utils.round(2*(love.mouse.getY() + delta_y - s) / (3 * s) + 1, 0)

	local h = s * math.sqrt(3) / 2

	local x = utils.round((love.mouse.getX() + delta_x - (y % 2)*h)/(2*h) + 1)

	local index = (x-1) * map_settings.n_x + y

	if self.hexagons[index] ~= nil then
		local selectedHexagon = self.hexagons[index]
		for index, county in pairs(self.counties) do

			if county:contain(selectedHexagon) then
				county.isHighlighted = true
				return
			end
		end
	end
end


return map


