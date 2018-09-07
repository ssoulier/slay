local Object = require 'utils/classic'
local game_settings = require 'config/game_settings'



local hex = Object:extend()

function hex:new(x, y, type)

	self.x = x
	self.y = y
	self.isHighlighted = false

	self.type = type

	self.color = math.random(2,4)
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

function hex:center(delta_x, delta_y)
	local s = game_settings.size
	local h = s * math.sqrt(3) / 2


	local cx = 2*h*(self.x - 1) + ( self.y % 2) * h
	local cy = s + 3*(self.y-1)*s/2

	return cx - delta_x, cy - delta_y
end

function hex:vertices(delta_x, delta_y)
	local s = game_settings.size
	local h = s * math.sqrt(3) / 2

	local cx, cy = self:center(delta_x, delta_y)

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

function hex:draw(delta_x, delta_y)

	local vertices = self:vertices(delta_x, delta_y)
	
	if self.type == 'center' then

		love.graphics.setColor(game_settings.colors[self.color])
		love.graphics.polygon('fill', vertices)
		love.graphics.setColor(1,1,1)
		love.graphics.polygon('line', vertices)
	else
		
		love.graphics.setColor(1,1,1)
		love.graphics.polygon('line', vertices)
	end

end

function hex:addText(delta_x, delta_y)

	local cx, cy = self:center(delta_x, delta_y)
	local text = self.x .. ','  .. self.y
	local width = font:getWidth(text)
	local height = font:getHeight()
	love.graphics.print(text, math.floor(cx - width / 2), math.floor(cy - height / 2))
end

return hex