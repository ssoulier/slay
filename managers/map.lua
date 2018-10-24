function generateMap()

	--- GENERATE RANDOM ALTITUDE EVERYWHERE ON THE GRID (HIGHER IN THE CENTER)

	local n = (Settings.n_x - 1) / 2
	local alpha = math.exp(math.log(Settings.altitude_max / Settings.altitude_min) / n) - 1

	local map_altitude = {}
	for i = 1, Settings.n_x do
		for j = 1, Settings.n_y do
			local d = math.min(math.abs(i - 1), math.abs(i - Settings.n_x), math.abs(j - 1), math.abs(j - Settings.n_y))
			local mu = Settings.altitude_min * math.pow( 1 + alpha, d + 1)
			local r = Utils.randomGauss(mu, Settings.sigma)
			map_altitude[Utils.coordtoindex(i, j)] = r
		end
	end

	--- SMOOTH THIS ALTITUDE WITH NEIGHBORS
	local smooth_delta = (Settings.smooth_window_size - 1) / 2
	local smooth_count = math.pow(Settings.smooth_window_size, 2)
	local map_smooth_altitude = {}
	for x = 1, Settings.n_x do
		for y = 1, Settings.n_y do
			local smooth_altitude = 0
			for i = x - smooth_delta, x + smooth_delta do
				for  j = y -smooth_delta, y + smooth_delta do

					local altitude = map_altitude[Utils.coordtoindex(i,j)]
					if altitude then smooth_altitude = smooth_altitude + altitude end

				end
			end
			map_smooth_altitude[Utils.coordtoindex(x, y)] = smooth_altitude / smooth_count
		end
	end


	--- CREATE ISLES BY ADDING WATER BELOW AN ALTITUDE MIN
	local map_islands = {}
	for x = 1, Settings.n_x do
		for y = 1, Settings.n_y do
			local altitude = map_smooth_altitude[Utils.coordtoindex(x, y)]
			local elt = {x=x, y=y}
			if altitude >= Settings.island_threshold then
				elt['value'] = 1
			else
				elt['value'] = 0
			end
			map_islands[Utils.coordtoindex(x, y)] = elt
		end
	end

	--- EXTRACT ALL ISLANDS
	local function goal(elt)
		return elt.value == 1
	end

	local islands = {}
	local visited = {}
	for x = 1, Settings.n_x do
		for y = 1, Settings.n_y do
			if not visited[Utils.coordtoindex(x, y)] then
				if goal(map_islands[Utils.coordtoindex(x, y)]) then
					local isle = {}
					Utils.dfs(map_islands, x, y, isle, visited, goal)
					table.insert(islands, isle)
				end
			end
		end
	end

	--- KEEP THE LARGEST ISLAND
	local maxindex = 0
	local maxsize = 0
	for index, isle in pairs(islands) do
		local size =  Utils.tablesize(isle)
		if  size > maxsize then
			maxsize = size
			maxindex = index
		end
	end

	local island = islands[maxindex]

	--- ATTRIBUTE TILES

	-- init players_tiles counter
	local player_tiles_counter = {}
	for i = 1, Settings.players do
		table.insert(player_tiles_counter, 0)
	end

	-- create tiles
	local map = {}
	local tile_attributed_counter = 0
	for x = 1, Settings.n_x do
		for y = 1, Settings.n_y do
			if island[Utils.coordtoindex(x, y)] then

				-- create weighted probability for player_id
				local weights = {}
				for _, player_tile_count in ipairs(player_tiles_counter) do
					local weight = (maxsize / Settings.players - player_tile_count) / ( maxsize - tile_attributed_counter)
					table.insert(weights, weight)
				end

				local player_id = Utils.randomweighted(weights)
				player_tiles_counter[player_id] = player_tiles_counter[player_id] + 1
				tile_attributed_counter = tile_attributed_counter + 1
				local index = Utils.coordtoindex(x, y)
				map[index] = Tile(x, y)
				map[index].player_id = player_id

			end

		end
	end

	for player_id, tile_counter in ipairs(player_tiles_counter) do
		print(player_id .. ' : ' .. tile_counter)
	end
	return map

end


local mapManager = {
	['generateMap'] = generateMap
}


return mapManager