local graph = {}


local testDFS = function(tiles, visited, isle, i, j, threshold)

	if tiles[i] ~= nil and tiles[i][j] ~= nil then

		if visited[i] == nil or visited[i][j] == nil then

			if tiles[i][j] > threshold then

				if visited[i] == nil then
					visited[i] = {}
				end

				visited[i][j] = 1

				table.insert(isle, {i , j})

				graph.dfs(tiles, visited, isle, i, j, threshold)

			end
		end

	end
end

graph.dfs = function(tiles, visited, isle, m, n, threshold)

	local delta = n % 2
	testDFS(tiles, visited, isle, m - 1, n, threshold) 				-- (x-1 , y)
	testDFS(tiles, visited, isle, m + 1, n, threshold) 				-- (x+1 , y)
	testDFS(tiles, visited, isle, m - 1 + delta, n - 1, threshold) 	-- (x-1 , y - 1)
	testDFS(tiles, visited, isle, m + delta, n - 1, threshold) 		-- (x , y - 1)
	testDFS(tiles, visited, isle, m + delta, n + 1, threshold) 		-- (x , y + 1)
	testDFS(tiles, visited, isle, m - 1 + delta, n + 1, threshold) 	-- (x-1 , y)

end

return graph