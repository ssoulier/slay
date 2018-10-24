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

function world:attacked(tile_attacked)

	-- Change the tile_attacked
	tile_attacked:attacked(self.floating_soldier)

	-- Find the county the tile_attacked belongs
	local county_attacked = nil
	for _, county in ipairs(self.counties) do
		if county:contain(tile_attacked) then
			county_attacked = county
			break
		end
	end

	-- Does this attack split the county_attacked
	local count_neighbors = 0
	for _ in Utils.neighbors(county_attacked.tiles, tile_attacked.x, tile_attacked.y) do
		count_neighbors = count_neighbors + 1
	end

	if count_neighbors == 2 then

		-- The county_attacked is splited
	else
		print('I am here')
		county_attacked:remove(tile_attacked)
		self.selected_county:add(tile_attacked)

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