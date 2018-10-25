local world = Class{}


function world:init(tiles)

	self.tiles = tiles
	self.counties = {}
	local visited = {}
	for index, tile in pairs(tiles) do

		if not visited[index] then

			local function goal(elt)
				return elt.player_id == tile.player_id
			end

			local county_tiles = {}
			Utils.dfs(tiles, tile.x, tile.y, county_tiles, visited, goal)

			table.insert(self.counties, County(county_tiles))

		end

	end

	self.selected_county = nil
	self.green_tile = nil
	self.red_tile = nil

end

function world:mousemoved(x, y)

	if self.floating_soldier then

		-- get the tile
		local x, y = Utils.pixelTocenter(x, y)
		local index = Utils.coordtoindex(x, y)
		local selected_tile = self.tiles[index]
		
		self:updateFloatingSoldier(selected_tile)
		
	end

end

function world:updateFloatingSoldier(tile)

	if self.selected_county:canAttack(tile, self.floating_soldier) then
		self.green_tile = tile
		self.red_tile = nil
	else
		self.green_tile = nil
		self.red_tile = tile
	end

end

function world:resetFlotingSoldier()

	self.floating_soldier = nil
	self.green_tile = nil
	self.red_tile = nil
end

function world:tileClicked(x, y)

	local x, y = Utils.pixelTocenter(x, y)
	local index = Utils.coordtoindex(x, y)
	local selected_tile = self.tiles[index]

	if selected_tile then 

		if self.selected_county and self.selected_county:contain(selected_tile) then
			self.floating_soldier = Soldier(selected_tile.player_id, true, 1)
			self:updateFloatingSoldier(selected_tile)
		elseif self.floating_soldier then
			if self.selected_county:canAttack(selected_tile, self.floating_soldier) then

				self:attacked(selected_tile)
				self:resetFlotingSoldier()
			end
		else
			if self.selected_county then
				self.selected_county:unselect()
			end

			for _, county in ipairs(self.counties) do

				if county:contain(selected_tile) then
					county:select()
					self.selected_county = county
					break
				end
			end
		end
	end
end

function world:findcounty(tile)

	for index, county in pairs(self.counties) do
		if county:contain(tile) then
			return index, county
		end
	end

end


function world:attacked(tile_attacked)

	-- Change the tile_attacked
	tile_attacked:attacked(self.floating_soldier)

	-- Find the county the tile_attacked belongs
	local county_attacked_index, county_attacked = self:findcounty(tile_attacked)

	-- Handle attacked county

	county_attacked:remove(tile_attacked)
	local counties = {}
	local visited = {}
	for index, tile in pairs(county_attacked.tiles) do

		if not visited[index] then

			local function goal(elt)
				return elt.player_id == tile.player_id
			end

			local county_tiles = {}
			Utils.dfs(county_attacked.tiles, tile.x, tile.y, county_tiles, visited, goal)

			if Utils.tablesize(county_tiles) > 0 then
				table.insert(counties, County(county_tiles))
			end

		end
	end


	table.remove(self.counties, county_attacked_index)
	for _, county in ipairs(counties) do
		table.insert(self.counties, county)
	end

	-- Handle selected county

	self.selected_county:add(tile_attacked)

	local added_county = {}
	for tile in Utils.neighbors(tiles, tile_attacked.x, tile_attacked.y) do
		if not self.selected_county:contain(tile) then
			if tile.player_id == tile_attacked.player_id then
				local neighbor_county_index, neighbor_county = self:findcounty(tile)
				if not added_county[neighbor_county_index] then
					self.selected_county:concatenate(neighbor_county)
					added_county[neighbor_county_index] = neighbor_county_index
				end
			end
		end
	end

	for county_index, _ in pairs(added_county) do
		table.remove(self.counties, county_index)
	end

end


function world:draw()

	for _, county in ipairs(self.counties) do

		county:draw()

	end

	if self.floating_soldier then
		self.floating_soldier:draw()
	end

	if self.green_tile then
		self.green_tile:highlight('good')
	end

	if self.red_tile then
		self.red_tile:highlight('bad')
	end

end

return world