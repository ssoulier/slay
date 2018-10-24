local tile = Class{}


function tile:init(x, y)

	self.x = x
	self.y = y

	self.player_id = nil
	self.town = nil
	self.tree = nil
	self.tower = nil
	self.soldier = nil

end

function tile:isfree()

	if self.soldier then
		return not (self.soldier.level == Settings.level_max)
	end

	return self.town == nil and self.tower == nil 

end

function tile:attacked(soldier)

	self.player_id = soldier.player_id
	self:addSoldier(soldier)

end

function tile:addSoldier(floating_soldier)

	if self.soldier then
		self.soldier:increaseLevel()
	else
		self.soldier = Soldier(floating_soldier.player_id, false, floating_soldier.level, self.x, self.y)
	end

end

function tile:defense()

	local soldier_defense = 0
	if self.soldier then
		soldier_defense = self.soldier.level
	end

	local town_defense = 0
	if self.town then
		town_defense = 1
	end

	local tower_defense = 0
	if self.tower then
		tower_defense = self.tower.level
	end

	return math.max(0, soldier_defense, town_defense, tower_defense)

end

function tile:vertices()
	
	return Utils.vertices(self.x, self.y, tile_size)
end

function tile:edge(orientation)

	local vertices = self:vertices()


	if orientation == 'WEST' then
		return vertices[3], vertices[4], vertices[5], vertices[6]
	elseif orientation == 'EAST' then
	    return vertices[9], vertices[10], vertices[11], vertices[12]
   	elseif orientation == 'NORTH_WEST' then
    	return vertices[1], vertices[2], vertices[3], vertices[4]
    elseif orientation == 'NORTH_EAST' then
    	return vertices[11], vertices[12], vertices[1], vertices[2]
    elseif orientation == 'SOUTH_WEST' then
    	return vertices[5], vertices[6], vertices[7], vertices[8]
    elseif orientation == 'SOUTH_EAST' then
    	return vertices[7], vertices[8], vertices[9], vertices[10]
	end

end

function tile:highlight(color)

	local vertices = Utils.vertices(self.x, self.y, tile_size - 4)
	love.graphics.push('all')
	love.graphics.setColor(Settings.colors[color])
	love.graphics.setLineWidth(3)
	love.graphics.polygon('line', vertices)
	love.graphics.pop()

end

function tile:draw()

	local vertices = self:vertices()
	
	love.graphics.push('all')
	love.graphics.setColor(Settings.colors[self.player_id])
	love.graphics.polygon('fill', vertices)
	love.graphics.setColor(Settings.colors['tile_edge'])
	love.graphics.polygon('line', vertices)
	love.graphics.pop()


	if self.tower then
		self.tower:draw()
	end

	if self.soldier then
		self.soldier:draw()
	end

end

return tile