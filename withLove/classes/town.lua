local Object = require 'utils/classic'
local game_settings = require 'config/game_settings'
local draw = require 'utils/draw'

local town = Object:extend()


function town:new(hexagon)

	self.x = hexagon.x
	self.y = hexagon.y

end

function town:center()

	return draw.center(self.x, self.y)

end

function town:roof()



end

function town:wall()


end

function town:vertices()

	--local h = s * math.sqrt(3) / 2
	local x_size = s * 0.7
	--h = x_size * math.sqrt(3) / 2
	local h = 0.618 * x_size
	local y_size = x_size  + h

	local cx, cy = self:center()


	local vertices = {
		cx - x_size / 2, cy - y_size / 2 + h,
		cx, cy - y_size / 2,
		cx + x_size / 2, cy - y_size / 2 + h,
		cx + x_size / 2, cy + y_size / 2,
		cx - x_size / 2,  cy + y_size / 2
	}

	return vertices

end


function town:draw()

	local vertices = self:vertices()

	love.graphics.push()
	love.graphics.setColor(0.05,0.05,0.05, 0.7)
	love.graphics.polygon('line',vertices)
	love.graphics.pop()

end

return town