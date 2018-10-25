local county = Class{}


function county:init(tiles)

	self.tiles = tiles
	self.edges = nil
	self.town = nil
	self:attributetown()
	self.highlighted = false

end

function county:size()

	return Utils.tablesize(self.tiles)

end

function county:attributetown()

	if self:size() >= 2 then
		local containTown = false
		for _, tile in pairs(self.tiles) do
			if tile.town then
				self.town = tile.town
				containTown = true
				break
			end
		end

		if not containTown then

			local tile = Utils.randomchoice(self.tiles)
			tile.town = Town(tile.x, tile.y)
			self.town = tile.town
		end
	else
		for _, tile in pairs(self.tiles) do
			if tile.town then
				tile.town = nil
				self.town = nil
			end
		end
	end
end

function county:canAttack(tile, soldier)

	if not tile then
		return false
	end

	if self:contain(tile) and tile:isfree() then
		return true
	end

	local tile_index = Utils.coordtoindex(tile.x, tile.y)
	if not self:isneighbor(tile) then
		return false
	end

	if not (soldier.level > tile:defense()) then
		return false
	end 

	for neighbor_tile in Utils.neighbors(tiles, tile.x, tile.y) do
		if neighbor_tile.player_id == tile.player_id then
			if not (soldier.level > neighbor_tile:defense()) then
				return false
			end
		end
	end

	return true

end

function county:isneighbor(tile)

	for _, county_tile in pairs(self.tiles) do
		for neighbor_tile in Utils.neighbors(tiles, county_tile.x, county_tile.y) do
			if neighbor_tile == tile then
				return true
			end
		end
	end

	return false

end


function county:draw()

	if self.highlighted then
		self:computeEdges()
		love.graphics.push('all')
		love.graphics.setColor(Settings.colors['county_edge'])
		love.graphics.setLineWidth(2)
		for _, line in ipairs(self.edges) do		
			love.graphics.line(line)
		end
		love.graphics.pop()	
	end

	if self.town then
		self.town:draw()
	end

end

function county:concatenate(other_county)

	for index, tile in pairs(other_county.tiles) do
		tile.town = nil
		self.tiles[index] = tile
	end

end

function county:add(tile)

	self.tiles[Utils.coordtoindex(tile.x, tile.y)] = tile

end

function county:remove(tile)

	self.tiles[Utils.coordtoindex(tile.x, tile.y)] = nil

end

function county:contain(tile)

	return self.tiles[Utils.coordtoindex(tile.x, tile.y)]

end

function county:unselect()
	self.highlighted = false
end

function county:select()
	self.highlighted = true
end

function county:computeEdges()

	self.edges = {}
	for _, tile in pairs(self.tiles) do

		for index, orientation in Utils.neighborsindex(tile.x, tile.y) do

			if not self.tiles[index] then
				table.insert(self.edges, {tile:edge(orientation)})
			end

		end

	end

end


return county