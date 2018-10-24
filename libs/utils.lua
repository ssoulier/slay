local orientation = {'WEST', 'EAST', 'NORTH_WEST', 'SOUTH_WEST', 'NORTH_EAST', 'SOUTH_EAST'}

local function randomGauss(mean, variance)
	return math.sqrt(-2 * variance * math.log(math.random())) *
            math.cos(2 * math.pi * math.random()) + mean
end

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


local function randomchoice(t)
	local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key --Store keys in another table
    end
    index = keys[math.random(1, #keys)]
    return t[index]
end

local function randomweighted(weights)
	local r = math.random(0,10000) / 10000
	local cumweight = 0
	for index, weight in pairs(weights) do
		cumweight = cumweight + weight
		if r <= cumweight then
			return index
		end
	end
end

local function indextocoord(index)
	local x = math.floor(index / Settings.n_x)
	local y = index - x * Settings.n_x
	return x, y
end

local function coordtoindex(x, y)
	return x * Settings.n_x + y
end

local function beetween(elt, a, b)
	return elt >= a and elt <= b
end

local function ingrid(x, y) 
	return beetween(x, 1, Settings.n_x) and beetween(y, 1, Settings.n_y)
end

local function neighbors(elts, x, y) 

	local items = {}

	-- WEST AND EAST
	for i = -1, 1, 2 do
		if ingrid(x + i, y) then
			table.insert(items, elts[coordtoindex(x + i, y)])
		end
	end

	local delta = y % 2
	-- NORTH WEST, NORT EASTH, SOUTH WEST, SOUTH EAST
	for i = -1, 0 do
		for j = -1, 1, 2 do
			if ingrid(x + delta + i, y + j) then
				table.insert(items, elts[coordtoindex(x + delta + i, y + j)])
			end
		end
	end

	local i = 0
	return function()
		while true do
			i = i + 1
			return items[i], orientation[i]
		end
	end
end

local function neighborsindex(x, y)

	local indexes = {}

	-- WEST AND EAST
	for i = -1, 1, 2 do
		table.insert(indexes, coordtoindex(x + i, y))
	end

	local delta = y % 2
	-- NORTH WEST, NORTH EAST, SOUTH WEST, SOUTH EAST
	for i = -1, 0 do
		for j = -1, 1, 2 do
			table.insert(indexes, coordtoindex(x + delta + i, y + j))
		end
	end

	local i = 0
	return function()
		while true do
			i = i + 1
			return indexes[i], orientation[i]
		end
	end

end

local function tablesize(t)

	local result = 0
	for _, _ in pairs(t) do
		result = result + 1
	end

	return result

end

local function dfs(elts, x, y, output, visited, goal)

	local elt = elts[coordtoindex(x, y)]
	if not visited[coordtoindex(x, y)] then
		if goal(elt) then
			visited[coordtoindex(x, y)] = true
			output[coordtoindex(x, y)] = elt
		end
	end

	for elt in neighbors(elts, x, y) do

		if not visited[coordtoindex(elt.x, elt.y)] then

			if goal(elt) then
				visited[coordtoindex(elt.x, elt.y)] = true
				output[coordtoindex(elt.x, elt.y)] = elt
				dfs(elts, elt.x, elt.y, output, visited, goal)
			end
		end
	end
end

local function center(x, y)

	local h = tile_size * math.sqrt(3) / 2


	local cx = 2*h*(x - 1) + ( y % 2) * h
	local cy = tile_size + 3*(y-1)*tile_size/2

	return cx, cy
end


function pixelTocenter(px, py)

	local wx, wy = screenToWorld(px, py)
	local y = round(2*(wy - tile_size) / (3 * tile_size) + 1, 0)
	local h = tile_size * math.sqrt(3) / 2
	local x = round((wx - (y % 2)*h)/(2*h) + 1)

	return x, y
end

function screenToWorld(sx, sy)
	return sx-translationX, sy-translationY
end


function vertices(x, y, size)

	local h = size * math.sqrt(3) / 2

	local cx, cy = Utils.center(x, y)

	local vertices = {
		cx, cy - size,
		cx - h, cy - size / 2,
		cx - h, cy + size / 2,
		cx, cy + size,
		cx + h, cy + size / 2,
		cx + h, cy - size/2,
	}

	return vertices

end


local utils = {
	['randomchoice'] = randomchoice,
	['round'] = round,
	['randomGauss'] = randomGauss,
	['indextocoord'] = indextocoord,
	['coordtoindex'] = coordtoindex,
	['neighbors'] = neighbors,
	['neighborsindex'] = neighborsindex,
	['dfs'] = dfs,
	['tablesize'] = tablesize,
	['randomweighted'] = randomweighted,
	['center'] = center,
	['pixelTocenter'] = pixelTocenter,
	['vertices'] = vertices
}

return utils