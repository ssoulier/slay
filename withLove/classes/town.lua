local Object = require 'utils/classic'
local game_settings = require 'config/game_settings'
local draw = require 'utils/draw'

local town = Object:extend()


function town:new(hexagon)

	self.x = hexagon.x
	self.y = hexagon.y

end

function town:center(delta_x, delta_y)

	return draw.center(self.x, self.y, delta_x, delta_y, game_settings.size)

end

function town:roof(delta_x, delta_y)



end

function town:wall(delta_x, delta_y)


end

function town:vertices(delta_x, delta_y)

	local s = game_settings.size
	--local h = s * math.sqrt(3) / 2
	local x_size = s * 0.7
	--h = x_size * math.sqrt(3) / 2
	local h = 0.618 * x_size
	local y_size = x_size  + h

	local cx, cy = self:center(delta_x, delta_y)


	return {
		cx - x_size / 2, cy - y_size / 2 + h,
		cx, cy - y_size / 2,
		cx + x_size / 2, cy - y_size / 2 + h,
		cx + x_size / 2, cy + y_size / 2,
		cx - x_size / 2,  cy + y_size / 2
	}

end


function town:draw(delta_x, delta_y)

	local vertices = self:vertices(delta_x, delta_y)

	love.graphics.setColor(0.05,0.05,0.05, 0.7)
	love.graphics.polygon('line',vertices)
	love.graphics.setColor(1,1,1)

end

return town