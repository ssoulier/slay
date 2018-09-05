local Object = require 'utils/classic'
local map_settings = require 'config/map_settings'
local hexagon = require 'hexagon'
local gauss = require 'utils/gauss'

map = Object:extend()

local left_button_pressed = false
local ref_x, ref_y

function map:new()

	self.hexagons = {}
	local island = self:extractLargestIsland(self:extractIslands(self:smooth(self:altitude())))

	for i, v in pairs(island) do
		print(v[1],v[2])
		table.insert(self.hexagons, hexagon(v[1], v[2], 'center'))
	end

	--[[for i  = 1, map_settings.n_x do
		for j = 1, map_settings.n_y do
			table.insert(self.hexagons, hexagon(i,j, 'line'))
		end
	end--]]

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

			r = gauss.random(mu, sigma)

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

function map:extractIslands(tiles)

	local threshold = map_settings.island_threshold

	local graph = require 'utils/graph'

	local islands = {}
	local visited = {}
	for i, row in pairs(tiles) do

		for j, v in pairs(row) do

			if visited[i] == nil or visited[i][j] == nil then

				if v > threshold then
					isle = {}

					graph.dfs(tiles, visited, isle, i, j, threshold)

					table.insert(islands, isle)

				end

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

	for i = 1, #self.hexagons do
		self.hexagons[i]:draw(delta_x, delta_y)
	end

	for i = 1, #self.hexagons do
		self.hexagons[i]:addText(delta_x, delta_y)
	end

end

function map:update(dt, delta_x, delta_y)

	if love.mouse.isDown(1) then

		local x, y = love.mouse.getX(), love.mouse.getY()
		if not left_button_pressed then
   			ref_x = x + delta_x
   			ref_y = y + delta_y
   			left_button_pressed = true
   		end
   			delta_x = ref_x - x
      		delta_y = ref_y - y
   	else
    	left_button_pressed = false
	end

	return delta_x, delta_y

end


return map