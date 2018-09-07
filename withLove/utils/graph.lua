local map_settings = require('config/map_settings')

local graph = {}

local testDFS = function(tiles, visited, isle, i, j, value, property)

	local index = (i-1) * map_settings.n_x + j

	if tiles[index] ~= nil then

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

graph.dfs = function(tiles, visited, isle, m, n, value, property)

	local delta = n % 2
	testDFS(tiles, visited, isle, m - 1, n, value, property)				-- (x-1 , y)
	testDFS(tiles, visited, isle, m + 1, n, value, property) 				-- (x+1 , y)
	testDFS(tiles, visited, isle, m - 1 + delta, n - 1, value, property) 	-- (x-1 , y - 1)
	testDFS(tiles, visited, isle, m + delta, n - 1, value, property) 		-- (x , y - 1)
	testDFS(tiles, visited, isle, m + delta, n + 1, value, property) 		-- (x , y + 1)
	testDFS(tiles, visited, isle, m - 1 + delta, n + 1, value, property) 	-- (x-1 , y)

end

return graph