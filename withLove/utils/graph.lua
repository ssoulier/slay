local map_settings = require('config/map_settings')

local graph = {}

graph.createHexIndex = function(x, y)

	return (x-1) * map_settings.n_x + y

end

graph.createHexCoordinates = function(index)

	local x = math.modf(index / map_settings.n_x) + 1
	local y = index  - (x - 1) * map_settings.n_x

	return x, y

end

local testDFS = function(tiles, visited, isle, i, j, value, property)

	if i >= 1 and i <= map_settings.n_x and j >= 1 and j <= map_settings.n_y then
		local index = graph.createHexIndex(i, j)

		if index > 0 and tiles[index] ~= nil then

			if visited[index] == nil then

				if property(tiles[index]) == value then

					if visited[index] == nil then
						visited[index] = {}
					end

					visited[index] = 1

					table.insert(isle, {i,j})

					graph.dfs(tiles, visited, isle, i, j, value, property)

				end
			end

		end
	end
end

graph.dfs = function(tiles, visited, isle, m, n, value, property)

	local delta = n % 2
	testDFS(tiles, visited, isle, m, n, value, property)					-- (x , y)
	testDFS(tiles, visited, isle, m - 1, n, value, property)				-- (x-1 , y)
	testDFS(tiles, visited, isle, m + 1, n, value, property) 				-- (x+1 , y)
	testDFS(tiles, visited, isle, m - 1 + delta, n - 1, value, property) 	-- (x-1 , y - 1)
	testDFS(tiles, visited, isle, m + delta, n - 1, value, property) 		-- (x , y - 1)
	testDFS(tiles, visited, isle, m + delta, n + 1, value, property) 		-- (x , y + 1)
	testDFS(tiles, visited, isle, m - 1 + delta, n + 1, value, property) 	-- (x-1 , y)

end

return graph