local Object = require 'utils/classic'
local game_settings = require 'config/game_settings'
local draw = require 'utils/draw'



local hex = Object:extend()

function hex:new(x, y)

	self.x = x
	self.y = y

	self.color = math.random(2,#game_settings.colors)

	--self:setColor()
	
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
	local width = font:getWidth(text)
	local height = font:getHeight()

	local sx, sy = cx - width / 2, cy - height / 2
	love.graphics.print(text, math.floor(sx), math.floor(sy))
end

return hex