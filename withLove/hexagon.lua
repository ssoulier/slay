local game_settings = require 'config/game_settings'
local draw = require 'utils/draw'



local hex = Class{}

function hex:init(x, y)

	self.x = x
	self.y = y

	self.color = math.random(2,#game_settings.colors)
	self.soldier = nil
	self.town = nil

	--self:setColor()
	
end

function hex:isNeighbour(hexagon)

	local delta = self.y % 2

	local y = 0
	for x = -1, 1, 2 do
		if self.x + x == hexagon.x and self.y == hexagon.y then
			return true
		end
	end 

	for x = -1, 0 do
		for y = -1, 1, 2 do
			if self.x + x + delta == hexagon.x and self.y + y == hexagon.y then
				return true
			end
		end
	end

	return false

end

function hex:addSoldier(soldier)

	self.soldier = soldier

end

function hex:addTown(town)
	self.town = town
end

function hex:isFree()

	local delta = self.y % 2
	local y = 0
	for x = -1, 1 do
		local index = graph.createHexIndex(self.x + x, self.y)
		local hex = world.hexagons[index]
		if hex ~= nil then
			if self.color == hex.color and (hex.soldier ~= nil or hex.town ~= nil) then
				return false
			end
		end
	end 

	for x = -1, 0 do
		for y = -1, 1, 2 do
			local index = graph.createHexIndex(self.x + x + delta, self.y + y)
			local hex = world.hexagons[index]
			if hex ~= nil then
				if self.color == hex.color and (hex.soldier ~= nil or hex.town ~= nil) then
					return false
				end
			end
		end
	end

	return true

end

function hex:setColor()

	local r_value = math.random(1,100)
	local temp = 0
	for i, v in pairs(game_settings.probability) do
		temp = temp + v
		if r_value <= temp then
			self.color = i
			break
		end
	end

end

function hex:center()
	return draw.center(self.x, self.y)
end

function hex:vertices()
	local h = s * math.sqrt(3) / 2

	local cx, cy = self:center()

	local vertices = {
		cx, cy - s,
		cx - h, cy - s / 2,
		cx - h, cy + s / 2,
		cx, cy + s,
		cx + h, cy + s / 2,
		cx + h, cy - s/2,
	}

	return vertices
end

function hex:draw()

	local vertices = self:vertices()
	
	love.graphics.push()
	love.graphics.setColor(game_settings.colors[self.color])
	love.graphics.polygon('fill', vertices)
	love.graphics.setColor(1,1,1)
	love.graphics.polygon('line', vertices)
	love.graphics.pop()

end

function hex:addText()

	local cx, cy = self:center()
	local text = self.x .. ','  .. self.y
	local width = fonts.hex:getWidth(text)
	local height = fonts.hex:getHeight()

	local sx, sy = cx - width / 2, cy - height / 2
	love.graphics.print(text, math.floor(sx), math.floor(sy))
end

return hex